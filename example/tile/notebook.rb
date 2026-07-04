#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative '../../lib/ffi-tk'

Tk.init

# create notebook widget
nb = Tk::Tile::Notebook.new

text = Tk::Text.new(nb)
text.value = 'text..'

# create labelframe
@labelframe = Tk::Tile::LabelFrame.new(nb, text: 'label headline').pack

# create buttons inside labelframe
Tk::Button.new(@labelframe, text: 'Jump Tab') do
  nb.select text
  text.value = 'current tab options: ' + nb.tab(text).inspect
end.pack

add_button = Tk::Button.new(@labelframe, text: 'Add Tab') do
  t = Tk::Text.new(nb)
  nb.add(t, text: 'new tab')
  nb.select t

  t.value = 'current tab options: ' + nb.tab(t).inspect

  add_button.configure state: :disabled
end.pack

Tk::Button.new(@labelframe, text: 'Close Example') do
  Tk.exit
end.pack

# attach labelframe and Tk::Text to notebook widget
nb.add(@labelframe, text: 'labelframe tab')
nb.insert(0, text, text: 'text tab')

# select labelframe tab
nb.select @labelframe
nb.pack

Tk.mainloop
