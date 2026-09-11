# Handoff: what the ADR pass taught, and what to change in the skills

Written at the end of the ADR pass under #753. The set went from 37 files and 2801 lines to
19 files and 770 lines, one document per sitting with the maintainer. This records the failure
patterns that repeated across files, the positive guidance that would keep an agent off them,
and the exact skill edits proposed. Nothing here is applied; the skills are the maintainer's.

## The patterns, with their root causes

1. **Mechanism written as decision.** Exclusion tables, header allow-lists, column names,
   endpoint lists, timings, survey percentages, line-number citations into xEdit's source. Seen
   in 0042, 0001, 0041, 0016, 0034. Root cause: the format gave a three-part test for whether to
   write an ADR and no model of what goes in one, so the agent wrote everything it knew at
   decision time.
2. **Amendment sediment.** "As amended by", "a later amendment", "landed since", "was the one
   exception; it is now", a rejected-alternatives list arguing against a numbered-filename
   scheme that no longer existed. Seen in 0027, 0005, 0041, 0042, and the 0035 to 0001 to 0044
   chain. Same root as 1: a rule for adding text and none for replacing it, so every revision
   appended.
3. **Adoption recorded as a ruling.** The two-axis conflict model, the grid's tree model, the
   worldspace tree, the missing-master behaviour. Each was xEdit's or MO2's answer adopted under
   0034 or 0027, and each got its own ADR. Root cause: the three-part test was applied to "we
   do X" without first asking which existing rule already makes X the default.
4. **Intent recorded as accepted.** Four scripting and agent ADRs, the repair engine, the
   template-flag gate, the transposed view. None built, all accepted. Root cause: the tracker
   refuses speculative issues, so design intent had no home and the ADR became the notebook.
5. **Titles carrying reasoning, clauses, negation or abstract nouns.** "The load order is
   mirrored, not loaded: one reconcile verb, every copy registered, no session." "The document
   is the model." "Between contexts." Root cause: the only title rule was "match the filename,
   shortest phrase", which says nothing about what the phrase is.
6. **Two decisions in one file.** Placement plus format in 0021, lifecycle plus no-VFS in 0022,
   persistence plus registration in 0001, thirteen invariants over three decisions in 0046. Root
   cause: ADRs were written per refactor or per PRD, and a PRD lands several decisions at once.
7. **Neighbours restated.** 0005 restating 0032 and 0041, 0031 restating 0032, 0026 and 0034, an
   inline definition of Effective masters, a scope paragraph copied from CLAUDE.md. Root cause:
   the single-source-of-truth rule lives in the skill's prose section and never reaches the ADR
   template.
8. **Claims the code contradicts.** A ruling that creation prompts for an EditorID while the
   handler does the opposite; "conflict detection is a GROUP BY" while 0016 rejected SQL;
   recursive CTEs nobody uses; an ADR declaring itself invalid. Root cause: domain-modeling
   cross-references the glossary with code and says nothing about doing the same for an ADR.
9. **Surface behaviour in the ADR.** Gesture tables, keyboard lists, tooltip wording, the
   leading slot's three states. Root cause: no stated home for "how the surface behaves".
10. **Numbered invariants as an API.** Around a hundred code comments cited "ADR-0046 invariant
    7" and the like: precise, and a hundred-file churn the moment a file was restructured. A
    citation convention nobody set.

## Guidance that keeps an agent on the path

Each states the target behaviour and gives it a word to think with. None names the failure.

- **A shape, not a test.** Behind the three-part gate, the agent needs a picture of a finished
  ADR: a *thesis* paragraph, three to seven *invariants* of two or three sentences, *alternatives*
  one line each, an optional *derived* section for present-tense observations no gate pins yet.
  Give the shape a size: *one screen*. A checkable completion criterion drives the pruning that
  "be concise" does not.
- **Every mechanism has a gate; name the gate.** When the agent finds itself writing a table, a
  column, an endpoint or a timing: find the test that pins it and write the test's name in its
  place. The word is *pinned*: a pinned fact leaves the ADR. Naming the gate also makes the agent
  go and check that it exists, which is pattern 8's cure arriving for free.
- **Every decision has one home.** A routing table read before writing: a *ruling* goes in an
  ADR; *how a surface behaves* goes in the spec; a *term* goes in the glossary; a *pinned fact*
  goes in its test; *intent for unbuilt work* goes in the PRD. The word is *home*. Patterns 3, 4,
  7 and 9 are all the wrong home, and a table answers that in one lookup.
