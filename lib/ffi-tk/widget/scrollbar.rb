module Tk
  class Scrollbar < Widget
    include Cget, Configure

    # Marks the element indicated by element as active, which causes it to be
    # displayed as specified by the activeBackground and activeRelief options.
    # The only element values understood by this command are arrow1, slider, or
    # arrow2. If any other value is specified then no element of the scrollbar
    # will be active.
    # If element is not specified, the command returns the name of the element
    # that is currently active, or an empty string if no element is
    # active.
    def activate(element = None)
      execute(:activate, element).to_s?
    end

    # Returns a real number indicating the fractional change in the scrollbar
    # setting that corresponds to a given change in slider position.
    # For example, if the scrollbar is horizontal, the result indicates how
    # much the scrollbar setting must change to move the slider deltaX pixels
    # to the right (deltaY is ignored in this case).
    # If the scrollbar is vertical, the result indicates how much the scrollbar
    # setting must change to move the slider deltaY pixels down.
    # The arguments and the result may be zero or negative.
    def delta(delta_x, delta_y)
      execute(:delta, delta_x, delta_y)
    end

    # Returns a real number between 0 and 1 indicating where the point given by
    # x and y lies in the trough area of the scrollbar.
    # The value 0 corresponds to the top or left of the trough, the value 1
    # corresponds to the bottom or right, 0.5 corresponds to the middle, and so
    # on. X and y must be pixel coordinates relative to the scrollbar widget.
    # If x and y refer to a point outside the trough, the closest point in the
    # trough is used.
    def fraction(x, y)
      execute(:fraction, x, y)
    end

    # Returns the scrollbar settings in the form of a list whose elements are
    # the arguments to the most recent set widget command.
    def get
      execute(:get)
    end

    # Returns the name of the element under the point given by x and y (such as
    # arrow1), or an empty string if the point does not lie in any element of
    # the scrollbar.
    # X and y must be pixel coordinates relative to the scrollbar widget.
    def identify(x, y)
      execute(:identify, x, y)
    end

    # This command is invoked by the scrollbar's associated widget to tell the
    # scrollbar about the current view in the widget.
    # The command takes two arguments, each of which is a real fraction between
    # 0 and 1.
    # The fractions describe the range of the document that is visible in the
    # associated widget.
    # For example, if first is 0.2 and last is 0.4, it means that the first
    # part of the document visible in the window is 20% of the way through the
    # document, and the last visible part is 40% of the way through.
    # Fraction is a real number between 0 and 1.
    # The widget should adjust its view so that the point given by fraction
    # appears at the beginning of the widget.
    # If fraction is 0 it refers to the beginning of the document.
    # 1.0 refers to the end of the document, 0.333 refers to a point one-third
    # of the way through the document, and so on.
    # The widget should adjust its view by number units.
    # The units are defined in whatever way makes sense for the widget, such as
    # characters or lines in a text widget.
    # Number is either 1, which means one unit should scroll off the top or
    # left of the window, or -1, which means that one unit should scroll off
    # the bottom or right of the window.
    # The widget should adjust its view by number pages.
    # It is up to the widget to define the meaning of a page; typically it is
    # slightly less than what fits in the window, so that there is a slight
    # overlap between the old and new views.
    # Number is either 1, which means the next page should become visible, or
    # -1, which means that the previous page should become visible.
    #
    # In this form the arguments are all integers.
    # TotalUnits gives the total size of the object being displayed in the
    # associated widget.
    # The meaning of one unit depends on the associated widget; for example, in
    # a text editor widget units might correspond to lines of text.
    # WindowUnits indicates the total number of units that can fit in the
    # associated window at one time.
    # FirstUnit and lastUnit give the indices of the first and last units
    # currently visible in the associated window (zero corresponds to the first
    # unit of the object).
    # Unit is an integer that indicates what should appear at the top or left
    # of the associated widget's window.
    # It has the same meaning as the firstUnit and lastUnit arguments to the
    # set widget command.
    # the action auto-repeats.
    # held down, the action auto-repeats.
    # the mouse button is released.
    # held down, the action auto-repeats.
    # the action auto-repeats.
    # button 2 is pressed over one of the arrows, it causes the same behavior
    # as pressing button 1.
    # the view changes to the very bottom (right) of the document; if the mouse
    # is anywhere else then the button press has no effect.
    # toplevel .tl text .tl.t -yscrollcommand {.tl.s set} scrollbar .tl.s
    # -command {.tl.t yview} grid .tl.t .tl.s -sticky nsew grid columnconfigure
    # .tl 0 -weight 1 grid rowconfigure .tl 0 -weight 1
    def set(first, second, third = None, fourth = None)
      execute(:set, first, second, third, fourth)
    end
  end
end