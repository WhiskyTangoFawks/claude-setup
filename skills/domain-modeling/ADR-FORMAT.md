# ADR Format

ADRs live in `docs/adr/` and use sequential numbering: `0001-slug.md`, `0002-slug.md`, etc.

Create the `docs/adr/` directory lazily — only when the first ADR is needed.

## Template

```md
# {The decision, as the shortest phrase that states it}

{1-3 sentences: the forces, the decision, and why. Name the principle it applies.}
```

That's it. An ADR can be a single paragraph. The paragraph is the ADR's authority, and every section below it serves the paragraph. An ADR holds strategy only. A tactic, such as a mechanism, a name, a file, a test or what a view shows, belongs to the implementor, in the code and tests.

## Optional sections

Include one only when it adds genuine value. Most ADRs need neither. Never number a section's items: a line inside an ADR is never a citation.

- **Consequences.** An effect of the decision that a reasonable reader holding only the paragraph would get wrong. Each bullet carries its reason, so it reads as the decision applied, not as a rule.
- **Alternatives rejected.** An option a reasonable reader would propose, and why not. Often the best carrier of intent.
- **Status** frontmatter (`proposed | accepted | deprecated | superseded by ADR-NNNN`), useful when decisions are revisited.

## Numbering

Scan `docs/adr/` for the highest existing number and increment by one.

## When to offer an ADR

All three of these must be true:

1. **Hard to reverse** — the cost of changing your mind later is meaningful
2. **Surprising without context** — a future reader will look at the code and wonder "why on earth did they do it this way?"
3. **The result of a real trade-off** — there were genuine alternatives and you picked one for specific reasons

If a decision is easy to reverse, skip it — you'll just reverse it. If it's not surprising, nobody will wonder why. If there was no real alternative, there's nothing to record beyond "we did the obvious thing."

### What qualifies

- **Architectural shape.** "We're using a monorepo." "The write model is event-sourced, the read model is projected into Postgres."
- **Integration patterns between contexts.** "Ordering and Billing communicate via domain events, not synchronous HTTP."
- **Technology choices that carry lock-in.** Database, message bus, auth provider, deployment target. Not every library — just the ones that would take a quarter to swap out.
- **Boundary and scope decisions.** "Customer data is owned by the Customer context; other contexts reference it by ID only." The explicit no-s are as valuable as the yes-s.
- **Deliberate deviations from the obvious path.** "We're using manual SQL instead of an ORM because X." Anything where a reasonable reader would assume the opposite. These stop the next engineer from "fixing" something that was deliberate.
- **Constraints not visible in the code.** "We can't use AWS because of compliance requirements." "Response times must be under 200ms because of the partner API contract."
- **Rejected alternatives when the rejection is non-obvious.** If you considered GraphQL and picked REST for subtle reasons, record it — otherwise someone will suggest GraphQL again in six months.
