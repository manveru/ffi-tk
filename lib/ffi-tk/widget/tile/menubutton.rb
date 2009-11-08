module Tk::Tile
  class MenuButton < Tk::MenuButton
    INITIALIZE_COMMAND = 'ttk::menubutton'
    include Tk::Tile::TileWidget
  end
end

