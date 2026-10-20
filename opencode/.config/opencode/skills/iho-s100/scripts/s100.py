#!/usr/bin/env python3
"""Look things up in the indexed IHO S-100 document library (stdlib only).

  s100.py docs                                 list indexed documents
  s100.py search REGEX [--doc ID ...] [-C N]   regex search (case-insensitive) with PDF page numbers
  s100.py toc ID [--grep REGEX]                clause headings / tables / figures with pages
  s100.py section ID CLAUSE [--pages N]        print the pages where a clause (e.g. 10b-4.2, 4.3.1, "Table 10c-6") starts
  s100.py page ID N [--to M]                   print PDF page(s)
  s100.py check ID_OR_REGEX [--set s158-111]   print S-158 validation check blocks (e.g. 111_1001, 100_0003)
  s100.py fc NAME [--set s127-fc]              print a feature catalogue entry (feature, attribute, enum)

Document ids come from references/library.md (s100, s124, s111, s127, s128, s131, s98-main, s158-100 ...).
"""
import argparse
import re
import sys
from pathlib import Path

REF = Path(__file__).resolve().parent.parent / "references"
PAGE_RE = re.compile(r"^<<<PAGE (\d+)>>>$")


def docs():
    return sorted(p.stem for p in (REF / "text").glob("*.txt"))


def load_pages(doc):
    path = REF / "text" / f"{doc}.txt"
    if not path.exists():
        sys.exit(f"unknown doc '{doc}'. Known: {', '.join(docs())}")
    pages, cur = {}, None
    for line in path.read_text().splitlines():
        m = PAGE_RE.match(line)
        if m:
            cur = int(m.group(1))
            pages[cur] = []
        elif cur is not None:
            pages[cur].append(line)
    return pages


def cmd_docs(a):
    print((REF / "library.md").read_text())


def cmd_search(a):
    rx = re.compile(a.pattern, re.I)
    targets = a.doc or docs()
    hits = 0
    for d in targets:
        for pno, lines in load_pages(d).items():
            for i, line in enumerate(lines):
                if rx.search(line):
                    hits += 1
                    if hits > a.max:
                        print(f"... more than {a.max} hits; narrow with --doc or a tighter regex")
                        return
                    lo, hi = max(0, i - a.C), min(len(lines), i + a.C + 1)
                    print(f"== {d} p.{pno} L{i + 1}")
                    for j in range(lo, hi):
                        print(("> " if j == i else "  ") + lines[j].rstrip())
    if not hits:
        print("no hits")


def cmd_toc(a):
    text = (REF / "toc" / f"{a.doc}.md").read_text()
    if a.grep:
        rx = re.compile(a.grep, re.I)
        text = "\n".join(l for l in text.splitlines() if rx.search(l))
    print(text)


def cmd_page(a):
    pages = load_pages(a.doc)
    for n in range(a.n, (a.to or a.n) + 1):
        if n in pages:
            print(f"<<<{a.doc} PAGE {n}>>>")
            print("\n".join(pages[n]))


def cmd_section(a):
    toc = (REF / "toc" / f"{a.doc}.md").read_text().splitlines()
    clause = re.escape(a.clause)
    rx = re.compile(rf"(?:^|\s|`){clause}(?:`|\s)")
    cands = [l for l in toc if rx.search(l)]
    if not cands:
        sys.exit(f"clause '{a.clause}' not found in toc/{a.doc}.md; try `s100.py search` instead")
    m = re.search(r"p\.(\d+)", cands[-1] if a.last else cands[0])
    print(f"# matched: {(cands[-1] if a.last else cands[0]).strip()}  ({len(cands)} candidates)")
    if len(cands) > 1:
        for c in cands[:8]:
            print(f"#   {c.strip()}")
    start = int(m.group(1))
    a.n, a.to = start, start + a.pages - 1
    cmd_page(a)


def blocks(path):
    cur = []
    for line in path.read_text().splitlines():
        if line.startswith("### ") and cur:
            yield cur
            cur = []
        if line.startswith("### ") or cur:
            cur.append(line)
    if cur:
        yield cur


def cmd_blocks(folder, a):
    files = [REF / folder / f"{a.set}.md"] if a.set else sorted((REF / folder).glob("*.md"))
    exact = re.compile(rf"^### {re.escape(a.query)}\b")
    rx = re.compile(a.query, re.I)
    found = 0
    for f in files:
        for b in blocks(f):
            if exact.match(b[0]) or (not a.exact and rx.search("\n".join(b))):
                found += 1
                print(f"[{f.stem}]")
                print("\n".join(b).rstrip() + "\n")
                if found >= a.max:
                    print(f"... stopped at {a.max} matches")
                    return
    if not found:
        print("no matches")


def main():
    ap = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    sp = ap.add_subparsers(dest="cmd", required=True)
    sp.add_parser("docs").set_defaults(f=cmd_docs)
    s = sp.add_parser("search"); s.add_argument("pattern"); s.add_argument("--doc", nargs="+")
    s.add_argument("-C", type=int, default=2); s.add_argument("--max", type=int, default=60); s.set_defaults(f=cmd_search)
    s = sp.add_parser("toc"); s.add_argument("doc"); s.add_argument("--grep"); s.set_defaults(f=cmd_toc)
    s = sp.add_parser("page"); s.add_argument("doc"); s.add_argument("n", type=int); s.add_argument("--to", type=int); s.set_defaults(f=cmd_page)
    s = sp.add_parser("section"); s.add_argument("doc"); s.add_argument("clause"); s.add_argument("--pages", type=int, default=2)
    s.add_argument("--last", action="store_true", help="use the last toc match (skips front-matter TOC entries)"); s.set_defaults(f=cmd_section)
    for name, folder in (("check", "checks"), ("fc", "fc")):
        s = sp.add_parser(name); s.add_argument("query"); s.add_argument("--set"); s.add_argument("--exact", action="store_true")
        s.add_argument("--max", type=int, default=20); s.set_defaults(f=lambda a, folder=folder: cmd_blocks(folder, a))
    a = ap.parse_args()
    a.f(a)


if __name__ == "__main__":
    main()
