# frozen_string_literal: true
require 'ffi-tk'

Tk.init

variable = Tk::Variable.new('showstopper', false)
label = Tk::Label.new(Tk.root, text: 'enter anything to reflect it here').pack

entry = Tk::Entry.new(Tk.root, textvariable: variable).pack
button = Tk::Button.new(Tk.root, text: 'Exit') { exit }.pack

loop do
  Tk::Wait.variable(variable)
  label.configure text: variable.to_s
end

Tk.mainloop
