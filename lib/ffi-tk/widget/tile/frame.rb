module Tk::Tile
  # A frame widget is a container,
  # used to group other widgets together.
  class Frame < Tk::Frame
    INITIALIZE_COMMAND = 'ttk::frame'
    include Tk::Tile::TileWidget
  end
end

