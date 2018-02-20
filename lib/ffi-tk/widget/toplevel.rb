# frozen_string_literal: true
module Tk
  # A toplevel is similar to a frame except that it is created as a top-level
  # window: its X parent is the root window of a screen rather than the logical
  # parent from its path name.
  # The primary purpose of a toplevel is to serve as a container for dialog
  # boxes and other collections of widgets.
  # The only visible features of a toplevel are its background color and an
  # optional 3-D border to make the toplevel appear raised or sunken.
  class Toplevel < Widget
    include Cget, Configure

    def self.tk_command
      'toplevel'
    end
  end
end
