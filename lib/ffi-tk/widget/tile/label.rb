module Tk::Tile
  class Label < Tk::Label
    def self.tk_command; 'ttk::label'; end
    include Tk::Tile::TileWidget
  end
end

