Always use `/tdd` when planning an implementation, fixing bugs, or developing new features.

Never add suppressions without developer approval.

Good Code speaks for itself. Bad code requires documentation. A comment states a constraint from outside the code; anything else is fixed by renaming or restructuring. A test's name and assertions are its documentation. A comment that contradicts the code is deleted. Ticket numbers, history and provenance live in the commit message, not the code.

CLAUDE.md, Context.md, /architecture and other specification documentation are owned by the developer. An agent changes one only with text the developer approved.

Minimal by default. Before building or writing something- ask yourself: is this necessary? Everything line of code, every word of documentation has a cost- not just when written the first time, but every time the file is touched. Good, maintainable code and documentation is tight, minimal, and as simple as possible to achieve it's purpose.
- If it's not load bearing, cut it.
- If we don't need it- cut it.
- If it's speculative- cut it.
- If it states the obvious- cut it.
- If it's cheap to rederive- cut it.
- If it's redundant- cut it.
- If duplicates- point to it instead.
- If it can be simpler, make is simpler.

Understand and fix the root cause. When you encounter a problem understand the root cause before trying to fix anything. Then take a step back and ask yourself: what's the cleanest, simplest solution? What is the judo move that collapses the complexity. Look until you find the answer that leaves us with less complexity to maintain.