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

[x] pack
[x] event
[x] place
[x] clipboard
[x] selection
[x] font
[x] raise
[x] lower
[x] winfo
[ ] grid
[ ] tk
[ ] wm
[ ] option
[x] options
[x] bell
[x] bind
[x] bindtags
[x] destroy
[x] focus
[ ] grab
[ ] image
    [ ] photo
    [ ] bitmap
[ ] loadTk
[ ] send
[ ] tk_bisque
[ ] tk_chooseColor
[ ] tk_chooseDirectory
[ ] tk_dialog
[ ] tk_focusFollowsMouse
[ ] tk_focusNext
[ ] tk_focusPrev
[ ] tk_getOpenFile
[ ] tk_getSaveFile
[ ] tk_menuSetFocus
[ ] tk_messageBox
[ ] tk_optionMenu
[ ] tk_popup
[ ] tk_setPalette
[ ] tk_textCopy
[ ] tk_textCut
[ ] tk_textPaste
[ ] tkerror
[ ] tkvars
[ ] tkwait

## Widgets

The Tile widgets should have priority, as they will be needed most.
Some widgets don't have a tile equivalent, they have highes priority.

[ ] text
[x] entry
[ ] listbox
[ ] frame
[ ] label
[ ] scrollbar
[ ] toplevel
[ ] canvas
[ ] message
[ ] button
[ ] checkbutton
[ ] spinbox
[ ] labelframe
[ ] menu
[ ] menubutton
[ ] panedwindow
[ ] radiobutton
[ ] scale
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