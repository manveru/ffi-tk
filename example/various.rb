#!/usr/bin/env ruby

require_relative '../lib/ffi-tk'

Tk.init

Tk::Event.register_in_tk('.', 'Control-c'){|event| p event }
Tk::Event.register_in_tk('.', 'Control-q'){|event| exit }

hello = Tk::Button.new('.', text: 'Push me'){
  Tk::MessageBox.new(message: 'Hello, World!')
}
hello.pack

button = Tk::Button.new('.', text: 'Destroy me!').pack
button.bind('Enter'){|event| button.destroy }

text = Tk::Text.new('.')
text.insert 'insert', 'Hello, World!'
text.pack expand: true, fill: :both

entry = Tk::Entry.new('.')
entry.insert 'end', 'Hello, World!'
entry.pack fill: :x

Tk.mainloop