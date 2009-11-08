#!/usr/bin/env ruby

require_relative '../lib/ffi-tk'

Tk.init

Tk::Button.new('.', text: 'Hello, World!') do
  Tk.exit
end.pack

Tk.mainloop