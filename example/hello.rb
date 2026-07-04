#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative '../lib/ffi-tk'

Tk.init

Tk::Button.new('.', text: 'Hello, World!') do
  Tk.exit
end.pack

Tk.mainloop
