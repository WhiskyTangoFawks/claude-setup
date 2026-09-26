# CONTEXT.md Format

## Structure

```md
{One or two sentence description of what this context is and why it exists.}

# Order
A stack of items that resolve conflicts by override. Mod order and plugin order are its two kinds.
Avoid: priority

## Mod order
The order of mods, held in `modlist.txt`. It resolves files.
Avoid: mod priority, mod load order

## Plugin order
The order of plugins, held in `plugins.txt`. It resolves records.
Avoid: plugin load order

# Invoice
A request for payment sent to a customer after delivery.
Avoid: bill, payment request
```

Two heading levels. `#` is a term. `##` is a kind of the `#` term above it, and its definition starts with that term: a [parent] that [difference]. Where the language allows, a kind's heading also contains its parent's name (Mod order, Patch plugin, File conflict). A `##` needs a parent that is itself a term in the file. A term with two parents stays a `#`, and its definition names both. The heading is the canonical spelling of the term, so `grep -E '^#+ Term$'` finds it. Plain text before the first heading says what the file is.

## Rules

- The body of a term is its definition, wrapped at 100 columns, then an optional `Avoid:` line. One blank line between terms. No bold.
- Related terms sit next to each other, and a term is defined before it is used. Adjacency is the only clustering.
- Be opinionated. When multiple words exist for the same concept, pick the best one and list the others on the `Avoid:` line.
- Keep definitions tight. One or two sentences max. Define what it IS, not what it does. A rule that code, a test or an ADR states stays there.
- A term earns an entry only if a model trained on general text would misjudge it: a domain word it knows only loosely, an ambiguity trap, or a project coinage on a generic word. General programming concepts and architecture names do not belong. A coinage on a generic word is a smell: rename it, or make it a command.
- A kind gets its own heading when it has its own `Avoid:` words or facts beyond one clause. A kind that is only a state of its parent stays a sentence in the parent.
- `Avoid:` lists words someone still says. When a word has a legitimate use elsewhere, scope it in brackets: `Avoid: patch (a kind of plugin)`.

## Single vs multi-context repos

**Single context (most repos):** One `CONTEXT.md` at the repo root.

**Multiple contexts:** A `CONTEXT-MAP.md` at the repo root lists the contexts, where they live, and how they relate to each other:

```md
# Context Map

## Contexts

- [Ordering](./src/ordering/CONTEXT.md) — receives and tracks customer orders
- [Billing](./src/billing/CONTEXT.md) — generates invoices and processes payments
- [Fulfillment](./src/fulfillment/CONTEXT.md) — manages warehouse picking and shipping

## Relationships

- **Ordering → Fulfillment**: Ordering emits `OrderPlaced` events; Fulfillment consumes them to start picking
- **Fulfillment → Billing**: Fulfillment emits `ShipmentDispatched` events; Billing consumes them to generate invoices
- **Ordering ↔ Billing**: Shared types for `CustomerId` and `Money`
```

The skill infers which structure applies:

- If `CONTEXT-MAP.md` exists, read it to find contexts
- If only a root `CONTEXT.md` exists, single context
- If neither exists, create a root `CONTEXT.md` lazily when the first term is resolved

When multiple contexts exist, infer which one the current topic relates to. If unclear, ask.
