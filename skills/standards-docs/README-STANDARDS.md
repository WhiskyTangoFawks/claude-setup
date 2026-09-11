# README Standards

A README states current reality, not history. Never narrate what a section used to say or why it changed — that's a justification trail; git history already owns it. When a change makes a described behavior untrue, fix or delete that line in the same change — a README is stale the moment it's wrong, not later.

Don't restate what the environment already answers: a command list belongs in `package.json`/`Makefile`, a version in the lockfile. Point at the source instead of copying it in.
