#!/usr/bin/env python3
"""Structural inspection of S-100 exchange sets and datasets.

  inspect_s100.py PATH [--xsd SCHEMA.xsd] [--json]

PATH may be:
  * an exchange set (a folder containing S100_ROOT/ or CATALOG.XML)
  * a GML dataset (.gml/.GML) – S-124, S-127, S-128, S-131, S-122, S-123 ...
  * an HDF5 dataset (.h5) – S-102, S-104, S-111 ... (needs h5py)
  * a CATALOG.XML file

It prints a summary and a list of findings tagged ERROR / WARN / INFO. The findings are
structural only (file references, ids, xlinks, naming, required metadata present). They do
not replace a full S-158 validation; map findings to S-158 checks with `s100.py check`.

stdlib only; lxml (XSD validation) and h5py (HDF5) are used when installed.
"""
import argparse
import json
import re
import sys
import xml.etree.ElementTree as ET
from collections import Counter
from pathlib import Path

XLINK = "{http://www.w3.org/1999/xlink}href"
GML_ID = "{http://www.opengis.net/gml/3.2}id"
XSI_LOC = "{http://www.w3.org/2001/XMLSchema-instance}schemaLocation"

findings = []


def report(level, msg):
    findings.append((level, msg))


def ln(tag):
    return tag.rsplit("}", 1)[-1] if isinstance(tag, str) else ""


def ns(tag):
    return tag[1:].split("}", 1)[0] if isinstance(tag, str) and tag.startswith("{") else ""


def first_text(el, name):
    for c in el.iter():
        if ln(c.tag) == name and c.text and c.text.strip():
            return c.text.strip()
    return None


# ----------------------------------------------------------------------------- XSD

def xsd_validate(xml_path, xsd):
    try:
        from lxml import etree
    except ImportError:
        report("INFO", "lxml not installed – XSD validation skipped (pip install lxml, or use xmllint --schema)")
        return
    try:
        schema = etree.XMLSchema(etree.parse(str(xsd)))
    except Exception as e:  # schema imports often need network or an XML catalog
        report("WARN", f"could not load schema {xsd}: {e}")
        return
    doc = etree.parse(str(xml_path))
    if schema.validate(doc):
        report("INFO", f"{xml_path.name}: XSD valid against {xsd}")
    else:
        for err in list(schema.error_log)[:50]:
            report("ERROR", f"{xml_path.name}:{err.line}: XSD: {err.message}")


# ----------------------------------------------------------------------------- GML

def inspect_gml(path, summary):
    try:
        tree = ET.parse(path)
    except ET.ParseError as e:
        report("ERROR", f"{path.name}: not well-formed XML: {e}")
        return
    root = tree.getroot()
    s = summary.setdefault("gml", {})[path.name] = {}
    s["root"] = ln(root.tag)
    s["namespace"] = ns(root.tag)
    s["schemaLocation"] = root.get(XSI_LOC)
    m = re.search(r"/S(\d{3})/(?:gml/)?(\d+\.\d+)", s["namespace"] or "", re.I)
    if m:
        s["product_from_namespace"] = f"S-{m.group(1)} {m.group(2)}"
    if not s["schemaLocation"]:
        report("INFO", f"{path.name}: no xsi:schemaLocation on root")

    dii = next((e for e in root.iter() if ln(e.tag) == "DatasetIdentificationInformation"), None)
    if dii is None:
        report("WARN", f"{path.name}: no DatasetIdentificationInformation (S-100 Part 10b)")
    else:
        info = {ln(c.tag): (c.text or "").strip() for c in dii}
        s["datasetIdentification"] = info
        for req in ("encodingSpecification", "encodingSpecificationEdition", "productIdentifier", "productEdition",
                    "datasetFileIdentifier", "datasetTitle", "datasetReferenceDate", "datasetLanguage",
                    "datasetTopicCategory"):
            if not info.get(req):
                report("WARN", f"{path.name}: DatasetIdentificationInformation/{req} missing or empty")
        fid = info.get("datasetFileIdentifier")
        if fid and fid != path.name:
            report("WARN", f"{path.name}: datasetFileIdentifier '{fid}' differs from the file name")

    env = next((e for e in root.iter() if ln(e.tag) == "Envelope"), None)
    s["srsName"] = env.get("srsName") if env is not None else None

    ids = Counter(e.get(GML_ID) for e in root.iter() if e.get(GML_ID))
    dups = [i for i, n in ids.items() if n > 1]
    for d in dups[:20]:
        report("ERROR", f"{path.name}: duplicate gml:id '{d}'")
    hrefs = [(ln(e.tag), e.get(XLINK)) for e in root.iter() if e.get(XLINK)]
    for tag, h in hrefs:
        if h.startswith("#") and h[1:] not in ids:
            report("ERROR", f"{path.name}: <{tag}> xlink:href '{h}' does not resolve to a gml:id in the file")

    members = Counter()
    for container in root:
        if ln(container.tag) in ("members", "member", "imember"):
            for m_ in (container if ln(container.tag) == "members" else container):
                members[ln(m_.tag)] += 1
    if not members:  # older encodings put features directly under <member>/<imember>
        for e in root.iter():
            if ln(e.tag) in ("member", "imember"):
                for c in e:
                    members[ln(c.tag)] += 1
    s["members"] = dict(members)
    s["gml_ids"] = len(ids)
    s["xlinks"] = len(hrefs)
    srs = Counter(e.get("srsName") for e in root.iter() if e.get("srsName"))
    s["srsNames"] = dict(srs)


