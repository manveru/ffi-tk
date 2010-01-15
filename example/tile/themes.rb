require 'ffi-tk'

Tk::Tile::Style.theme_names.each do |name|
  button = Tk::Tile::Button.new(
    text: name,
    command: ->{ Tk::Tile.set_theme(name) })
  button.pack side: :top, anchor: :nw
end

button = Tk::Tile::Button.new(text: 'Exit', command: ->{ Tk.exit })
button.pack side: :top, anchor: :nw

Tk.mainloop
