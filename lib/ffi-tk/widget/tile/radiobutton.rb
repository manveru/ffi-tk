# frozen_string_literal: true

module Tk
  module Tile
    # A themed mutually-exclusive choice button.
    # Wraps Tk's `ttk::radiobutton`.
    class RadioButton < Tk::RadioButton
      def self.tk_command
        'ttk::radiobutton'
      end
      include TileWidget

      # Option schema (ttk::radiobutton WIDGET-SPECIFIC + ttk::widget STANDARD/
      # LABEL/COMPATIBILITY). -value may be any string (:string).
      ttk_options
      widget_options(
        command: :command,
        compound: :symbol,
        image: :string,
        padding: :list,
        state: :symbol,
        text: :string,
        textvariable: :variable,
        underline: :integer,
        value: :string,
        variable: :variable,
        width: :integer
      )
    end
  end
end
