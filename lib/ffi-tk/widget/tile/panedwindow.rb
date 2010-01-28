module Tk
  module Tile
    class PanedWindow < Tk::PanedWindow
      def self.tk_command; 'ttk::panedwindow'; end
      include TileWidget

      # pathname add subwindow options...
      # Adds a new pane to the window.
      # subwindow must be a direct child of the paned window pathname.
      # See PANE OPTIONS for the list of available options.
      def add(subwindow, options = {})
        execute_only(:add, subwindow, options.to_tcl_options)
      end

      # pathname forget pane
      # Removes the specified subpane from the widget.
      # pane is either an integer index or the name of a managed subwindow.
      def forget(pane)
        execute_only(:forget, pane)
      end

      # pathname identify x y
      # Returns the index of the sash at point x,y, or the empty string if x,y
      # is not over a sash.
      def identify(x, y)
        execute(:identify, x, y)
      end

      # pathname insert pos subwindow options...
      # Inserts a pane at the specified position.
      # pos is either the string end, an integer index, or the name of a managed
      # subwindow. If subwindow is already managed by the paned window, moves it
      # to the specified position.
      # See PANE OPTIONS for the list of available options.
      def insert(pos, subwindow, options = {})
        execute_only(:insert, pos, subwindow, options.to_tcl_options)
      end

      # pathname pane pane -option ?value ?-option value...
      # Query or modify the options of the specified pane, where pane is either
      # an integer index or the name of a managed subwindow.
      # If no -option is specified, returns a dictionary of the pane option
      # values. If one -option is specified, returns the value of that option.
      # Otherwise, sets the -options to the corresponding values.
      def pane(pane, options = {})
        common_configure([:pane, pane], options)
      end

      # pathname sashpos index ?newpos?
      # If newpos is specified, sets the position of sash number index.
      # May adjust the positions of adjacent sashes to ensure that positions are
      # monotonically increasing.
      # Sash positions are further constrained to be between 0 and the total
      # size of the widget.
      # Returns the new position of sash number index.
      def sashpos(index, newpos = None)
        execute(:sashpos, index, newpos)
      end
    end
  end
end
