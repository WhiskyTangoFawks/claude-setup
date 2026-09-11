Always use `/tdd` when planning an implementation, fixing bugs, or developing new features.

Never add suppressions without developer approval.

Code speaks for itself. A comment states a constraint from outside the code; anything else is fixed by renaming or restructuring. A test's name and assertions are its documentation. A comment that contradicts the code is deleted. Ticket numbers, history and provenance live in the commit message, with one exception: a comment on already-filed tech debt cites its ticket as `debt #NNN`, so the debt is neither relitigated nor refiled.

Enforce invariants. A rule a test, lint rule, analyzer or hook can check lives there, and its failure message is its documentation. CLAUDE.md, specs and comments can be ignored, and should carry only what no gate can express.

CLAUDE.md, ADRs, Context.md, and other specification documentation are owned by the developer. Propose the exact text; apply it only on approval.