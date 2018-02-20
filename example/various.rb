#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative '../lib/ffi-tk'

Tk.init

Tk.root.bind('Control-c') { |event| p event }
Tk.root.bind('Control-q') { |_event| exit }

hello = Tk::Button.new('.', text: 'Push me') do
  Tk.message_box(message: 'Hello, World!')
end.pack

button = Tk::Button.new('.', text: 'Destroy me!').pack
button.bind('Enter') { |_event| button.destroy }

text = Tk::Text.new('.')
text.insert 'insert', 'Hello, World!'
text.pack expand: true, fill: :both

entry = Tk::Entry.new('.')
entry.insert 'end', 'Hello, World!'
entry.pack fill: :x

Tk.mainloop
