#!/usr/bin/env ruby

require_relative '../../lib/ffi-tk'

Tk.init


Tk::Tile::Style.theme_settings 'alt' do
  Tk::Tile::Style.configure '.', background: 'red'
  Tk::Tile::Style.configure 'test.label', background: 'blue'

  Tk::Tile::Style.map('.', :background=>[:active, '#694418'])
end


button1 = Tk::Tile::Button.new('.', text: 'Hello, World!', width: 100) do
  button1.destroy
  Tk.exit
end

button2 = Tk::Tile::Button.new(button1, text: 'Wien!', width: 50) do
  Tk::Tile::Style.map('.', :background=>[:active, '#FFFFFF'])
  button2.destroy
end

#button3 = Tk::Tile::Button.new(button1, text: 'apply theme', style: 'test.label' ) do
button3 = Tk::Tile::Button.new('.', text: 'apply theme' ) do
  Tk::Tile::Style.theme_use 'alt'
  button3.destroy
end
#button3.style 'test.label'


button1.pack
button2.pack
button3.pack

Tk.mainloop
