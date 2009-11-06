module Tk::Tile
  # A frame widget is a container,
  # used to group other widgets together.
  class Frame < Tk::Frame
    include Tk::Tile::TileWidget

    def initialize(parent, options = {}, &block)
      options = { relief: 'flat' }.merge(options)
      init_ttk_widget(parent, options, block, 'ttk::frame')
    end
  end
end

