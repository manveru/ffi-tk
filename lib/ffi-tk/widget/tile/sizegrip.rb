module Tk
  module Tile
    class Sizegrip < Tk::Widget
      def self.tk_command; 'ttk::sizegrip'; end
      include TileWidget, Cget, Configure

      # # USAGE
      # Using pack:
      #   pack [ttk::frame $top.statusbar] -side bottom -fill x
      #   pack [ttk::sizegrip $top.statusbar.grip] -side right -anchor se
      # Using grid:
      #   grid [ttk::sizegrip $top.statusbar.grip] \
      #     -row $lastRow -column $lastColumn -sticky se
      #   # ... optional: add vertical scrollbar in $lastColumn,
      #   # ... optional: add horizontal scrollbar in $lastRow

      # BUG: http://tcl.activestate.com/man/tcl8.5/TkCmd/ttk_sizegrip.htm
      # If the containing toplevel's position was specified relative to the
      # right or bottom of the screen (e.g., 'wm geometry ... wxh-x-y' instead
      # of "wm geometry ... wxh+x+y"), the sizegrip widget will not resize the
      # window. ttk::sizegrip widgets only support "southeast" resizing.
    end
  end
end
