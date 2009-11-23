module Tk
  module Tile
    # Tk::Tile::Notebook widget manages a collection of windows
    # and displays a single one at a time. Each slave window
    # is associated with a tab, which the user may select to
    # change the currently-displayed window.
    class Notebook < Widget
      def self.tk_command; 'ttk::notebook'; end
      include TileWidget

      def initialize(parent = Tk.root, options = {})
        super
      end

      def add(window, options)
        execute_only(:add, window, options.to_tcl_options)
      end

      # Returns the list of windows managed by the notebook.
      def tabs
        execute(:tabs).to_a
      end

      # Query or modify the options of the specific tab.
      # If no -option is specified, returns a dictionary of the
      # tab option values. If one -option is specified, returns
      # the value of that option. Otherwise, sets the -options
      # to the corresponding values.
      def tab(window, options = None)
        if None == options
          execute(:tab, window)
        else
          execute_only(:tab, window, options.to_tcl_options)
        end
      end

      # Inserts a pane at the specified position. pos is either
      # the string end, an integer index, or the name of a managed subwindow.
      # If subwindow is already managed by the notebook, moves it to
      # the specified position.
      def insert(pos, window, options)
          execute_only(:insert, pos, window, options.to_tcl_options)
      end

      # Selects the specified tab. The associated slave window
      # will be displayed, and the previously-selected window
      # (if different) is unmapped. If tabid is omitted, returns
      # the widget name of the currently selected pane.
      def select(window)
        execute_only(:select, window)
        window.tk_pathname
      end

      # Remove the pane containing window from the panedwindow.
      # All geometry management options for window will be forgotten.
      def forget(window, *windows)
        execute_only(:forget, window, *windows)
      end

      def hide(window)
        execute_only(:hide, window)
      end

      # Returns the numeric index of the tab specified by tabid,
      # or the total number of tabs if tabid is the string 'end'.
      def index(window)
        execute(:index, window).to_i
      end

      def identify(x, y)
        execute(:identify, x, y)
      end

      def enable_traversal
        self.class.enable_traversal self
      end

      def self.enable_traversal(nb)
        Tk.execute_only('ttk::notebook::enableTraversal', nb)
      end

      # TAB IDENTIFIERS, the tabid argument may take any of the following forms:
      #  * An integer between zero and the number of tabs;
      #  * The name of a slave window;
      #  * A positional specification of the form '@x,y', which identifies the tab
      #  * string 'current', which identifies the currently-selected tab; or:
      #  * string 'end', which returns the number of tabs (only valid for 'pathname index').

      # VIRTUAL EVENTS
      # The notebook widget generates a <<NotebookTabChanged>> virtual event after a new tab is selected.
    end
  end
end
