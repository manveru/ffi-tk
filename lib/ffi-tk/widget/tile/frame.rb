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

      def initialize(parent = Tk.root, options = {})
        options = { relief: :flat }.merge(options)
        super
      end
    end
  end
end
