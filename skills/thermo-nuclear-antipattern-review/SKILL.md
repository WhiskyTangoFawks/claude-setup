---
name: thermo-nuclear-antipattern-review
description: Run an extremely strict review for antipatterns, failure modes, and traps left for future editors — code that works but shouldn't ship as-is. Use for a thermo-nuclear antipattern review, antipattern audit, footgun review, edge-case audit, or gotcha hunt.
disable-model-invocation: true
---

# Thermo-Nuclear Antipattern Review

`thermo-nuclear-code-quality-review` asks whether the structure is good. This skill asks a different question: does this code have a landmine in it? Code can be well-structured, pass every test, and still be wrong — not idiomatic for the tool it's using, silent about the input that breaks it, or laying a trap for the next agent who touches it. Out of scope here: file size, abstraction quality, spaghetti conditionals, coupling — that's the other skill's job. In scope: correctness-adjacent judgement calls a test suite doesn't catch and a linter doesn't run.

## Core Prompt

Start from this baseline:

> Perform a deep antipattern and failure-mode audit of the current branch's changes.
> Assume every hunk is hiding something until you've actively looked for it — don't wait for code to look wrong before scrutinizing it.
> For each piece of changed logic, ask what a domain expert in this specific language, tool, or framework would flag as not-idiomatic even though it runs; what input, ordering, or environment would make it fail; and what about it would mislead the next person who edits it.
> Be extremely thorough and rigorous. Do not accept "it works" as the bar.

## Step 0: Build the known-gotcha baseline

Before generating anything, check what's already written down — anything already covered here is already enforced elsewhere and is off-limits for this review, re-flagging it is noise:

- The root `AGENTS.md`, plus the nearest ancestor `AGENTS.md` to each touched file.
- Any `standards-*` skill applicable to a language or tool touched in the diff (`standards-python`, `standards-java`, `standards-docs`, and any others available).

## Scope

Diff-scoped by default: `git diff <fixed-point>...HEAD` against whatever fixed point the user names (same convention as `code-review`). But a hunk's antipatterns and failure modes often live in what calls it, not the hunk itself — open the surrounding file or call sites whenever judging an edge case needs more than the diff shows. There's no fixed rule for how far to look; use judgement, the same way you'd decide how much context a real reviewer would pull up before commenting.

## The Three Lenses (Non-Negotiable)

Every finding belongs to exactly one of these. If it doesn't fit any of the three, it's out of scope for this skill.

1. **Antipatterns** — the code is technically correct but not how an expert in this language/tool/framework would do it. The tell: a more idiomatic option exists that the current code doesn't use, usually because the less-idiomatic one is the first thing that comes to mind rather than the documented or conventional one.
2. **Failure modes** — ways the code breaks under conditions the diff doesn't handle: empty/null/huge input, concurrent access, retries, partial failure, timezone/locale/encoding assumptions, network or filesystem unavailability, an environment variable that's unset, unexpected edge cases.
3. **Traps for future editors** — code that will actively mislead whoever edits it next: a name that implies different behavior than it has, an invariant that holds only because of something non-local, a special case that looks removable but isn't, implicit ordering or state one file depends on silently.

## Primary Review Questions

For every meaningful change, ask:

- If an expert in this exact language/tool/framework reviewed this hunk, what would they say to do instead — and why does that alternative exist?
- What's the smallest input, timing, or environment change that breaks this?
- If this fails, does it fail loudly, or does it fail silently and surface somewhere else entirely?
- Does anything here rely on an assumption that's true today but isn't guaranteed (ordering, a single caller, a specific runtime)?
- Would the name, comment, or shape of this code lead the next editor to a wrong conclusion about what it does or why it's safe to change?
- Is this pattern copied from somewhere that had different constraints than this call site does?

## What to Flag Aggressively

- Using a mechanism that "happens to work" instead of the tool's documented/blessed mechanism for the same job.
- Error handling that swallows or downgrades a failure instead of surfacing it.
- Input handling that assumes well-formed, present, or bounded data with nothing checking that assumption.
- Concurrency, retries, or ordering that only work under the timing the author happened to test.
- A name, comment, or type that promises something the implementation doesn't actually guarantee.
- A special case whose removal condition isn't written down anywhere.
- Config, secrets, or environment values read anywhere other than at the boundary the codebase already establishes for that.
- Anything that would make the next agent's diff *look* correct while being wrong, because the trap isn't visible in the lines they'd touch.

## Preferred Remedies

- Point at the idiomatic mechanism by name (the actual documented API/pattern), not just "this feels off."
- For a failure mode, name the specific input or condition that triggers it, not "this could be more robust."
- For a trap, say what a future editor would wrongly conclude and what would make the code state its real constraint instead (a rename, an assertion, a comment stating the non-local dependency).
- Prefer surfacing failures over swallowing them, and explicit boundaries over implicit assumptions.

## Review Tone

Direct and demanding— not rude, but do not soften a real footgun into a nitpick. "This works" is never the approval bar on its own.

## Output Expectations

Prioritize: failure modes that would reach production over antipatterns, and antipatterns over traps-for-editors (a trap only bites later; a failure mode bites now). For each finding, name which of the three lenses it is, quote the hunk, and state the concrete trigger (the input, the timing, the future edit) that turns it from theoretical into real.

## Promotion Flow

A finding that's a one-off gets reported and left there. A finding that's the kind of thing that'll recur — because it's a durable fact about this repo or this ecosystem, not a one-time slip — is worth writing down so the next agent doesn't rediscover it the hard way. For each such finding, classify it before proposing anything:

- **Repo-specific** (only true in this codebase): apply `/init`'s bar inline — silent failure, not already mechanically enforced, not already reliably routed to. If it clears, propose the exact bullet and which `AGENTS.md` it belongs in (root or the relevant nested one).
- **General to the ecosystem** (would hold in any repo using this language/tool): propose the exact addition to the relevant `standards-*` skill. If none covers this technology yet, say so instead of forcing a fit.

Either way: propose the text and destination, then stop. Never write to `AGENTS.md` or a `standards-*` skill directly — both depend on being deliberately curated, not agent-authored, so the human places the line.