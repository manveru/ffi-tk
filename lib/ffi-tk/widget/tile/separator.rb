module Tk::Tile
  # Separator widget displays a horizontal or vertical separator bar.
  class Separator < Tk::Widget
    def self.tk_command; 'ttk::separator'; end
    include Tk::Tile::TileWidget
    include Tk::Cget, Tk::Configure

    # Specifies the orientation of the separator.
    # horizontal or vertical
    def orient(orientation = Tk::None)
      if Tk::None == orientation
        cget(:orient)
      else
        configure orient: orientation
      end
    end

    def identify(x, y)
      execute_only(:identify, x, y)
    end

  end
end

