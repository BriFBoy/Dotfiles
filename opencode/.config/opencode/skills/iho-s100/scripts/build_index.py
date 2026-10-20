#!/usr/bin/env python3
"""Build the iho-s100 skill's searchable references from the local IHO document library.

Re-run this whenever documents are added or replaced in the source library:

    python3 build_index.py --source ~/Documents/S-100

Requires: pdftotext (poppler-utils). Optional: pypdf (PDF bookmarks), openpyxl
(S-158 validation-check spreadsheets). Feature catalogue XML is parsed with the stdlib.

Outputs (relative to the skill directory):
    references/text/<id>.txt       full text, one "<<<PAGE n>>>" marker per PDF page
    references/toc/<id>.md         bookmarks + detected clause headings with PDF page numbers
    references/checks/<id>.md      one block per validation check (greppable by check ID)
    references/fc/<id>.md          feature catalogue summary (features, attributes, enums)
    references/library.md          catalogue of every indexed document
"""
import argparse
import hashlib
import re
import subprocess
import sys
import xml.etree.ElementTree as ET
from pathlib import Path

SKILL_DIR = Path(__file__).resolve().parent.parent
REF = SKILL_DIR / "references"

# Manifest: (id, glob relative to source root, title, edition, status note).
# Add a line here when a new document arrives; unknown PDFs are still indexed with a derived id.
MANIFEST = [
    ("s100", "S-100/S-100 Ed 5.2.1_FINAL.pdf", "S-100 Universal Hydrographic Data Model", "5.2.1", "framework"),
    ("s98-main", "S-98/S-98_Main_Document_Ed 2.0.0_Final.pdf", "S-98 Data Product Interoperability in S-100 Navigation Systems – Main", "2.0.0", ""),
    ("s98-partA", "S-98/S-98 Part A_Ed_2.0.0_Final.pdf", "S-98 Part A", "2.0.0", ""),
    ("s98-partB", "S-98/S-98 Part B_Ed_2.0.0_Final.pdf", "S-98 Part B", "2.0.0", ""),
    ("s98-annexA", "S-98/S-98 Annex A_Interoperability_2.0.0_Final.pdf", "S-98 Annex A Interoperability", "2.0.0", ""),
    ("s111", "S-111/S-111_Surface_Currents_Ed_2.0.0.pdf", "S-111 Surface Currents Product Specification", "2.0.0", ""),
    ("s124", "S-124/S-124_Navigational_Warnings_Product_Specification_Ed_2.0.0.pdf", "S-124 Navigational Warnings Product Specification", "2.0.0", ""),
    ("s127", "S-127/S-127 Marine Traffic Management Product Specification_Edition 1.0.0.pdf", "S-127 Marine Traffic Management Product Specification", "1.0.0", "built on S-100 4.0.0"),
    ("s127-ed2", "S-127/S-127_Marine_Traffic_Management_Ed_2.0.0.pdf", "S-127 Marine Traffic Management Product Specification", "2.0.0", "pending IHO approval; built on S-100 5.2.0"),
    ("s128", "S-128/S-128_Catalogue_of_Nautical_Products_Product_Specification_Ed_2.0.0.pdf", "S-128 Catalogue of Nautical Products Product Specification", "2.0.0", ""),
    ("s128-dceg", "S-128/S-128_Annex_A_DCEG_Ed_2.0.0.pdf", "S-128 Annex A Data Classification and Encoding Guide", "2.0.0", ""),
    ("s131", "S-131/S-131_Product_Specification_Ed_2.0.0.pdf", "S-131 Marine Harbour Infrastructure Product Specification", "2.0.0", "current"),
    ("s131-ed1", "S-131/S-131 Ed 1.0.0_Final.pdf", "S-131 Marine Harbour Infrastructure Product Specification", "1.0.0", "superseded by 2.0.0"),
    ("s131-ed1-dceg", "S-131/S-131 Edition 1.0.0 Annexes/S-131 Ed 1.0.0 AnnexA DCEG_Final.pdf", "S-131 Ed 1 Annex A DCEG", "1.0.0", "superseded"),
    ("s131-ed1-format", "S-131/S-131 Edition 1.0.0 Annexes/S-131 Ed 1.0.0 AnnexB DataFormat_Final.pdf", "S-131 Ed 1 Annex B Data Format", "1.0.0", "superseded"),
    ("s131-ed1-fc", "S-131/S-131 Edition 1.0.0 Annexes/S-131 Ed 1.0.0 AnnexC FeatureCatalogue_Final.pdf", "S-131 Ed 1 Annex C Feature Catalogue", "1.0.0", "superseded"),
    ("s131-ed1-checks", "S-131/S-131 Edition 1.0.0 Annexes/S-131 Ed 1.0.0 AnnexD ValidationChecks_Final.pdf", "S-131 Ed 1 Annex D Validation Checks", "1.0.0", "superseded"),
    ("s158-intro", "S-100/S-158-100_Validation_Checks_Ed_1.0.0/S-158_Validation_Checks_Introduction_and_Structure_Ed_1.0.0.pdf", "S-158 Validation Checks – Introduction and Structure", "1.0.0", ""),
    ("s158-100", "S-100/S-158-100_Validation_Checks_Ed_1.0.0/S-158_100_Universal_Hydrographic_Data_Model_Validation_Checks_Ed_1.0.0.pdf", "S-158:100 Universal Hydrographic Data Model Validation Checks", "1.0.0", ""),
    ("s158-98", "S-98/S-158-98_Validation_Checks_Ed_1.0.0/S-158_98_Data_Product_Interoperability_Validation_Checks_Introduction_Ed_1.0.0.pdf", "S-158:98 Interoperability Validation Checks – Introduction", "1.0.0", ""),
    ("s158-111", "S-111/S-158-111_Validation_Checks_Ed_1.0.0/S-158_111_ENC_Validation_Checks_Introduction_Ed 1.0.0.pdf", "S-158:111 Surface Currents Validation Checks – Introduction", "1.0.0", ""),
    ("s158-131", "S-131/S-158-131_Validation_Checks_Ed_1.0.0/S-158_131_Validation_Checks.pdf", "S-158:131 Marine Harbour Infrastructure Validation Checks", "1.0.0", ""),
]
XLSX_MANIFEST = [
    ("s158-100", "S-100/S-158-100_Validation_Checks_Ed_1.0.0/S-158_100_1_0_0_20250224.xlsx"),
    ("s158-98", "S-98/S-158-98_Validation_Checks_Ed_1.0.0/S-158_98_1_0_0_20250224.xlsx"),
    ("s158-111", "S-111/S-158-111_Validation_Checks_Ed_1.0.0/S-158-111_Validation_Checks_Ed_1.0.0.xlsx"),
    ("s158-131", "S-131/S-158-131_Validation_Checks_Ed_1.0.0/S-158_131_1_0_0.xlsx"),
]
FC_MANIFEST = [
    ("s127-fc", "S-127/S-127 Edition 1.0.0_Appendix C-2_Feature Catalogue/S-127-1.0.0 App_C-2 Feature Catalogue/20181129/S127FC.xml"),
]
SKIP_DIRS = {"testdata"}

