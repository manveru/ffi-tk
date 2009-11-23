module Tk
  module Tile
    class PanedWindow < Tk::PanedWindow
      def self.tk_command; 'ttk::panedwindow'; end
      include TileWidget
    end
  end
end

