# frozen_string_literal: true
module Tk
  module Tile
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
