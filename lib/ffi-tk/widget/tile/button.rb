module Tk::Tile
  class Button < Tk::Button
    INITIALIZE_COMMAND = 'ttk::button'
    include Tk::Tile::TileWidget
  end
end

