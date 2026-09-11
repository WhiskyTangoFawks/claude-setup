---
name: standards-docs
description: Documentation standards for READMEs, code comments, ADRs, and CONTEXT.md glossaries. Required to read before writing, editing, or reviewing documentation.
---

# Documentation Standards

Documentation need to earn it's place. Everything the agent has to read has a cost in tokens paid every time the file is touched, so be concise, and document only what is truly necessary, nothing more.

## Code Comments

- Code speaks for itself. A comment states a constraint from outside the code; anything else is fixed by renaming or restructuring the code.
- A test's name and assertions are its documentation. 
- A comment that contradicts the code is deleted.
- Ticket numbers, history and provenance live in the commit message, not in documentation. The only exception to this is tech debt or a bug where a ticket exists and is still open, so the it is neither relitigated nor refiled.

## Prose

Write prose in ASD-STE100 (Simplified Technical English) where it applies: one idea per sentence, short sentences, active voice, present tense, one term per concept — never a synonym for a concept already named.

The sentence-level rules (short, active, one idea, one term) apply everywhere prose appears — README, ADRs, CONTEXT.md, comments. The approved-vocabulary restriction does not: a CONTEXT.md entry or an ADR's rationale keeps its precise domain term rather than simplifying it away.

This matters more for an agent than for a human reader. A short, single-clause, active-voice sentence has one parse; a sentence with subordinate clauses or passive voice invites the wrong one. One term per concept is the same discipline CONTEXT.md already applies to nouns ("be opinionated"), applied to prose generally.

## Diagrams

Reach for a diagram when the content is graph-shaped: branches, concurrent actors, states with more than one valid transition, or relationships between more than two entities. A linear procedure stays a list — a diagram for a sequence with no branching is decoration, not communication.

Default to Mermaid, fenced in the doc itself — plain text renders for a human and parses for an agent the same way code does. Reach for D2 only when a diagram outgrows what Mermaid can express (dense architecture, many components, custom layout).

Never a linked or embedded image with no source committed alongside it — it costs multimodal tokens to read and drifts silently, since nothing about the diff signals it went stale.

## Single source of truth

A fact lives in exactly one place. Point at the source instead of restating it. A doc that restates the environment is a cache, and caches go stale; only cache what a reader can't get by looking- an unwritten convention, a gotcha, the reason behind a choice.
Do not document knowledge that is cheaply rederived from the code- this creates a 2nd source of truth.

# By artifact type

- README — [README-STANDARDS.md](./README-STANDARDS.md)
- ADRs — [ADR-STANDARDS.md](./ADR-STANDARDS.md)
- CONTEXT.md glossaries — [CONTEXT-FORMAT.md](../domain-modeling/CONTEXT-FORMAT.md) (domain-modeling skill)

# Reviewing documentation

A doc can follow its template and still fail the bar above. See [REVIEW-CHECKLIST.md](./REVIEW-CHECKLIST.md) for the anti-patterns to check for, per artifact type.

