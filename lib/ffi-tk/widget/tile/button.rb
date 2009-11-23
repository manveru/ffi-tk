module Tk
  module Tile
    class Button < Tk::Button
      def self.tk_command; 'ttk::button'; end
      include TileWidget
    end
  end
end