# Clause headings such as "10b-4.2.1 Title", "4.3 Title", "Table 10c-6" are excluded (captions handled separately).
HEADING_RE = re.compile(r"^\s{0,6}((?:\d{1,2}[a-d]?-)?\d{1,2}(?:\.\d{1,2}){0,5}|[A-Z]-\d+(?:\.\d+)*|Appendix [A-Z0-9-]+|Annex [A-Z])\s{1,8}([A-Z][^\n]{2,90}?)\s*$")
CAPTION_RE = re.compile(r"^\s{0,40}((?:Table|Figure)\s+[0-9A-Z][\w.-]*)\s*[-–—:]?\s+(\S[^\n]{2,100}?)\s*$")
DOTS_RE = re.compile(r"\.{4,}|\s\d+\s*$")


def sha(path):
    return hashlib.sha1(path.read_bytes()).hexdigest()


def pdf_pages(pdf):
    out = subprocess.run(["pdftotext", "-layout", str(pdf), "-"], capture_output=True, text=True, check=True).stdout
    pages = out.split("\f")
    if pages and not pages[-1].strip():
        pages.pop()
    return pages


def pdf_bookmarks(pdf):
    try:
        import pypdf
    except ImportError:
        return []
    marks = []
    try:
        r = pypdf.PdfReader(str(pdf))

        def walk(items, depth):
            for it in items:
                if isinstance(it, list):
                    walk(it, depth + 1)
                else:
                    try:
                        marks.append((depth, it.title.strip(), r.get_destination_page_number(it) + 1))
                    except Exception:
                        pass

        walk(r.outline, 0)
    except Exception:
        pass
    return marks


