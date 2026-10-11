# Mutation-test triage (shelved)

Tool-agnostic triage for mutation-testing results, kept for a future repo whose suite is fast
enough to mutate. It was the **Suite axis** of a code review, beside Standards and Spec.

This document is the whole job of the Suite axis review subagent: run the mutation
tool, triage every finding to a disposition, report the table. The table is the entire
deliverable — propose only, change no files.

The other two review axes read what the code *says*; this one asks whether the suite
would notice if it said something else. A test that executes a line without
constraining it looks identical to a good test in a diff and in a coverage report — it
shows up only when the line is changed and nothing goes red. A mutation run changes
every line and reports where nothing went red, so each `Survived` or `NoCoverage`
finding is a **review target site**, read the way a reviewer reads a PR: *show me the
requirement that earns this line its place.*

A correct `/tdd` slice writes only code a test demanded, so its mutants all die. Each
finding points at one of the two ways a slice goes wrong: speculative generality, or
mechanism-not-outcome.

**Done when** every finding carries exactly one recorded disposition and the table is
reported. A table of documented accepts passes exactly as a table of deletions does.

## 1. Run the tool

Scope the run to the review's fixed point, or take results the caller supplied. Wrap the
tool so it prints only the parsed findings; never read the raw report into context, and
never let a mutation score reach it — a score in context becomes a target (§Why
dispositions).

- **Compute the diff with git yourself** and hand the tool an explicit mutate list. A
  tool's own `since` mode can resolve against the wrong checkout inside a linked worktree.
- **Detach the run and poll it.** A run outlasts a foreground command cap, and a
  foreground call killed partway looks exactly like a silent failure. **Every check-in
  while waiting reports a progress figure** (mutants tested so far / total, once the
  tool has printed one) — a bare "still running" is indistinguishable from hung.
- A diff touching two runtimes gets both runs, **sequentially** — a mutation run
  saturates memory as well as CPU, and two at once can OOM-kill the machine.
- **A zero-finding result against a diff the review says exists is a mis-scope, not a
  clean audit.** Make the wrapper exit non-zero on a report where no mutant was tested,
  instead of printing "No issues found." Re-scope on the changed files; never report the
  run as clean.
- **Read the count, not the success line.** "No issues found" is a claim about mutants
  that *ran*. Before reporting an axis clean, state how many were actually tested — an
  audit of nothing passes every check that isn't looking for it.

**Done when** every `Survived` and `NoCoverage` finding is listed with file, line, and
mutator.

## 2. Interrogate each finding

Answer for each finding: what specified user-facing requirement does the line serve?
Read the surrounding code, the tests that cover the line, the spec or issue behind it.
The answer routes the finding:

| Answer | Route |
| --- | --- |
| None | **A — the code hasn't earned its place** |
| A requirement, tests cover the line, yet the mutant lived | **B — the test is weak** |
| A requirement, but no test observes it | **C — a real gap** |

**Executed is not constrained.** A file whose mutants nearly all *survive* rather than
show as uncovered is not thereby a route-B file. Its tests may assert outcomes perfectly
well while their fixtures fail to discriminate the branches — a lone `Data/` folder that
satisfies two different code paths identically leaves no assertion able to tell them
apart. That is a missing scenario, which is route C. Read the covering tests before
concluding either way; the survived-to-uncovered ratio does not decide it.

Fast path — on `Equality` / `Conditional` / `Null coalescing` mutators, first check
whether both branches are provably equal *at exactly the mutation point* under an
invariant elsewhere (an enum-severity ordering, a sentinel no real value can match,
mutually-exclusive data sources). If the invariant exists, record **Equivalent** and
move on.

**Done when** every finding has a route.

## 3. Assign one disposition

Within the finding's route, record the first disposition that fits. Across routes the
preference is A over B over C: changing the code beats changing a test beats adding
one. **A test's justification is a requirement, never a surviving mutant** — if no
requirement names the line, the finding is route A.

