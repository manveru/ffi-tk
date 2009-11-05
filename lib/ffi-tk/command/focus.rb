module Tk
  # Utility methods for managing the input focus.
  module Focus
    def focus(option = None)
      case option
      when None
        Tk.execute('focus', self)
      when :displayof
        Tk.execute('focus', '-displayof', self)
      when :force
        Tk.execute_only('focus', '-force', self)
      when :lastfor
        Tk.execute('focus', '-lastfor', self)
      end
    end

    def focus_next
      Focus.next(self)
    end

    def focus_prev
      Focus.prev(self)
    end

    module_function

    def focus(window = None, option = None)
      if window == None
        Tk.execute('focus')
      else
        case option
        when None
          Tk.execute('focus', window)
        when :displayof
          Tk.execute('focus', '-displayof', window)
        when :force
          Tk.execute_only('focus', '-force', window)
        when :lastfor
          Tk.execute('focus', '-lastfor', window)
        end
      end
    end

    # This method changes the focus model for the application to an implicit one
    # where the window under the mouse gets the focus.
    # After this method is called, whenever the mouse enters a window Tk will
    # automatically give it the input focus.
    # The focus command may be used to move the focus to a window other than the
    # one under the mouse, but as soon as the mouse moves into a new window the
    # focus will jump to that window.
    #
    # Note: at present there is no built-in support for returning the
    # application to an explicit focus model; to do this you will have to write
    # a script that deletes the bindings created by tk_focusFollowsMouse.
    def follows_mouse
      Tk.execute_only(:tk_focusFollowsMouse)
    end

    # A method used for keyboard traversal.
    # It returns the "next" window after +window+ in focus order.
    #
    # The focus order is determined by the stacking order of windows and the
    # structure of the window hierarchy.
    # Among siblings, the focus order is the same as the stacking order, with
    # the lowest window being first.
    #
    # If a window has children, the window is visited first, followed by its
    # children (recursively), followed by its next sibling.
    #
    # Top-level windows other than +window+ are skipped, so that it never
    # returns a window in a different top-level from +window+.
    #
    # After computing the next window, it examines the window's :takefocus
    # option to see whether it should be skipped.
    #
    # If so, it continues on to the next window in the focus order, until it
    # eventually finds a window that will accept the focus or returns back to
    # window.
    def next(window)
      Tk.execute(:tk_focusNext, window)
    end

    # Similar to [Focus.next], except that it returns the window just before
    # +window+ in the focus order.
    def prev(window)
      Tk.execute(:tk_focusPrev, window)
    end
  end
end