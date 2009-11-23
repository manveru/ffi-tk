module Tk
  module Tile
    class MenuButton < Tk::MenuButton
      def self.tk_command; 'ttk::menubutton'; end
      include TileWidget
    end
  end
end
