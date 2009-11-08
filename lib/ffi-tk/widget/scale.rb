module Tk
  class Scale < Widget
    INITIALIZE_COMMAND = name.downcase.freeze
    include Cget, Configure

    # Returns a list whose elements are the x and y coordinates of the point
    # along the centerline of the trough that corresponds to value.
    # If value is omitted then the scale's current value is used.
    def coords(value = None)
      execute(:coords, value)
    end

    # If x and y are omitted, returns the current value of the scale.
    # If x and y are specified, they give pixel coordinates within the widget;
    # the command returns the scale value corresponding to the given pixel.
    # Only one of x or y is used: for horizontal scales y is ignored, and for
    # vertical scales x is ignored.
    def get(x = None, y = None)
      execute(:get, x, y)
    end

    # Returns a string indicating what part of the scale lies under the
    # coordinates given by x and y.
    # A return value of slider means that the point is over the slider; trough1
    # means that the point is over the portion of the slider above or to the
    # left of the slider; and trough2 means that the point is over the portion
    # of the slider below or to the right of the slider.
    # If the point is not over one of these elements, an empty string is
    # returned.
    def identify(x, y)
      execute(:identify, x, y)
    end

    # This command is invoked to change the current value of the scale, and
    # hence the position at which the slider is displayed.
    # Value gives the new value for the scale.
    # The command has no effect if the scale is disabled.
    # the button is held down, the action auto-repeats.
    def set(value)
      execute(:set, value)
    end
  end
end
