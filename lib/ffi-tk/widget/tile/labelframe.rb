# frozen_string_literal: true

module Tk
  module Tile
    # A themed titled container.
    # Wraps Tk's `ttk::labelframe`.
    class LabelFrame < Tk::LabelFrame
      def self.tk_command
        'ttk::labelframe'
      end
      include TileWidget

      # Option schema (ttk::labelframe WIDGET-SPECIFIC + ttk::widget STANDARD).
      # -labelwidget names a widget used as the label (:pathname); -labelanchor
      # places it (:symbol). -borderwidth/-width/-height are screen distances
      # reported verbatim (:string); -padding is a distance list (:list).
      ttk_options
      widget_options(
        borderwidth: :string,
        height: :string,
        labelanchor: :symbol,
        labelwidget: :pathname,
        padding: :list,
        relief: :symbol,
        text: :string,
        underline: :integer,
        width: :string
      )
    end
  end
end
