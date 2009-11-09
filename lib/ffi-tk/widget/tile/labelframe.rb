module Tk::Tile
  class LabelFrame < Tk::LabelFrame
    def self.tk_command; 'ttk::labelframe'; end
    include Tk::Tile::TileWidget
  end
end

