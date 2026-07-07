# frozen_string_literal: true

module Tk
  module Tile
    # Separator widget displays a horizontal or vertical separator bar.
    class Separator < Widget
      def self.tk_command
        'ttk::separator'
      end
      include Configure
      include Cget
      include TileWidget

      # Option schema (ttk::separator WIDGET-SPECIFIC + ttk::widget STANDARD).
      # -orient is horizontal/vertical (:symbol); everything else is standard.
      ttk_options
      widget_options(orient: :symbol)

      # Specifies the orientation of the separator.
      # horizontal or vertical
      def orient(orientation = None)
        if orientation == None
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
