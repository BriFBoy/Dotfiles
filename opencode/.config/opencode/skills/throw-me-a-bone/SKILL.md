---
name: throw-me-a-bone
description: Do the agentic work but deliberately leave ONE meaningful piece of the solution for the developer to write by hand, then review it and finish the job. Use WHENEVER the user's prompt contains the phrase "throw me a bone" anywhere, even buried at the end of a longer task prompt (e.g. "add pagination to the payouts endpoint, throw me a bone"), or variants like "small bone", "big bone", "bone me". Applies to any task type — feature, bug fix, refactor, investigation, design, docs.
argument-hint: "[small|big|let me pick] [where the bone should be]"
---

# Throw me a bone

The developer is an expert who wants to stay sharp while working agentically. Do the task as normal, but carve out one piece where the real reasoning lives and hand it over. This is a sparring session, not a tutorial: minimal prose, no lectures, no praise.

## 1. Solve first, then carve

1. Plan the **whole** solution privately before touching anything. You can only cut a good bone out of a solution you understand.
2. Pick exactly **one** bone (see §2). Don't announce it upfront — unless you're already presenting a plan (plan mode), in which case name the bone so it can be vetoed early.
3. Fix the bone's interface first (signature, type, contract), then build everything around it: callers, wiring, endpoints, client regen, UI, docs. Make every other edit to the bone's file before handing over.
4. Leave the bone as a stub that keeps the rest compiling/running: throw `NotImplementedException("TODO(human)")` / `new Error("TODO(human)")`, or return a typed placeholder if a UI must still render.
5. Mark it with a single `TODO(human)` comment stating *what*, never *how*. **Exactly one** `TODO(human)` in the codebase at a time.
6. Define done:
   - **Behavioural logic** with a clear expected outcome → write red tests that pin the contract. Don't enumerate every edge case — finding them is part of the bone.
   - **Design decisions** (a type shape, an abstraction, an API) → state constraints and trade-offs instead; a test would leak or narrow the answer.
7. Run the build/tests and confirm the only failures route through the bone. Check the answer can't be copied from a near-identical function next door.

## 2. Choosing the bone

A good bone: high reasoning per line, verifiable (test/compiler), downstream of a fixed interface, needs only 2–3 files of context, is the task's actual core difficulty, and fits the size budget.

Prefer, roughly in order:
- Core domain logic / invariants / guards
- An algorithm (distribution math, overlap, rounding, ordering)
- A tricky query (projection, aggregation, filter, pagination)
- Validation rules where the edge cases are the point
- A UI state machine (reducer, conditional reveal, form transitions)
- For bug fixes: the diagnosis, or the regression test that reproduces it

Never a bone: boilerplate, DI/endpoint wiring, config/infra, generated code (migrations, API clients), styling, mechanical multi-file edits, anything with no feedback loop, anything depending on facts only you discovered (a log line, a framework quirk you looked up), or the interface everything downstream depends on.

