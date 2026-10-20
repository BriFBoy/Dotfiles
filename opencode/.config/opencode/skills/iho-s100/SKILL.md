---
name: iho-s100
description: Look up, cite and apply the IHO S-100 framework and its product specifications (S-98, S-111, S-124, S-127, S-128, S-131) plus the S-158 validation checks, from a locally indexed full-text library. Use this skill whenever the user asks anything about S-100 / S-1xx standards — clauses, feature types, attributes, metadata, GML or HDF5 encoding, exchange sets, CATALOG.XML, dataset naming, signatures, portrayal, interoperability — or wants to validate, inspect, debug or generate S-100 datasets and exchange sets (S-124 navigational warnings, S-111 surface currents, S-131 harbour infrastructure, S-128 catalogues, S-127 traffic management), even if they only mention "IHO", "S-100", "navwarn", "exchange set", "Group_F" or a check ID like 111_1001 without naming the standard.
---

# IHO S-100 documentation

The IHO standards in `~/Documents/S-100` have been extracted into searchable text in this skill's
`references/` folder. Answer from the documents, not from memory. S-100 has changed a lot between editions
(4.0 → 5.0 → 5.2), and remembered details are often from the wrong edition. Each lookup takes a second, so
always check.

All paths below are relative to this skill's directory (`~/.claude/skills/iho-s100`). The lookup tools need
only `python3`. The HDF5 inspector also needs `h5py`, and XSD validation needs `lxml`. If either is missing,
say so and use a venv, or fall back to `h5dump` / `xmllint`.

## What is indexed

| id | document | edition | notes |
|---|---|---|---|
| `s100` | S-100 Universal Hydrographic Data Model | 5.2.1 (Dec 2025) | the framework, 898 pages |
| `s98-main`, `s98-partA`, `s98-partB`, `s98-annexA` | S-98 Data product interoperability | 2.0.0 | |
| `s111` | S-111 Surface Currents | 2.0.0 | HDF5 |
| `s124` | S-124 Navigational Warnings | 2.0.0 | GML |
| `s127` | S-127 Marine Traffic Management | 1.0.0 | GML; built on **S-100 4.0.0**, so clause numbers and schemas are older |
| `s127-ed2` | S-127 Marine Traffic Management | 2.0.0 | GML; **pending IHO approval**, built on S-100 5.2.0 (S100_ROOT exchange set, producer-code subfolder under DATASET_FILES) |
| `s128` (+ `s128-dceg`) | S-128 Catalogue of Nautical Products (+ DCEG) | 2.0.0 | GML |
| `s131` | S-131 Marine Harbour Infrastructure | 2.0.0 | current |
| `s131-ed1`, `s131-ed1-dceg`, `-format`, `-fc`, `-checks` | S-131 Ed 1 and annexes | 1.0.0 | superseded; the DCEG and FC annexes are still the best per-feature encoding guidance |
| `s158-intro`, `s158-100`, `s158-98`, `s158-111`, `s158-131` | S-158 validation checks (intro PDFs) | 1.0.0 | |
| `checks/s158-100`, `-98`, `-111`, `-131` | S-158 check spreadsheets, one block per check | 1.0.0 | 412 + 19 + 120 + 64 checks |
| `fc/s127-fc` | S-127 feature catalogue XML summarised | 1.0.0 | the only machine-readable FC in the library |

`references/library.md` lists the source file for each id. If a user asks about a product that is not
indexed (S-101, S-102, S-104, S-122, S-129 …), say that the spec isn't in the library. You can still use the
S-100 framework, the S-158/S-98 material and any sample data, but say where you have fallen back to general
knowledge.

### Where things are in S-100 5.2.1 (PDF pages)

Part 0 Overview p.1 · Part 1 Conceptual schema language p.25 · Part 2/2a/2b Registers p.47 · Part 3 General
Feature Model p.107 · Part 4a Metadata p.137 · 4b Imagery/gridded metadata p.167 · 4c Data quality p.177 ·
Part 5 Feature Catalogue p.201 · Part 6 CRS p.227 · Part 7 Spatial schema p.253 · Part 8 Imagery & gridded
data p.277 · Part 9 Portrayal p.329 · 9a Lua portrayal p.413 · **10a ISO 8211 p.445 · 10b GML p.493 · 10c
HDF5 p.523** · Part 11 Product specs p.591 · 12 Maintenance p.615 · 13 Scripting p.623 · 14 Online data
exchange p.659 · **15 Data protection / signatures p.687** · 16 Interoperability catalogue p.723 · 16a
Harmonised portrayal p.791 · **17 Discovery metadata & exchange catalogues p.809** · 18 Language packs p.851 ·
Annex A Terms p.877.

Clause numbers carry the Part prefix (`10b-4.2`, `17-4.4`, `Table 10c-6`). Product specs use plain numbers
(`9.7`, `Table 12.1`).

## Tools

```bash
S=~/.claude/skills/iho-s100/scripts
python3 $S/s100.py toc s124 --grep 'exchange|naming'      # find the clause and its PDF page
python3 $S/s100.py section s100 17-4.2 --pages 2           # read where a clause starts (--last skips a front-matter TOC hit)
python3 $S/s100.py page s111 78 --to 79                    # read specific PDF pages
python3 $S/s100.py search 'datasetFileIdentifier' --doc s100 s124 -C 3
python3 $S/s100.py check 111_1001 --exact                  # one S-158 check
python3 $S/s100.py check 'Group_F|featureCode' --set s158-111
python3 $S/s100.py fc VesselTrafficServiceArea             # S-127 FC entry: attributes, multiplicities, bindings
python3 $S/inspect_s100.py path/to/exchange-set-or-file [--xsd schema.xsd] [--json]
```

