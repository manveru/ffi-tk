module Tk::Tile
  class Frame < Tk::Frame
    INITIALIZE_COMMAND = 'ttk::frame'
    include Tk::Tile::TileWidget

    def initialize(parent = Tk.root, options = {})
      options = { relief: :flat }.merge(options)
      super
    end
  end
end

