module Tk
  module Tile
    class Treeview < Tk::Widget
      def self.tk_command; 'ttk::treeview'; end
      include Tk::Tile::TileWidget
    end
  end
end
