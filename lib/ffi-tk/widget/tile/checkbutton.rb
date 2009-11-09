module Tk::Tile
  class CheckButton < Tk::CheckButton
    def self.tk_command; 'ttk::checkbutton'; end
    include Tk::Tile::TileWidget
  end
end