# ----------------------------------------------------------------------------- HDF5

HDF5_ROOT_ATTRS = ["productSpecification", "issueDate", "horizontalCRS", "westBoundLongitude", "eastBoundLongitude",
                   "southBoundLatitude", "northBoundLatitude"]


def inspect_h5(path, summary):
    try:
        import h5py
    except ImportError:
        report("INFO", f"{path.name}: h5py not installed – HDF5 inspection skipped (pip install h5py)")
        return
    s = summary.setdefault("hdf5", {})[path.name] = {}
    with h5py.File(path, "r") as f:
        def val(v):
            if isinstance(v, bytes):
                return v.decode(errors="replace")
            try:
                return v.item() if hasattr(v, "item") and getattr(v, "size", 2) == 1 else str(v)
            except Exception:
                return str(v)

        s["root_attributes"] = {k: val(v) for k, v in f.attrs.items()}
        for a in HDF5_ROOT_ATTRS:
            if a not in f.attrs:
                report("WARN", f"{path.name}: root attribute '{a}' missing (S-100 Part 10c Table 10c-6 / PS Table 12.1)")
        if "Group_F" not in f:
            report("ERROR", f"{path.name}: no Group_F (feature information group)")
        else:
            gf = f["Group_F"]
            s["Group_F"] = list(gf.keys())
            if "featureCode" in gf:
                codes = [val(x) for x in gf["featureCode"][()]]
                s["featureCode"] = codes
                for c in codes:
                    if c not in f:
                        report("ERROR", f"{path.name}: featureCode '{c}' listed in Group_F but no root group '{c}'")
        tree, seen = [], Counter()

        def walk(name, obj):
            depth = name.count("/")
            key = re.sub(r"_\d+$", "_NNN", name)
            seen[key] += 1
            if depth <= 2 and seen[key] <= 2:
                kind = "dataset" + str(getattr(obj, "shape", "")) if isinstance(obj, h5py.Dataset) else "group"
                tree.append(f"{'  ' * depth}{name.split('/')[-1]} [{kind}] attrs={list(obj.attrs.keys())[:12]}")

        f.visititems(walk)
        s["tree"] = tree[:200]
        s["repeated_groups"] = {k: n for k, n in seen.items() if n > 2 and k.count("/") <= 2}
    m = re.match(r"^(\d{3})([A-Z0-9]{4})", path.name)
    if not m:
        report("WARN", f"{path.name}: file name does not start with <product 3 digits><producer code 4 chars>")


# ----------------------------------------------------------------------------- exchange catalogue

