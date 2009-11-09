module Tk::Tile
  class Button < Tk::Button
    def self.tk_command; 'ttk::button'; end
    include Tk::Tile::TileWidget
  end
end