- **Ruling versus adoption.** A fourth question ahead of the three: which existing rule already
  makes this the default? If one does, the spec records it as adoption. Only a divergence earns a
  line, as 0034's register already does.
- **A revision is a rewrite.** Rewrite the whole file to present tense; put what changed in the
  commit message. This gives the agent something to do with old text other than append to it.
  ADR-STANDARDS.md still says never edit an accepted ADR in place, which contradicts this repo's
  CLAUDE.md.
- **The title is the decision as a sentence.** It names the concrete things the decision
  governs, by their glossary names, and states what was decided. Three exemplars carry the rule:
  "Mutagen is the parser", "Every plugin copy is indexed", "Mod Management hands Editing the load
  order".
- **Cite an ADR by number and by its words.** "ADR-0047: the write side reads only the systems
  of record" survives restructuring and reads as a constraint on its own.
- **Read the code the ADR governs before writing it.** Domain-modeling already has this step for
  the glossary; one sentence extends it to ADRs.

## Proposed skill edits

### `domain-modeling/ADR-FORMAT.md`, replacing the Template and When-to-offer sections

```md
## Shape

An ADR fits on one screen. The title is the decision as one short sentence that names the
things it governs by their glossary names: "Mutagen is the parser", "Every plugin copy is
indexed", "Mod Management hands Editing the load order". The filename is the title.

# {The decision as a sentence}

{Thesis: the decision and its reason, three to five sentences, present tense.}

## Strategic invariants

1. **{A rule an agent can apply without asking.}** {Two or three sentences: the rule, then why.}

## Alternatives rejected

- **{The alternative.}** {One line: why it lost.}

Optional, when present-tense observations exist that no gate pins yet:

## Derived tactical observations

Every mechanism has a gate. A table, a column, an endpoint, a timing or a measurement is
pinned by a test; write the test's name where the mechanism was, and the mechanism moves
to it.

## Which home

| It is | It lives in |
|---|---|
| A ruling: a choice made against a reference or an earlier decision | an ADR |
| Adoption: what the reference already answers | the surface spec |
| How a surface behaves | the surface spec |
| A term | the glossary |
| A fact a test pins | that test, named in the ADR |
| Intent for work not yet built | the PRD |

## When to offer an ADR

First: which existing rule already makes this the default? If one does, it is adoption and
the spec records it. Otherwise all three must be true: hard to reverse, surprising without
context, the result of a real trade-off. One decision per ADR; a PRD that lands several
decisions writes several.

Before writing or revising, read the code the ADR governs, and name the gate for every
mechanism you leave out.
```

### `standards-docs/ADR-STANDARDS.md`, replacing the two revision paths

```md
A decision changes: rewrite the whole ADR to present tense, in place, and put what changed
in the commit message. Supersede, a new ADR plus a `superseded by` line on the old, only
when the old decision must stay citable after release; pre-release, rewrite.
```

### `standards-docs/REVIEW-CHECKLIST.md`, ADR section, five entries added

A checklist is the one place a named anti-pattern belongs: it runs on a diff, not in the
writer's context.

```md
- Adoption as ruling — records what the reference already answers. → the spec; one line in
  the reference ADR's register if it diverges.
- Mechanism without its gate — a table, column, endpoint or timing with no test named. →
  name the test and cut the mechanism.
- Two decisions — the title needs a clause to cover the body. → split, one file each.
- Restates a neighbour — an invariant another ADR, the glossary or CLAUDE.md already holds.
  → point at it.
- Describes unbuilt work — a ruling about a surface that does not exist. → the PRD.
```

The existing title check gets its rule: the decision as one sentence naming the things it
governs; a clause, a negation or an abstract noun in the title is a finding.

### Global `CLAUDE.md`, comments section, one line

```md
A comment cites an ADR by number and by the words of the rule it applies.
```

## Also observed, outside the skills

- The status frontmatter was on every file and read by nothing. Removed; status is whether
  the file is on main.
- Numbers were reused for foundational decisions (0002, 0040) rather than appended, so the
  index reads in order. Old commit messages still mean the old files by those numbers.
- Retired vocabulary as a noun ("mirror") was the reason for three renames; as a verb it is
  fine. The glossary's avoid-lists should say which.
