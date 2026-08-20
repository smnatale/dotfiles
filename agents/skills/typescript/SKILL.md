---
name: typescript
description: States the user's general TypeScript preferences - type safety defaults, export/naming conventions, and React prop typing. Use when writing or reviewing any .ts or .tsx file.
---

# TypeScript

General preferences for any TypeScript codebase. Repo-specific or lint-enforced rules belong in that repo's own CLAUDE.md, not here - this skill only covers taste that should hold everywhere.

| Rule | Summary |
|------|---------|
| No `any` | Prefer `unknown` and narrow, or a precise type. `any` opts out of the type checker; treat it as always fixable. |
| Illegal states unrepresentable | Model variants with a discriminated union (`kind`/`type` literal tag), not optional-field bags or scattered booleans. |
| Readonly by default | Default to `readonly` on object properties, arrays (`readonly T[]`), and parameters. Drop it only where mutation is genuinely intended. |
| Explicit return types on exports | Annotate the return type of exported/public functions. Let TypeScript infer everything internal. |
| No non-null assertions | Avoid `!`. Narrow or use optional chaining instead. If truly unavoidable, add a one-line justification comment. |
| Literal unions over enums | Default to a string-literal union, plus a `satisfies`-checked const object when you need iteration or lookup. Use a TS `enum` only when the surrounding codebase already uses enums. |
| Derive, don't duplicate | Build related types from one canonical source with `Pick`/`Omit`/`Partial`, etc., instead of hand-copying a shape. |
| Named exports only | Never `export default`. Named exports survive renames and refactors without silently changing the import name. |
| Validate at the boundary | Parse and validate external data (API responses, user input) where it enters the system. Use whatever the repo already has for this; state the principle, don't mandate a library. |
| Barrel files stay small | Fine at a real public package boundary. A barrel absorbing unrelated re-exports is a smell, not a pattern to keep growing. |
| Colocate types | Keep a type next to the code that uses it. Promote it to a shared file only once a second, unrelated file needs it. |
| Boolean naming | Prefix booleans with `is`/`has`/`should`/`can`/`did`/`will`/`was`. |

## React

Type props as a plain parameter annotated with a `Props` type (`function Button(props: ButtonProps)`), not `React.FC`/`React.FunctionComponent` - those implicitly type `children` on every component and complicate generics. Type `children` explicitly as `ReactNode` only on components that actually accept it.