def detect_headings(pages):
    found = []
    for pno, text in enumerate(pages, 1):
        for line in text.splitlines():
            if DOTS_RE.search(line) and "...." in line:
                continue  # table-of-contents line
            m = HEADING_RE.match(line)
            if m and len(line.strip()) < 100 and not re.search(r"\s{4,}\S", m.group(2)):
                found.append((pno, m.group(1), m.group(2).strip()))
                continue
            c = CAPTION_RE.match(line)
            if c:
                found.append((pno, c.group(1), c.group(2).strip()))
    return found


def index_pdf(doc_id, pdf, title, edition, note):
    pages = pdf_pages(pdf)
    with open(REF / "text" / f"{doc_id}.txt", "w") as f:
        f.write(f"# {title} — Edition {edition}\n# source: {pdf}\n# Page markers are PDF page numbers (1-based), not printed page numbers.\n")
        for n, p in enumerate(pages, 1):
            f.write(f"\n<<<PAGE {n}>>>\n{p.rstrip()}\n")
    marks = pdf_bookmarks(pdf)
    heads = detect_headings(pages)
    with open(REF / "toc" / f"{doc_id}.md", "w") as f:
        f.write(f"# {title} — Edition {edition}\n\nPDF pages: {len(pages)}. Page numbers below are PDF pages; open with "
                f"`scripts/s100.py page {doc_id} <n>`.\n\n")
        if marks:
            f.write("## Bookmarks\n\n")
            for d, t, p in marks:
                f.write(f"{'  ' * d}- {t} — p.{p}\n")
            f.write("\n")
        f.write("## Detected clause headings, tables and figures\n\n")
        for p, num, t in heads:
            f.write(f"- p.{p} `{num}` {t}\n")
    return len(pages), len(heads)


def cell(v):
    if v is None:
        return ""
    return str(v).strip()


def eval_id_formula(v, row_idx):
    """S-158 sheets often store IDs as =CONCAT("111_", TEXT(ROW()-1+1000, "0000")); evaluate that pattern."""
    m = re.match(r'=_xlfn\.CONCAT\("([^"]*)",\s*TEXT\(ROW\(\)([-+]\d+)?([-+]\d+)?,\s*"(0+)"\)\)', v or "")
    if not m:
        return v
    n = row_idx + int(m.group(2) or 0) + int(m.group(3) or 0)
    return f"{m.group(1)}{n:0{len(m.group(4))}d}"


