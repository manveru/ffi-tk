module Tk::Tile
  class Entry < Tk::Entry
    def self.tk_command; 'ttk::entry'; end
    include Tk::Tile::TileWidget
  end
end

