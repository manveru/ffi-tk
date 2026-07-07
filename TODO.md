# Todo List

Things left to do, most of this is simple, but still a lot of code.
Items are ordered roughly by their priority.
Done items should be removed after a couple of revisions.

An item is marked as done when:
  * the code is complete.
  * specs are written for all things possible to spec.
  * the documentation has been sketched. I simply copy that part from the
    offical doc first, but since we're not clear about copyright we might have
    to use links and examples instead.

## Commands

Commands that operate on any widget as argument have highest priority.

[ ] image
    [ ] photo
    [ ] bitmap
[ ] loadTk
[ ] send
[ ] tk_bisque

## Widgets

The Tile widgets should have priority, as they will be needed most.
Some widgets don't have a tile equivalent, they have highes priority.

[ ] console

### Tile Widgets

[ ] ttk::style
[ ] ttk::frame
[ ] ttk::entry
[ ] ttk::label
[ ] ttk::treeview
[ ] ttk::progressbar
[ ] ttk::button
[ ] ttk::checkbutton
[ ] ttk::combobox
[ ] ttk::image
[ ] ttk::intro
[ ] ttk::labelframe
[ ] ttk::menubutton
[ ] ttk::notebook
[ ] ttk::panedwindow
[ ] ttk::radiobutton
[ ] ttk::scale
[ ] ttk::scrollbar
[ ] ttk::separator
[ ] ttk::sizegrip
[ ] ttk::widget

## Examples

There are a lot of examples that we can provide, both from the old Ruby bindings
and the Tk library.
They will have to be translated though, so it's still a lot of work.
Our current examples should be removed sometime, they are more or less just
proving that things run.

### Known-broken examples (not caused by the option-typing work)

[ ] example/tile/kroc_rb_demo.rb — incomplete fragment (marked "not ready,
    needs photoimage and load_images"). Calls `Tk::Tile::Style.theme_create`
    at top level with no `require '../../lib/ffi-tk'` and no `Tk.init`, so it
    dies with `uninitialized constant Tk`. Needs photo-image / `load_images`
    support before it can run at all.
[ ] example/tkgo.rb — requires the external `gnugo` engine on PATH; fails with
    `Errno::ENOENT (No such file or directory - gnugo)`. ffi-tk itself loads
    fine. Either document the dependency or guard for a missing engine.
