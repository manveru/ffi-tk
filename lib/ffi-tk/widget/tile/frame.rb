module Tk::Tile
  class Frame < Tk::Frame
    def self.tk_command; 'ttk::frame'; end
    include Tk::Tile::TileWidget

    def initialize(parent = Tk.root, options = {})
      options = { relief: :flat }.merge(options)
      super
    end
  end
end

