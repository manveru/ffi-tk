module Tk::Tile
  class MenuButton < Tk::MenuButton
    def self.tk_command; 'ttk::menubutton'; end
    include Tk::Tile::TileWidget
  end
end