`search` takes a case-insensitive Python regex. pdftotext keeps the page layout, so table rows are split
across lines and a phrase can be broken by column gaps. Search for one distinctive word, or allow for the
gaps (`dataset\s+file\s+naming`), and then read the whole page. A search hit only tells you where to look.
Read the page before you answer, because the table header and surrounding conditions usually change what a
row means.

## Answering spec questions

1. Find the clause. Use `toc <id> --grep` for named topics, and `search` for attribute names, codes and
   phrases. Most questions touch both the framework and a product spec. The product spec narrows S-100
   (allowed geometry, mandatory metadata, naming), so check both and report where they differ.
2. Read the page or pages with `page`/`section`.
3. Answer, then cite each fact with document, edition, clause and PDF page, for example *S-100 Ed 5.2.1,
   Part 17, 17-4.3 / Table 17-1 (PDF p.820)*. Say that these are PDF page numbers, because printed numbers
   restart in each Part. Quote short normative passages verbatim when the exact wording matters ("must",
   "shall", multiplicities, enumerations).
4. Raise version conflicts when they come up: S-127 1.0.0 is built on S-100 4.0.0 (2.0.0, pending approval, is on 5.2.0), S-131 has two editions,
   and sample data may target older S-100 schemas (look at the namespace, e.g. `s100/xc/5.0` vs `5.2`).

## Validating datasets and exchange sets

1. Run `inspect_s100.py` on the folder or file. It parses CATALOG.XML, resolves every `fileName` (both the
   `file:/S-124/DATASET_FILES/x.GML` form and the bare `file:/x.GML` form are valid, because Part 17 requires
   unique base names), finds unlisted files and missing signatures, and checks GML for
   DatasetIdentificationInformation, duplicate `gml:id`s and dangling `xlink:href`s. For HDF5 it checks the
   root metadata attributes, `Group_F`, and that each featureCode has a matching group.
2. Treat its findings as leads, not verdicts. For each one, look up the governing clause and the matching
   S-158 check (`s100.py check '<keyword>' --set s158-<product>`), and report the check ID, its classification
   (Critical / Error / Warning) and the fix from the "Check Solution" field.
3. For deeper checks the script doesn't cover (attribute multiplicities, enumerations, permitted primitives,
   product-specific rules), compare the data against the product spec's feature catalogue / data content
   clause, or `fc/s127-fc` for S-127. Then search the check sets for the rule.
4. XSD validation: the official schemas are on `https://schemas.s100dev.net` (the `schemaLocation` in the
   data points there). The only XSDs on disk are S-127's, under
   `~/Documents/S-100/S-127/S-127 Edition 1.0.0_Schemas/schemas/`, and they target S-100 **4.0.0**, so don't
   use them for 5.x data. If the user wants XSD validation, ask before downloading schemas. Schema imports
   often need the whole schema tree (lxml resolves relative imports from a local copy).
5. Report the findings grouped by severity. Separate what you verified mechanically from what you judged.

## Generating data or code

- Start from the product spec's data-content clauses and feature catalogue, not from memory. Feature names,
  attribute codes and enumeration values must match the catalogue exactly (camelCase attributes,
  UpperCamelCase features).
- Use real sample data as templates and match its namespaces and structure:
  - S-124 GML 2.0: `~/Documents/S-100/testdata/danish-nw-examples (2)/danish-nw-examples/` (datasets,
    exchange sets, example signer key and cert) and `testdata/UKHO_S100_Trial_datasets/S-124/S100_ROOT`
  - S-111 HDF5 2.0 (+ S-128 GML): `testdata/UKHO_S100_Trial_datasets/S-111/S-111_GB_May26/S100_ROOT`
  - S-131: `testdata/13100AA_SAMPLE_CAHAL_20240130/S100_ROOT` (older XC 5.0 namespace)
  - S-127: `S-127/S-127 Edition 1.0.0_SampleData/`
  - Zipped UKHO trial sets also cover S-101, S-102 and S-104.
- Follow the naming and layout rules: the product spec's dataset-naming clause (e.g. S-124 9.7, S-111 11.2.3,
  S-128 11.2.2, S-131 13.3.2, S-127 11.6 in 1.0.0 / 13.3.2 in 2.0.0) and S-100 Part 17 17-4.2 (`S100_ROOT/CATALOG.XML` + `CATALOG.SIGN`,
  one `S-XXX/` folder per product with `DATASET_FILES/`, `SUPPORT_FILES/`, `CATALOGUES/`).
- Never invent digital signatures. Signatures follow Part 15 and need the producer's key. Leave clearly marked
  placeholders, or sign with the user's key using a tool they choose.
- After generating data, run `inspect_s100.py` on it and fix what it reports before you hand it over.

## Keeping the library current

When documents are added or replaced in `~/Documents/S-100`, rebuild the index:

```bash
python3 ~/.claude/skills/iho-s100/scripts/build_index.py --source ~/Documents/S-100
```

This needs `pdftotext`. `pypdf` (bookmarks) and `openpyxl` (S-158 spreadsheets) are optional, and a venv is
fine. Unlisted PDFs are indexed under a derived id. Add new documents to `MANIFEST` in `build_index.py` to
give them a short id, edition and note, and update the table above to match.
