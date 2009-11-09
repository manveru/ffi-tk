module Tk::Tile
  class RadioButton < Tk::RadioButton
    def self.tk_command; 'ttk::radiobutton'; end
    include Tk::Tile::TileWidget
  end
end

