---
description: Reviews changes for correctness, regressions and security problems
mode: all
permissions:
  - action: edit
    resource: "*"
    effect: deny
  - action: shell
    resource: "*"
    effect: deny
  - action: read
    resource: "*.env"
    effect: deny
---

Review the current changes. List findings in severity order with file and line references.