def index_xlsx(doc_id, xlsx):
    try:
        import openpyxl
    except ImportError:
        print(f"  skip {xlsx.name}: openpyxl not installed", file=sys.stderr)
        return 0
    wb_v = openpyxl.load_workbook(xlsx, read_only=True, data_only=True)
    wb_f = openpyxl.load_workbook(xlsx, read_only=True, data_only=False)
    count = 0
    out = [f"# {doc_id} validation checks\n\nsource: {xlsx}\n\nEach check is a `###` block headed by its Check ID. "
           "Classification: C = Critical, E = Error, W = Warning (some sheets spell these out).\n"]
    for ws_v, ws_f in zip(wb_v.worksheets, wb_f.worksheets):
        rows_v = list(ws_v.iter_rows(values_only=True))
        rows_f = list(ws_f.iter_rows(values_only=True))
        hdr_i = next((i for i, r in enumerate(rows_v) if r and any(cell(c).lower().startswith("check id") for c in r)), None)
        if hdr_i is None:
            # metadata or notes sheet: dump as key/value lines
            lines = [" | ".join(cell(c) for c in r if cell(c)) for r in rows_v]
            lines = [l for l in lines if l]
            if lines:
                out.append(f"\n## Sheet: {ws_v.title}\n\n" + "\n".join(f"- {l}" for l in lines) + "\n")
            continue
        hdr = [cell(c) for c in rows_v[hdr_i]]
        out.append(f"\n## Sheet: {ws_v.title}\n")
        for ri in range(hdr_i + 1, len(rows_v)):
            rv, rf = rows_v[ri], rows_f[ri] if ri < len(rows_f) else rows_v[ri]
            vals = {}
            for ci, h in enumerate(hdr):
                if not h or ci >= len(rv):
                    continue
                v = cell(rv[ci])
                if (not v or v.startswith("=")) and ci < len(rf) and isinstance(rf[ci], str) and rf[ci].startswith("="):
                    v = eval_id_formula(rf[ci], ri + 1)  # openpyxl rows are 0-based here; Excel ROW() is 1-based
                vals[h] = v
            cid = vals.get("Check ID", "")
            if not cid and not vals.get("Check Description"):
                if any(vals.values()):
                    out.append("\n> " + " | ".join(v for v in vals.values() if v)[:600] + "\n")
                continue
            count += 1
            cls = vals.get("Classification", "")
            out.append(f"\n### {cid or '(no id)'} [{cls}] {vals.get('Check Message', '')}\n")
            for k, v in vals.items():
                if v and k not in ("Check ID", "Classification", "Check Message"):
                    out.append(f"- **{k}:** {v}\n")
    (REF / "checks" / f"{doc_id}.md").write_text("".join(out))
    return count


def localname(tag):
    return tag.rsplit("}", 1)[-1]


def index_fc(doc_id, path):
    """Summarise an S-100 Feature Catalogue (S100FC XML) into markdown."""
    root = ET.parse(path).getroot()

    def kids(el, name):
        return [c for c in el if localname(c.tag) == name]

    def text(el, name):
        for c in el.iter():
            if localname(c.tag) == name and c.text and c.text.strip():
                return c.text.strip()
        return ""

    out = [f"# Feature catalogue: {text(root, 'name')} {text(root, 'versionNumber')}\n\nsource: {path}\n"]
    sections = [("S100_FC_SimpleAttributes", "Simple attributes"), ("S100_FC_ComplexAttributes", "Complex attributes"),
                ("S100_FC_Roles", "Roles"), ("S100_FC_InformationAssociations", "Information associations"),
                ("S100_FC_FeatureAssociations", "Feature associations"), ("S100_FC_InformationTypes", "Information types"),
                ("S100_FC_FeatureTypes", "Feature types")]
    n = 0
    for el in root.iter():
        ln = localname(el.tag)
        for sec, label in sections:
            if ln == sec:
                out.append(f"\n## {label}\n")
                for item in el:
                    n += 1
                    code = "".join(c.text or "" for c in item if localname(c.tag) == "code")
                    name = "".join(c.text or "" for c in item if localname(c.tag) == "name")
                    defn = "".join(c.text or "" for c in item if localname(c.tag) == "definition").strip()
                    out.append(f"\n### {code} — {name}\n{defn}\n")
                    vt = "".join(c.text or "" for c in item if localname(c.tag) == "valueType")
                    if vt:
                        out.append(f"- valueType: {vt}\n")
                    for c in item:
                        cl = localname(c.tag)
                        if cl == "listedValues":
                            for lv in c:
                                out.append(f"  - {text(lv, 'code')} = {text(lv, 'label')}\n")
                        elif cl in ("attributeBinding", "subAttributeBinding"):
                            mult = next((m for m in c if localname(m.tag) == "multiplicity"), None)
                            lo = text(mult, "lower") if mult is not None else ""
                            up_el = next((u for u in mult if localname(u.tag) == "upper"), None) if mult is not None else None
                            up = "*" if up_el is not None and up_el.get("infinite") == "true" else (up_el.text if up_el is not None else "")
                            ref = next((a for a in c if localname(a.tag) == "attribute"), None)
                            out.append(f"- attr {ref.get('ref') if ref is not None else '?'} [{lo}..{up}]\n")
                        elif cl in ("featureBinding", "informationBinding"):
                            tgt = next((a for a in c if localname(a.tag) in ("featureType", "informationType")), None)
                            assoc = next((a for a in c if localname(a.tag) in ("association", "featureAssociation", "informationAssociation")), None)
                            role = next((a for a in c if localname(a.tag) == "role"), None)
                            out.append(f"- {cl} → {tgt.get('ref') if tgt is not None else '?'} via "
                                       f"{assoc.get('ref') if assoc is not None else '?'} role {role.get('ref') if role is not None else '?'}\n")
                        elif cl in ("permittedPrimitives", "superType"):
                            out.append(f"- {cl}: {(c.text or c.get('ref') or '').strip()}\n")
    (REF / "fc" / f"{doc_id}.md").write_text("".join(out))
    return n


