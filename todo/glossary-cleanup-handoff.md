# Handoff: what cleaning up CONTEXT.md taught, and what to change in the skills

Written after the glossary sitting under #753. Two files and a context map, 268 plus 143 lines
of entries, became one file of 300 lines and 54 terms. This records the bloat patterns found,
their root causes, and the changes proposed on the generation side (`/domain-modeling`) and the
review side (`/standards-docs`). Nothing is applied; the skills are the maintainer's.

## The bloat, and where it came from

1. **Mechanism in the definition.** The Source entry was twenty lines of file layout; Header
   record was fourteen lines of column and class names; the record index entry named DuckDB and
   `json_extract`. Root cause: `/domain-modeling` says "update CONTEXT.md inline, the moment a
   term crystallises", and a term crystallises while the agent is implementing it, so the
   definition captured the implementation. The format's "define what it IS, not what it does"
   was one line among the rules and never a step.
2. **Behaviour in the definition.** Dangling FormLink said when creation is refused; Save &
   Compile said what compile derives and refuses; Repair said when it runs. These are the
   surface's or the ADR's sentences, copied because the entry was written in the same session
   as the rule.
3. **Priors redefined.** FormID, FormKey, EditorID, Master, Override, ITM, VMAD, Condition,
   Plugin, Mod, Profile, Separator: twenty entries a model already holds from modding and
   Mutagen, each given a full definition and a trivial avoid-list. Root cause: the format's rule
   is "only terms specific to this project", and an agent reads a Bethesda term as specific to
   the project because the project is about Bethesda. The test it needed was "would a model
   already know this word, and does the project rule on it against that meaning?"
4. **Leading words spelled out.** "An edit not yet committed: ordinary git dirt" for git's
   uncommitted change; "a gesture that writes a system of record and returns; the change comes
   back by watching" for a CQRS command; a full definition of Wabbajack's Stock Game. Each is a
   word the model has, restated in a sentence.
5. **Retired and unbuilt terms kept as entries.** Session (retired), Drift (retired), Anchor
   (deferred, nothing computes one), Script and Agent (designed, not built), ConflictPriority
   (a table that does not exist). Root cause: the glossary was the only place a retired word
   could be recorded as retired, so the entry stayed to carry its own avoid-list.
6. **False values surviving.** ConflictAll and ConflictThis listed `ConflictBenign` and
   `Ignored`, values removed with the priority table. Root cause: nothing cross-references a
   glossary entry's value list with the enum.
7. **One concept, two entries.** Partial Form and PartialForm; Filter file and Record filter;
   Resolution stack and Override order; Download, Download status and Hidden; Dangling and
   Type-mismatched FormLink as two entries for FormLink's two error states. Root cause: entries
   were added at different sittings by different agents, and nothing asked "is this a qualifier
   of an existing term?"
8. **Two glossaries for one vocabulary.** The bounded-context split put Upgrade in both files
   and Anchor and Provenance on opposite sides as one concept with two names. Every collision the
   split existed to prevent had already been resolved by qualifying the term (Plugin load order,
   Mod override order, record index, file conflict index), which made the file boundary carry
   nothing. Root cause: the skill prescribes a glossary per context and the map, and the
   prescription was followed past the point where the words carried the boundary themselves.

## Generation side: `/domain-modeling`

Positive guidance, phrased as what to do.

- **A term is a definition and a ruling.** Every entry answers two questions: what is it, and
  what did the project decide about the word. An entry with only the first is a prior; an entry
  with only the second is an avoid-list on another term. The word for this is *ruling*.
- **Leading words first.** Before writing a definition, name the pretrained concept the term is
  an instance of and lean on it: "Git's uncommitted change", "a CQRS command", "MO2's separator",
  "Wabbajack's Stock Game". The definition then carries only what the project adds. The word is
  *lean*.
- **Qualifiers over entries.** A state, an error kind or an axis of an existing term is a bold
  qualifier inside that term's entry, not an entry of its own. FormLink has dangling and
  type-mismatched; Download has status and hidden. The test: does the new word make sense
  without the existing one?
- **Retired words are avoid-list entries.** A retired term goes on the avoid-list of the term
  that replaced it, and its own entry goes. The commit message carries the retirement.
- **Unbuilt concepts have no entry.** Vocabulary for work not yet built lives with the PRD; the
  glossary describes the product.
- **Cross-reference the code before adding a term**, as the skill already says for challenging
  the user's terms. A value list is checked against its enum; a mechanism word is checked against
  whether the thing exists.
- **One glossary, sections by use.** A repo with two bounded contexts gets one glossary whose
  introduction states the language boundary as a rule, and whose colliding terms are qualified.
  The map is that introduction. See the trace-based vocabulary proposal in the companion
  handoff for the section structure.

## Review side: `/standards-docs`, CONTEXT.md section of the checklist

Entries to add, each a named anti-pattern with its fix, since a checklist runs on a diff:

```md
- Prior redefined — a term any model already holds, given a full definition. → cut, or keep
  only the project's ruling on the word.
- Leading word spelled out — a pretrained concept restated as a sentence. → name the concept
  and keep only what the project adds.
- Qualifier as entry — a state, error kind or axis of an existing term with its own entry. →
  a bold qualifier inside the parent term.
- Retired term as entry — an entry whose definition says the concept no longer exists. → the
  replacing term's avoid-list.
- Unbuilt term — an entry marked designed, planned or deferred. → the PRD.
- Value list drift — an enumerated list of values the code no longer has. → check the enum.
```

And a size cue for the reviewer, as with ADRs: an entry is one or two sentences; a third
sentence is behaviour or mechanism until proven otherwise.

## Also observed

- `/domain-modeling` infers "single context" when only a root CONTEXT.md exists. With the map
  gone, this repo reads as single-context to the skill while its glossary says two. The skill's
  multi-context rule is the thing to revise, not the glossary.
- The avoid-lists carried the retired-noun rule for "mirror" implicitly. Where a word is retired
  as a noun and fine as a verb, the avoid-list should say so.
- Sections by bounded context were the disclosure unit, and an agent reads a file whole unless
  told otherwise. Disclosure that happens needs file boundaries; see the companion handoff.
