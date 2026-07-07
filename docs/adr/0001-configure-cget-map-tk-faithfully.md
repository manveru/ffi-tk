# `cget` and `configure` map Tk faithfully; no presumed convenience

ffi-tk is a binding, not an application, so we map Tk's `cget`/`configure`
semantics 1:1 rather than reshaping them for a caller we cannot predict.
`cget(:x)` returns the option's value; `configure(:x)` returns the full Option
description (value **plus** default and resource-database name/class), and
`configure` (no arg) returns those descriptions for every option. The library's
only value-add over raw Tk is Coercion (Tcl string → typed Ruby value) applied
to the `value` and `default` fields — everything else Tk reports is preserved.

## Context

The original (c. 2009) `configure` was "clever": for a single-option query it
discarded Tk's describe-tuple and returned only the current value, making
`configure(:x)` a lossy near-duplicate of `cget(:x)` and hiding defaults, the
resource-database metadata, and synonym (alias) information Tk exposes.

## Considered options

- **Keep `cget` as the sole reader** and forward `configure(:x)` to it, dropping
  the describe richness. Minimal, but presumes no consumer will ever want a
  default or need to detect an alias — a guess a binding shouldn't make.
- **Faithful 1:1 (chosen).** Return the describe data as a typed
  `OptionDescription`; let consumers add whatever convenience they want on top.

## Consequences

- `configure` (no arg) returns `Hash{name => OptionDescription}` — Tk's
  list-of-tuples rendered as the keyed collection it always was (Tcl only had
  lists at the time; dicts arrived in 8.5).
- The `size == 5` describe-tuple extraction heuristic is removed in favour of
  explicit parsing.
- Specs that asserted a bare value back from `configure(:x)` are updated to read
  `.value`; a handful of in-repo call sites that treated `configure`'s hash as
  `{name => value}` now read `.value`.
