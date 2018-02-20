# frozen_string_literal: true
module Tk
  # Confine pointer and keyboard events to a window sub-tree
  #
  #
  # WARNING
  #
  # It is very easy to use global grabs to render a display completely unusable
  # (e.g. by setting a grab on a widget which does not respond to events and not
  # providing any mechanism for releasing the grab).
  # Take extreme care when using them!
  #
  #
  # DESCRIPTION
  #
  # This command implements simple pointer and keyboard grabs for Tk.
  #
  # Tk's grabs are different than the grabs described in the Xlib documentation.
  # When a grab is set for a particular window, Tk restricts all pointer events
  # to the grab window and its descendants in Tk's window hierarchy.
  #
  # Whenever the pointer is within the grab window's subtree, the pointer will
  # behave exactly the same as if there had been no grab at all and all events
  # will be reported in the normal fashion.
  # When the pointer is outside window's tree, button presses and releases and
  # mouse motion events are reported to window, and window entry and window exit
  # events are ignored.
  #
  # The grab subtree owns the pointer: windows outside the grab subtree
  # will be visible on the screen but they will be insensitive until the grab is
  # released. The tree of windows underneath the grab window can include
  # top-level windows, in which case all of those top-level windows and their
  # descendants will continue to receive mouse events during the grab.
  # Two forms of grabs are possible: local and global.
  # A local grab affects only the grabbing application: events will be reported
  # to other applications as if the grab had never occurred.
  # Grabs are local by default.
  #
  # A global grab locks out all applications on the screen, so that only the
  # given subtree of the grabbing application will be sensitive to pointer
  # events (mouse button presses, mouse button releases, pointer motions, window
  # entries, and window exits).
  #
  # During global grabs the window manager will not receive pointer events
  # either. During local grabs, keyboard events (key presses and key releases)
  # are delivered as usual: the window manager controls which application
  # receives keyboard events, and if they are sent to any window in the grabbing
  # application then they are redirected to the focus window.
  # During a global grab Tk grabs the keyboard so that all keyboard events are
  # always sent to the grabbing application.
  #
  # The focus command is still used to determine which window in the application
  # receives the keyboard events.
  # The keyboard grab is released when the grab is released.
  #
  # Grabs apply to particular displays.
  # If an application has windows on multiple displays then it can establish a
  # separate grab on each display.
  # The grab on a particular display affects only the windows on that display.
  # It is possible for different applications on a single display to have
  # simultaneous local grabs, but only one application can have a global grab on
  # a given display at once.
  module Grab
    # @see Grab.global
    def grab_global(_window)
      Grab.globa(self)
    end

    # @see Grab.local
    def grab_local
      Grab.local(self)
    end

    # @see Grab.current
    def grab_current
      Grab.current(self)
    end

    # @see Grab.release
    def grab_release
      Grab.release(self)
    end

    # @see Grab.set_global
    def grab_set_global
      Grab.set_global(self)
    end

    # @see Grab.set_local
    def grab_set_local
      Grab.set_local(self)
    end

    module_function

    # Same as [set_global], described below.
    def global(window)
      Tk.execute(:grab, '-global', window)
    end

    # Same as [set_local], described below.
    def local(window)
      Tk.execute(:grab, window)
    end

    # If window is specified, returns the name of the current grab window in
    # this application for window's display, or an empty string if there is no
    # such window.
    # If window is omitted, the command returns a list whose elements are all
    # of the windows grabbed by this application for all displays, or an empty
    # string if the application has no grabs.
    def current(window = None)
      if None == window
        Tk.execute(:grab, :current).to_a
      else
        Tk.execute(:grab, :current, window).to_s?
      end
    end

    # Releases the grab on window if there is one, otherwise does nothing.
    # Returns an empty string.
    def release(window)
      Tk.execute_only(:grab, :release, window)
    end

    # Sets a local grab on window.
    # If a grab was already in effect for this application on +window+'s display
    # then it is automatically released.
    # Does nothing if there is already a local grab on +window+.
    def set_local(window)
      Tk.execute(:grab, :set, window)
    end

    # Sets a global grab on window.
    # If a grab was already in effect for this application on +window+'s display
    # then it is automatically released.
    # Does nothing if there is already a global grab on +window+.
    def set_global(window)
      Tk.execute(:grab, :set, '-global', window)
    end
  end
end
