# frozen_string_literal: true

module Tk
  module Tile
    # A themed on/off toggle with a label.
    # Wraps Tk's `ttk::checkbutton`.
    class CheckButton < Tk::CheckButton
      def self.tk_command
        'ttk::checkbutton'
      end
      include TileWidget

      # Option schema (ttk::checkbutton WIDGET-SPECIFIC + ttk::widget STANDARD/
      # LABEL/COMPATIBILITY). -onvalue/-offvalue may be any string (:string).
      ttk_options
      widget_options(
        command: :command,
        compound: :symbol,
        image: :string,
        offvalue: :string,
        onvalue: :string,
        padding: :list,
        state: :symbol,
        text: :string,
        textvariable: :variable,
        underline: :integer,
        variable: :variable,
        width: :integer
      )
    end
  end
end
