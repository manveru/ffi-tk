module Tk
  module Tile
    class Scale < Tk::Scale
      def self.tk_command; 'ttk::scale'; end
      include TileWidget
    end
  end
end
