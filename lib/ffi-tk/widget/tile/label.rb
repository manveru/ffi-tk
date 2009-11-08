module Tk::Tile
  class Label < Tk::Label
    INITIALIZE_COMMAND = 'ttk::label'
    include Tk::Tile::TileWidget
  end
end

