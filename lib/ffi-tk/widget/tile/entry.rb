module Tk
  module Tile
    class Entry < Tk::Entry
      def self.tk_command; 'ttk::entry'; end
      include TileWidget
    end
  end
end
