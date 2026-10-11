# Spec Standards

A spec states behaviour a user can observe, as specified by the maintainer. It is the source of truth for what the user sees, not a technical specification.

## What earns a line

A sentence belongs in the spec only when both hold:

1. A user would notice if it were different. Anything else is a mechanism, and doesn't belong here.

## Form

- Write each line as a user story, in the surface where the user meets the behaviour.
- A behaviour offered on several surfaces has one home. The other surfaces point to it.
- A behaviour no user starts, such as a sync or a background check, lives in the surface that shows its result.
- An exception to a principle is named as one, in the story it qualifies.
- A diagram draws what moves between which components. Its labels name payloads, never steps.

## Stable citations

Code and tickets cite stories by number. Append a new story to the end of its list, so every existing citation still points at the same story.
