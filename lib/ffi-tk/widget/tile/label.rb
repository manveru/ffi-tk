# frozen_string_literal: true

module Tk
  module Tile
    # A themed display for text or an image.
    # Wraps Tk's `ttk::label`.
    class Label < Tk::Label
      def self.tk_command
        'ttk::label'
      end
      include TileWidget

      # Option schema (ttk::label WIDGET-SPECIFIC + ttk::widget STANDARD/LABEL/
      # COMPATIBILITY). -borderwidth/-wraplength are screen distances (:string);
      # -width is a character count (:integer); -state is the compatibility
      # normal/disabled keyword (:symbol).
      ttk_options
      widget_options(
        anchor: :symbol,
        background: :color,
        borderwidth: :string,
        compound: :symbol,
        font: :font,
        foreground: :color,
        image: :string,
        justify: :symbol,
        padding: :list,
        relief: :symbol,
        state: :symbol,
        text: :string,
        textvariable: :variable,
        underline: :integer,
        width: :integer,
        wraplength: :string
      )
    end
  end
end
