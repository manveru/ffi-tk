module Tk::Tile
  class Entry < Tk::Entry
    INITIALIZE_COMMAND = 'ttk::entry'
    include Tk::Tile::TileWidget
  end
end

