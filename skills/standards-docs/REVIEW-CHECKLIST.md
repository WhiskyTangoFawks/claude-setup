# Documentation Review Checklist

Anti-patterns to check for when a diff touches documentation. Each reads *what it is* → *why it fails the bar*, the same shape as a code smell — a judgement call, not a hard violation.

## Prose

Check against ASD-STE100 as the target, not a pass/fail gate — see the Prose section of [SKILL.md](./SKILL.md) for what applies where.

- Multi-clause sentence — subordinate clauses chain two or more ideas into one sentence. → split into one sentence per idea.
- Passive voice — the sentence hides the actor ("the config is loaded" instead of "the app loads the config"). → rewrite active.
- Synonym drift — the same concept is named with two or more different words across the doc. → pick one term, use it everywhere.
- Complex vocabulary — a rare or long word stands in for a common one that says the same thing. → replace with the plain word.

## Across documents

- Restated fact — a fact the diff adds already lives in another document, changed or not. Two copies drift apart. → grep the repo for each fact the diff adds; keep it in the document that owns it and point at it from the rest.

## Diagrams

- Diagram-shaped prose — a paragraph makes the reader assemble a branching or multi-actor relationship in their head. → suggest a Mermaid diagram instead.
- Prose-shaped diagram — a flowchart draws a plain linear sequence with no branching. → replace with a list.
- Image-only diagram — an exported image with no Mermaid or `.drawio` source committed alongside it. → add the source so it's diffable and agent-readable.
- Stale diagram — contradicts what the code or ADR actually does. → same staleness bar as any other doc; fix or delete.
- Restated schema — an ER or class diagram duplicates what's already precisely defined in code with nothing added. → cut it, point at the source.

## CONTEXT.md / CONTEXT-MAP.md

- Scratchpad drift — an entry describes an implementation detail, a "how it works," or a decision instead of a glossary term. → belongs in an ADR or nowhere; cut it.
- General-concept bloat — a term is a general programming concept (timeout, retry, DTO) with nothing specific to this domain. → cut it.
- Restated code — the entry repeats what the type or field name already says, with no disambiguating detail. → cut it.
- Fence-sitting — two or more terms are listed for the same concept with none marked canonical. → pick one, move the rest to `Avoid:`.

## ADRs

- Doesn't clear the bar — check the decision against the three-part test in [ADR-FORMAT.md](../domain-modeling/ADR-FORMAT.md#when-to-offer-an-adr) (hard to reverse, surprising, real trade-off). If any leg fails, question whether the ADR should exist.
- Template bloat — Considered Options or Consequences is filled with generic filler rather than content that couldn't be inferred. → cut the section.
- What not why — records the decision but not the reasoning, so a future reader can't tell if it still applies. → flag as incomplete.
- Rewritten history — an `accepted` ADR's decision text was edited in place instead of superseded (see [ADR-STANDARDS.md](./ADR-STANDARDS.md)). → should be a new ADR with the old one marked `superseded by`.
- Not a decision — the entry documents a process, runbook, or implementation detail rather than an architectural decision. → doesn't belong in `docs/adr/`; move it or cut it.
- Implementation detail in a sentence — a sentence says how the decision is carried out: a named library, an OS behaviour, a trigger list, an example. It goes stale when the code changes and the decision does not. → test every sentence: delete each one whose removal leaves the decision unchanged. Move a tactic the reader needs to the spec or the commit message.
- Bloated — the required paragraph runs well past the 1-3 sentences the format calls for. → find the strategic principle and restate it; a decision that doesn't fit a paragraph isn't crisp yet.
- Bad File Name — The filename and title should match. They should be a shortest possible phrase that convers the decision. The list of files is the index an agent searches to determine if it needs to read an ADR. Filenames are load bearing.

## READMEs

- Changelog creep — narrates what a section used to say or why it changed. → that's git history's job; cut it.
- Stale claim — describes behavior the same diff changed elsewhere without updating this line. → flag as now false.
- Restated environment — copies a command list or version already in `package.json`/lockfile/`Makefile`. → point at the source instead.

## Code comments

- Explanatory — the comment explains what should be expressed through variable, method, or class naming. → fix the naming.
- Deoderent — comment explains why the code is structured badly. → restructure the code.
- Restates the code — the comment says what the next line already shows. → flag as a no-op comment.
- Ticket exhumation — a ticket number or history note for an issue that's already closed. → cut it.
- Contradicts the code — describes behavior the code no longer has. → should have been deleted with the change that broke it.