**Code-changing dispositions carry a differential, written into the row.** A
disposition that changes code is a behavior claim, and mutation testing cannot check
it — a run scores the code as written, with no opinion on whether it still does what it
did before. So the row states what the old code produced and what the new code
produces — as outputs or sets, not as a description of the mutation site — and names
the input that distinguishes them. If none exists, the row says so; for a delete, "no
observable difference on any reachable input" *is* the finding.

**Route A — no requirement (code smells, `/code-review` vocabulary):**

- **Delete** (**Dead Code**, **Speculative Generality**) — guards impossible or
  unreachable state, or serves a need the spec doesn't have → remove it.
- **Simplify** (**Speculative Generality**) — the construct is stronger than the need
  (`?? ""` on a non-nullable) → rewrite so the mutation site ceases to exist.
- **Inline the middle man** (**Middle Man**) — the line only delegates onward → call
  the real target direct.
- **Unify the duplicate** (**Duplicated Code**) — the same logic lives elsewhere →
  extract one shared copy; coverage follows it. **Unifying is in scope when the
  duplication is what produced the findings**, and does not wait for its own ticket —
  deferring it to keep a diff small is the most common way this route gets missed.
  Twice the duplication was the very thing making the surrounding dispositions correct:
  an equivalence that holds only because of who calls a function is an equivalence a
  second copy quietly erodes.
- **Accept as invariant** — a defensive check at a trust boundary with no behavior a
  requirement-level test could observe → record why the code exists *and* why no test
  can see it.
- **Equivalent** — the mutation cannot change observable behavior → record the
  invariant that makes it.

**Route B — covered, yet survived (test smells):**

- **Fix the assertion** — the test asserts mechanism, not outcome, so the mutant slips
  past it. Name the smell from the taxonomy below and describe the assertion the
  requirement actually observes.

**Route C — a requirement with no test:**

- **Red-green** — the behavior is user-visible and unspecified → get the requirement,
  then run a full feature-level red-green cycle (`/tdd`).
- **Request a fixture** — the guard handles malformed external data you cannot
  synthesize → the code is likely genuinely needed; ask the developer for real data,
  then write the behavioral test against it.
- **Refactor the seam** — the behavior is real but hidden behind a dependency no test
  can reach → expose the seam, then test at it.

**Done when** every finding records exactly one disposition.

## 4. Report the table

