module Tk
  module Tile
    # Separator widget displays a horizontal or vertical separator bar.
    class Separator < Widget
      def self.tk_command; 'ttk::separator'; end
      include TileWidget, Cget, Configure

      # Specifies the orientation of the separator.
      # horizontal or vertical
      def orient(orientation = None)
        if None == orientation
          cget(:orient)
        else
          configure orient: orientation
        end
      end

      def identify(x, y)
        execute_only(:identify, x, y)
      end
    end
  end
end
