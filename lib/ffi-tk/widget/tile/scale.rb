module Tk::Tile
  class Scale < Tk::Scale
    def self.tk_command; 'ttk::scale'; end
    include Tk::Tile::TileWidget
  end
end

