---
name: repo-init
description: Create or refresh a repository's AGENTS.md — a minimal, verified skeleton of what an agent needs to work effectively in the repo.
disable-model-invocation: true
---

# Repo Init

An AGENTS.md is a **skeleton**, not a narrative. It's the bones an agent leans on where the codebase itself stays silent; the flesh — background, install steps, architecture prose — belongs in the README and stays there. Every line you write here loads into every future run of every agent working in this repo, forever, so every line has to earn that.

Context files get their instructions followed reliably, but they don't reliably help task success: LLM-boilerplate context files move success rates only marginally in either direction (not statistically significant) while adding roughly 20% more cost per task — more reading, more re-verifying — and a repo overview or directory tour specifically does not speed an agent to the right file. No individual section — not overview, not tooling, not testing instructions — moves accuracy significantly on its own. Developer-edited files are the ones that measurably outperform, by cutting the filler an LLM defaults to. Treat this skill as cost-avoidance and tribal-knowledge capture, not as a lever for measurably better task success — optimize for an honest, human-edited skeleton, not a comprehensive one.

## 1. Map what already speaks

Read the existing README, `docs/`, and any current AGENTS.md. Note what's already discoverable there — that content is off-limits for duplication here; point at it instead of restating it. The exception: a directive whose violation fails *silently* (no error, no test catches it) and that nothing in the agent's guaranteed-loaded path already delivers at the point of use. Promote that here even though it's written elsewhere too — this file's instructions get followed reliably regardless of where else they're documented, which is exactly the property a silent-failure rule needs and a buried doc can't provide. A fact restated for convenience doesn't clear this bar; only a compliance-critical rule does. If you're not sure whether something meets this bar, ask the user.

A context file is redundant documentation when documentation already exists, but it's the *only* documentation when it doesn't — treat a docs-poor repo as raising the bar for what belongs here, not lowering it: anything an agent would otherwise have no way to discover now earns its place.

**Completion**: for each candidate section below, you can say "covered in README," "not covered anywhere but not needed," or "not covered anywhere and belongs here."

## 2. Tools

Identify every useful command an agent would otherwise have to rediscover by trial and error: build, test, lint/checkstyle, mutation testing, dependency/CVE scanning, and any other security scanner (e.g. Wiz) already wired into this repo. Terraform/Terragrunt plan. Things that can be used as validation gates to check an agents work. Pull these from the real config (`build.gradle`, `pyproject.toml`, `package.json`, `Makefile`, `docker-compose.yml`, Terragrunt files, CI workflow files).

This category earns its place precisely because it's easy to miss: an agent won't spontaneously go looking for a mutation-testing or CVE task it doesn't know exists, and named commands are the one thing context files reliably change agent behavior on. Keep it a flat command list, not a tutorial — that's the README's job.

**Completion**: every command you plan to include has either run successfully, or the user knows which ones are unverified.

## 3. Mine the non-obvious

Interview the user extensively — don't invent — for the invariants only someone who's worked in this repo would know. Look for hints and ambiguity in the code and the existing documentation, then ask questions to clarify, identify risks, dependencies, and domain rules a newcomer would get wrong. Skip anything a competent engineer would already infer from the code or do by default — that's a no-op, not an invariant. You're looking specifically for risks, traps, and mis-understandings that an Agent might fall into.

A rule documented elsewhere still belongs here if nothing reliably routes an agent to it. Check what actually reads that doc: a skill that reads its own config file every time it runs (e.g. a triage skill reading its tracker's PR-handling flag) already guarantees compliance at the point of use — don't duplicate that. A doc that's only reachable by an agent choosing to go looking, or one written for a different surface of the repo (a frontend doc stating a backend-authoring rule, say), guarantees nothing — promote the rule.

**Completion**: a bullet list where every rule would change what the agent does, not just restate good practice.

## 4. Draft the skeleton

Use this fixed shape, nothing else, unless step 3 surfaced a real branch:

```
# AGENTS.md

## What this is
<1-2 lines: purpose, only if not obvious from the repo name or README>

## Tools
<build/test/lint/checkstyle/mutation-testing/CVE-security-scan/Terraform Plan/...>

## Rules that matter
<bullets from step 3 — only non-obvious, behavior-changing rules>

Add a **cross-repo coupling** section only when this repo is one stage of a multi-repo pipeline and a change here routinely forces changes elsewhere — check sibling repos' AGENTS.md for the pattern already in use in this workspace before inventing a new shape. Omit it for standalone repos; that's a branch cut, not a mandatory rung.

The verified commands list is also the single source of truth [validation-gate](../validation-gate/SKILL.md) discovers from — don't write a separate checklist there; keep it here and let that skill read it.

**Completion**: a draft exists using only the sections that survived steps 1-3.

## 5. Prune, tighten, then hand off

Read the draft line by line and cut anything that fails any of these tests:
- **No-op**: would the agent already do this by default? Cut it.
- **Duplication**: is this a non-invariant that is already said in the README or the code? Cut it, or replace it with a pointer.
- **Verbosity**: run this test after the first two, on whatever survives them — it's about how a kept sentence is worded, not whether it's kept. This file is parsed by a model, not skimmed by a human eye: cut connective prose ("this repo separates X from Y"), restated qualifiers, and clauses split only for readability. Markdown emphasis (bold, italics) exists to catch a skimming human eye mid-scan; a model reads every token of the file every time regardless of emphasis, so it buys no compliance benefit and only costs tokens — drop it, unless a human also reads this file often enough in practice that their skim time is worth the spend.

Don't chase brevity as a goal in itself — file length has no measured relationship to success rate or cost either way. A short draft that still duplicates the README is no better than a long one; keep applying the tests above until nothing fails them, then stop, regardless of how long or short that leaves it.

Then hand the draft to the user to edit before it's committed. Do not write the file autonomously and call the task done — developer-edited context files are the ones that measurably outperform; an untouched first draft is exactly the kind of filler that adds cost without adding signal.

**Completion**: the user has reviewed and adjusted the draft, and the file on disk reflects their edits, not just your first pass.