def main():
    ap = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    ap.add_argument("--source", default=str(Path.home() / "Documents/S-100"), help="root of the IHO document library")
    args = ap.parse_args()
    src = Path(args.source).expanduser()
    for d in ("text", "toc", "checks", "fc"):
        (REF / d).mkdir(parents=True, exist_ok=True)

    lib = ["# Indexed document library\n\n", f"Source root: `{src}`\n\n",
           "| id | title | edition | note | PDF pages | headings | source file |\n|---|---|---|---|---|---|---|\n"]
    seen_hashes, known = set(), set()
    for doc_id, rel, title, ed, note in MANIFEST:
        p = src / rel
        if not p.exists():
            print(f"missing: {rel}", file=sys.stderr)
            continue
        known.add(p.resolve())
        seen_hashes.add(sha(p))
        pages, heads = index_pdf(doc_id, p, title, ed, note)
        lib.append(f"| `{doc_id}` | {title} | {ed} | {note} | {pages} | {heads} | `{rel}` |\n")
        print(f"pdf  {doc_id}: {pages} pages, {heads} headings")

    # Any PDFs not in the manifest (new arrivals); identical duplicates are skipped.
    for p in sorted(src.rglob("*.pdf")):
        if p.resolve() in known or any(part in SKIP_DIRS for part in p.relative_to(src).parts):
            continue
        h = sha(p)
        if h in seen_hashes:
            continue
        seen_hashes.add(h)
        doc_id = re.sub(r"[^a-z0-9]+", "-", p.stem.lower()).strip("-")[:50]
        pages, heads = index_pdf(doc_id, p, p.stem, "?", "unlisted – add to MANIFEST")
        lib.append(f"| `{doc_id}` | {p.stem} | ? | not in manifest | {pages} | {heads} | `{p.relative_to(src)}` |\n")
        print(f"pdf  {doc_id} (unlisted): {pages} pages")

    lib.append("\n## Validation-check spreadsheets (S-158)\n\n| id | checks | source |\n|---|---|---|\n")
    for doc_id, rel in XLSX_MANIFEST:
        p = src / rel
        if p.exists():
            n = index_xlsx(doc_id, p)
            lib.append(f"| `checks/{doc_id}.md` | {n} | `{rel}` |\n")
            print(f"xlsx {doc_id}: {n} checks")

    lib.append("\n## Feature catalogues\n\n| id | items | source |\n|---|---|---|\n")
    for doc_id, rel in FC_MANIFEST:
        p = src / rel
        if p.exists():
            n = index_fc(doc_id, p)
            lib.append(f"| `fc/{doc_id}.md` | {n} | `{rel}` |\n")
            print(f"fc   {doc_id}: {n} items")

    (REF / "library.md").write_text("".join(lib))


if __name__ == "__main__":
    main()
