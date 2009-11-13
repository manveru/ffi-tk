module Tk::Tile
  class Scrollbar < Tk::Scrollbar
    def self.tk_command; 'ttk::scrollbar'; end
    include Tk::Tile::TileWidget

    def initialize(parent = Tk.root, options = {})
      super
      scrollbar_default
    end

    def scrollbar_default; end
  end

  class YScrollbar < Tk::Tile::Scrollbar
    def scrollbar_default
      #configure :orient => :vertical
    end
  end

  class XScrollbar < Tk::Tile::Scrollbar
    def scrollbar_default
      configure :orient => :horizontal
    end
  end
end

