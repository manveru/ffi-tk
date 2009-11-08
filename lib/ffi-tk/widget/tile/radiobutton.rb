module Tk::Tile
  class RadioButton < Tk::RadioButton
    INITIALIZE_COMMAND = 'ttk::radiobutton'
    include Tk::Tile::TileWidget
  end
end

