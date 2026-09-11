---
name: design-stress-test
description: Stress-test a proposed design, architecture, or plan before it's built — check it holds up, and that it's the simplest shape that holds up, weighing every new module/script/abstraction against its ongoing review-and-maintenance cost. Use when the user proposes an architecture, design, or implementation plan, worries a solution is over-engineered, or asks if a simpler approach exists.
disable-model-invocation: true
---

# Design Stress Test

Stress-testing a design has two axes, and the second is the one that gets skipped: does it hold up, and is it the *simplest* thing that holds up. A design that survives every edge case but carries three modules, a config surface, and a script that a simpler shape wouldn't need has still failed half the test.

## Process

### 1. Confirm it holds up, then capture the requirements behind it

A simpler design that doesn't survive its edge cases isn't a win — walk the failure modes and edge cases first. Once it holds up, list every requirement driving it. Tag each one **hard** (a real external constraint: a contract, an SLA, a system you don't control) or **assumed** (nobody has confirmed it, it just felt necessary). This tag is what step 2 interrogates.

### 2. Run the collapse test on assumed requirements

For each assumed requirement, ask: if we dropped this, what disappears with it? Not "what breaks" — what whole *branch* of the design goes away: a mode, a config surface, a class of edge case, an entire module.

A requirement whose removal collapses a branch is load-bearing for complexity, not just for behavior — put it to the user, don't decide it for them. Ask one question per assumed requirement, framed as: dropping this collapses `[branch]` — do we still need it? Include your recommended answer, then wait for the user before settling each requirement kept, cut, or deferred.

Hard requirements skip the collapse test — you don't get to negotiate a contract away — but still flow into step 3.

### 3. Locate where the complexity actually lives

For every requirement that survived step 2, walk the design and name where it put complexity: a new module, script, service, config knob, conditional, dependency, or wrapper. For each locus, name the module it lives in, and whether that module's swap-out point (its **seam**) is real or hypothetical — one place built to vary is a guess at a future need, two places actually varying today is proof the seam earns its keep.

### 4. Challenge every locus: delete it, don't just move it

Don't stop at "this could be tidier" — look for the reframing that deletes the complexity outright rather than relocating it. For each locus, ask:

- Can existing machinery absorb this, or does it genuinely need a new module/script/service?
- Is this a seam earning its keep today, or a wrapper built for a future that hasn't arrived?

Every new moving part is a **liability**, not an asset: it costs a reviewer attention now and a maintainer attention on every future change, whether or not it's ever exercised. Weigh that carrying cost explicitly against the requirement it serves — a rarely-needed script that takes a reviewer ten minutes to understand and a maintainer an afternoon to safely change is not free just because it works.

### 5. Report the simplified design

For each requirement: kept, cut, or deferred, and what complexity that decision removed. Then the resulting design — the version with every collapsed branch actually gone, not hidden behind a flag or an unused parameter.

## Completion criterion

Done when every assumed requirement has been through the collapse test, every complexity locus from a surviving requirement has been checked for a deletion path (not just a tidier version), and nothing is approved on "it works" alone.