def inspect_catalog(cat, summary, xsd=None):
    root_dir = cat.parent
    try:
        root = ET.parse(cat).getroot()
    except ET.ParseError as e:
        report("ERROR", f"{cat}: not well-formed XML: {e}")
        return
    s = summary["catalogue"] = {"file": str(cat), "namespace": ns(root.tag), "schemaLocation": root.get(XSI_LOC)}
    if cat.name != "CATALOG.XML":
        report("WARN", f"exchange catalogue is named '{cat.name}', S-100 Part 17 requires CATALOG.XML")
    if root_dir.name != "S100_ROOT":
        report("WARN", f"CATALOG.XML is in '{root_dir.name}', expected the S100_ROOT folder")
    if not (root_dir / "CATALOG.SIGN").exists():
        report("WARN", "no CATALOG.SIGN next to CATALOG.XML (S-100 Part 15 signature)")
    if xsd:
        xsd_validate(cat, xsd)

    referenced = set()
    entries = []
    for kind in ("S100_DatasetDiscoveryMetadata", "S100_SupportFileDiscoveryMetadata", "S100_CatalogueDiscoveryMetadata"):
        for e in root.iter():
            if ln(e.tag) != kind:
                continue
            fn = first_text(e, "fileName") or ""
            rel = re.sub(r"^file:/*", "", fn)
            target = root_dir / rel
            if fn and not target.exists():
                # Part 17 Table 17-1 allows a bare file:/<name>; base names are unique within the exchange set.
                same = [q for q in root_dir.rglob(Path(rel).name) if q.is_file()]
                if len(same) == 1:
                    target = same[0]
                    report("INFO", f"'{fn}' resolved by unique base name to {target.relative_to(root_dir)}")
                elif len(same) > 1:
                    report("ERROR", f"'{fn}': base name is not unique in the exchange set ({len(same)} files)")
            referenced.add(target.resolve())
            entry = {"kind": kind.replace("S100_", "").replace("DiscoveryMetadata", ""), "fileName": fn,
                     "product": first_text(e, "productIdentifier"), "version": first_text(e, "version"),
                     "edition": first_text(e, "editionNumber"), "update": first_text(e, "updateNumber"),
                     "purpose": first_text(e, "purpose"), "exists": target.exists()}
            entries.append(entry)
            if not fn:
                report("ERROR", f"{kind} without fileName")
            elif not target.exists():
                report("ERROR", f"catalogue references '{fn}' but {target} does not exist")
            if not fn.startswith("file:/") and fn:
                report("INFO", f"fileName '{fn}' is not a file:/ URI relative to S100_ROOT")
            sig = next((x for x in e.iter() if ln(x.tag) == "S100_SE_DigitalSignature"), None)
            if kind == "S100_DatasetDiscoveryMetadata" and sig is None:
                report("WARN", f"'{fn}': no S100_SE_DigitalSignature in digitalSignatureValue")
    s["entries"] = entries

    on_disk = [p for p in root_dir.rglob("*") if p.is_file() and p.name not in ("CATALOG.XML", "CATALOG.SIGN")
               and not p.name.startswith(".")]
    for p in on_disk:
        if p.resolve() not in referenced and p.suffix.upper() != ".SIGN":
            report("WARN", f"file on disk not listed in CATALOG.XML: {p.relative_to(root_dir)}")
    for p in on_disk:
        rel = p.relative_to(root_dir).parts
        if len(rel) >= 2 and not re.match(r"^S-\d{3}$", rel[0]):
            report("INFO", f"'{'/'.join(rel)}' is not under an S-XXX product folder")
        if p.suffix.lower() in (".gml", ".xml") and "DATASET_FILES" in rel:
            inspect_gml(p, summary)
        elif p.suffix.lower() == ".h5":
            inspect_h5(p, summary)


def main():
    ap = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    ap.add_argument("path")
    ap.add_argument("--xsd", help="XSD to validate the GML/catalogue against (lxml required)")
    ap.add_argument("--json", action="store_true", help="print the summary as JSON")
    a = ap.parse_args()
    p = Path(a.path).expanduser()
    summary = {}
    if p.is_dir():
        cats = [c for c in p.rglob("*") if c.name.upper() == "CATALOG.XML"]
        if not cats:
            sys.exit("no CATALOG.XML found under that folder")
        for c in cats:
            inspect_catalog(c, summary, a.xsd)
    elif p.name.upper() == "CATALOG.XML":
        inspect_catalog(p, summary, a.xsd)
    elif p.suffix.lower() in (".gml", ".xml"):
        inspect_gml(p, summary)
        if a.xsd:
            xsd_validate(p, a.xsd)
    elif p.suffix.lower() in (".h5", ".hdf5"):
        inspect_h5(p, summary)
    else:
        sys.exit(f"don't know how to inspect {p}")

    if a.json:
        print(json.dumps({"summary": summary, "findings": findings}, indent=2, default=str))
        return
    print(json.dumps(summary, indent=2, default=str)[:20000])
    print("\n== findings")
    order = {"ERROR": 0, "WARN": 1, "INFO": 2}
    for lvl, msg in sorted(findings, key=lambda f: order[f[0]]):
        print(f"{lvl:5} {msg}")
    print(f"\n{sum(1 for f in findings if f[0] == 'ERROR')} errors, {sum(1 for f in findings if f[0] == 'WARN')} warnings")


if __name__ == "__main__":
    main()
