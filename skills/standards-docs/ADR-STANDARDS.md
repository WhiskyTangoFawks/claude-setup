# ADR Standards

Follow the template and structure in [ADR-FORMAT.md](../domain-modeling/ADR-FORMAT.md) (domain-modeling skill).

Revising a decision has two paths, chosen by the old ADR's status:

- `proposed` — still being decided, not yet merged to main. Edit the ADR in place; don't leave a trail of the earlier draft.
- `accepted` — settled, code already depends on it. Never rewrite the decision text in place. Write a new ADR with the new decision, and set the old ADR's status to `superseded by ADR-NNNN`.

Editing an accepted ADR in place to argue against its own past self is a justification trail — it destroys the record of what was actually built and why. Supersede instead.
