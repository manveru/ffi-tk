module Tk::Tile
  class LabelFrame < Tk::LabelFrame
    INITIALIZE_COMMAND = 'ttk::labelframe'
    include Tk::Tile::TileWidget
  end
end