**Decision bones.** If the core difficulty is a design fork that blocks downstream work, stop *at the fork* instead: lay out the constraints (not the options' pros/cons essay) and ask one sharp question. The developer answers in a sentence or sketch; build on their answer.

**Non-code tasks** — you do the legwork, they make the judgement:
- Debugging: reproduce, gather logs, narrow the scope. They state the hypothesis and the experiment that would confirm/refute it; you run it.
- Investigation: gather the facts. They write a 2–3 sentence answer *before* seeing your conclusion; then compare.
- Design: surface constraints and forces. They pick and justify, or sketch the core type.
- Docs: they write the one "why / trade-off" paragraph; you write the reference parts.
- Refactor: they name the seam / module boundary, or do the one non-mechanical move.

**Too small for a bone?** Carve a micro-bone if there's genuine thinking in it (one condition, one edge-case test). Otherwise just do the task and say in one line why there was no bone. Never invent busywork.

## 3. Knobs

Parse from the prompt; defaults in bold.
- Size: `small bone` (one condition/guard, ~5–10 min) · **default (one decision point, ~15–30 min)** · `big bone` (a design choice plus its implementation, ~30–60 min).
- `let me pick`: offer 2–3 candidate bones, one line each, and wait.
- A target in plain words ("bone in the query", "bone on the frontend") overrides your choice if it's a sensible bone.
- One bone per invocation. For another, they'll ask again.

## 4. Handoff

Short, scannable, then **end your turn**. Take no further action until they reply.

```
🦴 BONE: <task name>

Done
  - <what you built, one line each>
  - <tests: N written, M red — all through the bone>

Your bone (~20 min)
  <file path>
  <symbol>                                   grep "TODO(human)"
  Contract: <behaviour/invariants in plain words — what, not how>
  Done when: <exact command> is green

Reply: done | hint | take it
```

Track it in the todo list if you're using one: an item for the human's bone, then "Integrate bone and finish task".

## 5. While they work

- **`hint`** — never unprompted, one rung per request:
  1. Pointer: where to look, or which existing code is analogous.
  2. The approach / key insight, in words.
  3. A skeleton or pseudocode.
  If they're vague about being stuck, first ask them to state their approach in one sentence — then give the rung.
- **`take it`** — no shame, no friction. Write the bone (salvage their partial work if any), give the key insight in one line, and ask one short check-for-understanding question. Don't wait on the answer to keep going.
- **"not now" / "different bone"** — accept immediately; re-carve or just finish.
- Don't touch the bone region while waiting.

## 6. Resume on `done`

1. Re-read the bone's file and diff it (`git diff`) — they may have touched nearby lines.
2. Run the bone's tests first, then the relevant full suite / typecheck / lint.
3. Review, task-focused and brief:
   - Correctness first, then fit with codebase conventions.
   - Mention only **material** differences from what you'd have written (a bug, a missed edge case, an invariant, performance, a convention) and why. No praise, no grades.
   - If they took a different approach that meets the contract, adapt the surrounding code to it — not the other way round. If they changed the signature, update callers.
4. If something's wrong: show the evidence (failing output), not the fix. If tests pass but review finds a bug, add **one** red test exposing it and hand back once; after that, offer `take it`.
5. Never silently rewrite their code. If you must change it to finish, say what and why.
6. Remove the `TODO(human)` marker and finish everything else in the plan (remaining tasks, cleanup, lint, docs).
7. Optional, only if they're not clearly in flow: one line — "anything surprising?". Skip otherwise.

```
Back on it.
  Tests: <bone tests> ✓, <suite> ✓
  Review
    - <material point, or "Matches the contract; nothing to flag.">
  Then: <remaining steps you're now doing>
```

## 7. Spec-driven task lists

When the task runs through a spec/task-list workflow (OpenSpec or similar), these rules win over the workflow's own loop:

- **Where the bone goes by phase.** Exploring → a judgement bone. Proposing/designing → a decision bone (they write one design decision or one requirement's scenarios; you draft the rest around it). Applying tasks → a code bone. Archiving → no bone; refuse to archive while a `TODO(human)` exists.
- **Reserving a bone at proposal time.** If the bone is requested while writing the task list, tag exactly one task with `(bone)` so it can be vetoed in review. A later apply run honours the tag instead of choosing afresh.
- **The handoff is a pause.** An "implement until done or blocked" loop stops at the handoff. Leave the bone's task unchecked. Tasks that depend on the bone proceed against the stub, out of order if needed. On `done`, tick the task, strip the `(bone)` tag, and resume the loop.
- **Scenarios are the contract.** Write red tests for every scenario the spec lists — they're agreed intent, not hints. Edge cases the spec *doesn't* cover are theirs to find; if they surface a genuine spec gap, propose the spec update.
- **Don't carve a bone the design already solved.** If the design doc spells out the algorithm, that's transcription. Pick a bone where the design leaves room, or move it earlier as a decision bone.

## 8. Commits and continuity

- Never commit while a bone is open — the uncommitted diff is how you review their work.
- Before any commit, `grep -rn "TODO(human)"` must return nothing.
- Follow the user's normal commit rules otherwise (approval, message conventions, no pushing).
- If a new session is asked to "resume the bone", find it via the `TODO(human)` marker and the red tests, and pick up at §5.
