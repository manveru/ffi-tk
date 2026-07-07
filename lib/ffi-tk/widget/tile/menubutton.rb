# frozen_string_literal: true

module Tk
  module Tile
    # A themed button that posts a menu.
    # Wraps Tk's `ttk::menubutton`.
    class MenuButton < Tk::MenuButton
      def self.tk_command
        'ttk::menubutton'
      end
      include TileWidget

      # Option schema (ttk::menubutton WIDGET-SPECIFIC + ttk::widget STANDARD/
      # LABEL/COMPATIBILITY). -menu names a menu widget (:pathname); -direction
      # is above/below/left/right/flush (:symbol).
      ttk_options
      widget_options(
        compound: :symbol,
        direction: :symbol,
        image: :string,
        menu: :pathname,
        padding: :list,
        state: :symbol,
        text: :string,
        textvariable: :variable,
        underline: :integer,
        width: :integer
      )
    end
  end
end
