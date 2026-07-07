# frozen_string_literal: true

module Tk
  module Tile
    # A themed push button.
    # Wraps Tk's `ttk::button`.
    class Button < Tk::Button
      def self.tk_command
        'ttk::button'
      end
      include TileWidget

      # Option schema (ttk::button WIDGET-SPECIFIC + ttk::widget STANDARD/LABEL/
      # COMPATIBILITY). -default is normal/active/disabled (:symbol); -width is a
      # character count (:integer, empty when unset); -state is the compatibility
      # keyword (:symbol).
      ttk_options
      widget_options(
        command: :command,
        compound: :symbol,
        default: :symbol,
        image: :string,
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
