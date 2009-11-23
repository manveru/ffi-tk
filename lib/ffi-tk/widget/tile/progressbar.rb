module Tk
  module Tile
    # progressbar widget shows the status of a long-running operation.
    # They can operate in two modes: determinate mode shows the amount
    # completed relative to the total amount of work to be done, and
    # indeterminate mode provides an animated display to let the user
    # know that something is happening.
    class Progressbar < Widget
      def self.tk_command; 'ttk::progressbar'; end
      include TileWidget, Cget, Configure

      # Begin autoincrement mode
      # schedules a recurring timer event that calls step every
      # interval milliseconds. If omitted, interval defaults to
      # 50 milliseconds (20 steps/second).
      def start(interval = None)
        execute_only(:start, interval)
      end

      # Stop autoincrement mode
      # cancels any recurring timer event initiated by #start
      def stop
        execute_only(:stop)
      end

      # Increments the -value by amount. amount defaults to 1.0 if omitted.
      def step(amount = 1.0)
        execute_only(:step, amount)
      end

      # the current value of the progress bar. In determinate mode,
      # this represents the amount of work completed. In indeterminate mode,
      # it is interpreted modulo -maximum; that is, the progress bar
      # completes one 'cycle' when the -value increases by -maximum.
      def value
        execute(:cget, '-value').to_f
      end

      def phase
        execute(:cget, '-phase').to_i
      end


      def identify(x, y)
        execute(:identify, x, y)
      end

      # Specifies the orientation of the scrollbar.
      # horizontal or vertical
      def orient(orientation = None)
        if None == orientation
          cget(:orient)
        else
          configure orient: orientation
        end
      end
    end
  end
end
