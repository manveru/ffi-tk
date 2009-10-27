#!/usr/bin/env ruby

require_relative '../lib/ffi-tk'

Tk.init

Tk::Button.new('.', text: 'Hello, World!').pack

Tk.mainloop