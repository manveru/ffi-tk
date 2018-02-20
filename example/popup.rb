# frozen_string_literal: true
require 'ffi-tk'
Tk.init

command = -> { Tk::Bell.bell }
menu = Tk::Menu.new(Tk.root)
menu.add(:command, label: 'Example 1', command: command)
menu.add(:command, label: 'Example 2', command: command)
label = Tk::Label.new(Tk.root, text: 'Click me!').pack
label.bind('<1>') { |event| Tk.popup(menu, event.x, event.y) }

Tk::Button.new(Tk.root, text: 'Exit') { exit }.pack

Tk.mainloop
__END__
# Create a menu
set m [menu .popupMenu]
$m add command -label "Example 1" -command bell
$m add command -label "Example 2" -command bell

# Create something to attach it to
pack [label .l -text "Click me!"]

# Arrange for the menu to pop up when the label is clicked
bind .l <1> {tk_popup .popupMenu %X %Y}