module Tk::Tile
  class CheckButton < Tk::CheckButton
    INITIALIZE_COMMAND = 'ttk::checkbutton'
    include Tk::Tile::TileWidget
  end
end

