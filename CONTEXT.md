# Context: ffi-tk

A Ruby FFI binding to Tcl/Tk. The gem is a translation layer: Ruby values go
*out* as Tcl command strings, and Tcl results come *back* as Ruby values.

## Glossary

### Option
A named configuration setting on a widget, written `-name` in Tcl (e.g.
`-background`, `-state`).

`cget` and `configure` map Tk 1:1 and do **not** overlap:
- `cget(:x)` → the option's **value** (Tk `cget -x`).
- `configure(:x)` → the option's **Option description** (Tk `configure -x`).
- `configure` (no arg) → the Option descriptions of **all** options.
- `configure(x: v, …)` → **sets** options.

They share only the Option schema and Coercion; neither is implemented in terms
of the other.

### Option description
The faithful representation of what Tk's `configure` reports for one option: its
current value plus its default and its resource-database name and class
(`{-x dbName dbClass default current}`). For a synonym option Tk reports a
2-element form naming the canonical option instead; that alias-ness is preserved,
not collapsed. The library does not reshape this into a bare value — that
"convenience" is left to consumers.

### Option type
The *logical* type of an option's value — one of a small closed vocabulary
(`:boolean`, `:symbol`, `:integer`, `:float`, `:color`, `:font`, `:command`,
`:variable`, `:bitmap`, `:list`, `:pathname`, `:string`). Determines how a raw
Tcl value is coerced to Ruby. Tk does **not** expose this at the script level;
it must be declared. Not to be confused with a Tcl object's *internal* type
(what `EvalResult.guess` dispatches on), which is unreliable for this purpose
because of shimmering.

### Coercion
Converting a raw Tcl option value to its Ruby form according to the option's
Option type (e.g. `:boolean` → `true`/`false` via `Tcl_GetBoolean`). It reads
the option's raw string (never `EvalResult.guess`), so it is immune to Tcl
shimmering. It raises a named error for an option with no declared type.

Empty-value rule: an empty result is coerced to the *empty instance of the
type* when the type has one — `:string` → `""`, `:list` → `[]` — and to `nil`
otherwise (`:integer`, `:float`, `:symbol`, `:boolean`, `:color`, `:font`,
`:bitmap`, `:command`, `:variable`, `:pathname`). `nil` therefore always means
"absent / no value / no object bound", never a flattened empty string. Coercion
never manufactures `nil` from a value that a type can legitimately hold empty.

### Option schema
The mapping from an Option name to its Option type, *for a specific widget*.
The authoritative source of coercion for that widget. A widget's schema is
composed from a shared Standard-options schema plus its Widget-specific options.
Composition is **explicit** (a widget opts in), never derived from the Ruby
class hierarchy — because the Ruby hierarchy (e.g. `Tile::Entry < Tk::Entry`)
does not mirror Tk's actual option sets: ttk widgets lack classic options like
`-relief`/`-bg` and add `-style`, so a schema inherited from the classic
superclass would claim options the themed widget does not have.

### Standard options
The cross-widget option set Tk documents as "STANDARD OPTIONS" (colors,
`borderwidth`, `font`, `justify`, `orient`, `cursor`, …). These do **not**
collide by name across widgets, so their Option types are shared. Classic and
themed (ttk) widgets have *different* standard sets.

### Alias (synonym)
An Option name Tk treats as a synonym for a canonical Option (`-bg` for
`-background`, `-fg` for `-foreground`, `-bd` for `-borderwidth`, entry's
`-vcmd` for `-validatecommand`, …). In an Option schema an alias carries **no
type of its own** — it is a pointer to its canonical Option, which owns the one
Option type. `cget` on an alias follows it to the canonical value; `configure`
on an alias returns a synonym-form Option description naming the canonical, and
`configure` (no arg) lists both the alias and the canonical, faithful to Tk.

### Widget-specific options
Options Tk documents per widget ("WIDGET-SPECIFIC OPTIONS"), e.g. `state`,
`wrap`, `value`, `default`. This is where Option-type collisions live (a
spinbox `-wrap` is a `:boolean`, a text `-wrap` is a `:symbol`), so these types
are declared on the widget, not shared.