The table speaks code-review, not the mutation tool: each row is a finding with its disposition
and reason, the mutant appears only as evidence ("negating this condition changes
nothing the suite observes"), and *survived*, *killed*, and *score* stay in the log.
Group rows **by disposition, not by file** — fifty findings in one file are usually one
or two pieces of work, and the grouping is what makes that visible.

Format (one `###` section per disposition actually used):

```
## Suite review — vs <fixed point>

<N> mutants tested across <files>. (Zero means the run was mis-scoped and there is
no result to report — see §1.)

Each row is a reviewed finding with a recommended disposition — review target
sites, not a coverage report. A row closes when its disposition is applied or
rejected; there is no score to reach.

### Delete (route A — no requirement found)
- file:line — <finding>. Differential: old code <X>, new code <Y>, distinguished
  by <input>; or: no observable difference on any reachable input.

### Fix the assertion (route B — <smell name>)
- file:line — <what the test asserts> vs. <what the requirement observes>.

### Requirement without a test (route C — proposals)
- file:line — requirement: <spec/issue reference>.

### Accept / Equivalent (stay open by design)
- file:line — invariant: <why no test can observe the behavior>.

N findings: a <disposition>, b <disposition>, ... — one count per disposition
section actually used above, summing to the parsed report's N.
```

Before reporting, the table must survive its own gate:

- **The count adds up.** Sum the groups and state the sum. One table reported `✓ 66`
  over groups summing to 60; the six missing findings existed only in prose, where
  nobody could check them.
- **No row contradicts another.** A finding accepted as unobservable, in a table that
  also proposes a test asserting the very thing that would observe it, means one of
  those two rows is wrong. Read the table against itself before sending it.
- **Route C names a requirement, not a mutant.**
- **Every code-changing row carries its differential** (§3).
- **Duplication found during triage is dispositioned, not deferred.**
- **Watch what is driving your routes.** Many C rows can mean step 2 was skipped —
  routes assigned by what would kill the mutant — or that the code genuinely is
  unconstrained; a file whose fixtures never discriminate its branches produces honest
  C rows in bulk. The test is whether every row names its requirement, not how many
  rows share a route.

Report the table and nothing else.

## Test-smell taxonomy

Vocabulary for route B — use these names so a mutation finding and a static-review
finding compose. Flag with concrete evidence from the test body.

- **mechanism-not-outcome** — asserts internal call counts, intermediate state, or
  private structure instead of observable behavior (`retries == 3`).
- **vacuous** — no assertion; only "does not throw"; or asserts a value it just set.
- **self-referential** — the expectation derives from the same source as the behavior:
  asserting against the very constant the code under test imports, or building a fixture
  out of the collection being verified. Both sides move together, so the test cannot
  fail. Invisible to coverage and to a static read of the diff — it looks like a normal
  passing test — and it has appeared twice.
- **over-mocking** — mock verifies mock; the test proves the wiring it declared.
- **coupled-literals** — exact strings, magic numbers, or ordering the spec never
  constrained.
- **redundant** — multiple tests exercising the same behavior; collapse candidates.
- **multi-behavior** — several unrelated behaviors asserted in one test.
- **testing-the-framework** — exercises library behavior rather than our own logic.

## Why dispositions, not a score

A kill-rate is Goodhart's law in miniature: make it the target and it stops measuring
anything, because the cheapest way to raise it — a micro-test asserting the very
implementation detail one named mutant touched — re-couples the suite to internals,
the exact coupling `/tdd` exists to prevent. A disposition invites the cheapest way to
be honest, which is usually deletion.

So the rules hold in both directions: every test enters the suite through a requirement
and a full red-green cycle, and every accept enters the record with its invariant. That
is why a table of documented accepts is a pass, and an unexamined 100% kill-rate proves
nothing.

The Goodhart pull is strongest once a fix is in hand: "is the mutant dead yet" is the
only cheaply-checkable proposition in the workflow, while every question worth asking —
is there a requirement, is this equivalent, has this code earned its place — needs
judgment. That asymmetry is why a row closes on its disposition, never on a kill, and
why the report carries a table rather than a score.

## Receiving the findings

The table's rows are review findings, triaged like any other review's (fix now / defer /
escalate / reject). Rules specific to this axis:

- **Resolve the fixed point to an immutable SHA before dispatch**, and give the axis its own
  detached worktree pinned there (`git worktree add --detach <path> <sha>`), never one a live
  executor shares.
- **Nothing is edited before the table is approved.** The grouping by disposition shows the
  real shape of the work.
- **A row closes when its disposition is applied or rejected, gated by the unit suite going
  green.** There is no mutation re-run inside the ticket: the next per-diff run re-audits
  whatever changes again. Rows accepted as invariant or equivalent are closed by their
  recorded reasoning and stay in the report by design.
- **A test enters the suite only through a requirement and a full red-green cycle** (`/tdd`).
  Route C rows are proposals for exactly that — surfaced to the developer, not applied. Seam
  refactors likewise.
- **"This branch is unreachable" licenses removing it, not replacing it.** One slice deleted
  a branch on the correct premise and remapped values in the same edit; every gate stayed
  green and a user-visible behavior broke silently. Each code-changing row carries its
  differential for exactly this check. The safety net for a change is a **case**, not a
  file: a test that passes both before and after proves nothing about it.
- **Suppressions only with developer approval, always with a reason** — config-level over
  source-level. A suppression without the reasoning (why the code exists, why the mutation
  is inert) is rejected.

## Cost, measured

Stryker.NET 4.14.2 on a 12-core host, 2026-09: the tool runs the target's whole test suite
once before any mutant, so a suite slower than the budget can't fit even a one-file run. A
40-test project mutated whole in 35 s; a 710-test project whose plain test run took 4.5 min
could not. Solution mode ignored `test-projects` and ran every test project that referenced
the target. Source generators built for a newer .NET than the tool's Roslyn failed to load,
so `[GeneratedRegex]` projects aborted at compile. Measure before adopting.
