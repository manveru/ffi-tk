module Tk::Tile
  class PanedWindow < Tk::PanedWindow
    def self.tk_command; 'ttk::panedwindow'; end
    include Tk::Tile::TileWidget
  end
end

