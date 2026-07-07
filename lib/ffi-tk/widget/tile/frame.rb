# frozen_string_literal: true

module Tk
  module Tile
    # A themed container widget.
    # Wraps Tk's `ttk::frame`.
    class Frame < Tk::Frame
      def self.tk_command
        'ttk::frame'
      end
      include TileWidget

      # Option schema (ttk::frame WIDGET-SPECIFIC + ttk::widget STANDARD). The
      # themed frame lacks the classic -colormap/-container/-visual and reports
      # -borderwidth/-width/-height as raw screen-distance strings (:string);
      # -padding is a list of distances (:list). Declared here, not inherited
      # from Tk::Frame, because the Tk command differs (ttk::frame vs frame).
      ttk_options
      widget_options(
        borderwidth: :string,
        height: :string,
        padding: :list,
        relief: :symbol,
        width: :string
      )

      def initialize(parent = Tk.root, options = {})
        options = { relief: :flat }.merge(options)
        super
      end
    end
  end
end
