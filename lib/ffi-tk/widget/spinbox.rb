# frozen_string_literal: true
module Tk
  class Spinbox < Widget
    include Cget, Configure

    def self.tk_command
      'spinbox'
    end

    # Returns a list of four numbers describing the bounding box of the
    # character given by index.
    # The first two elements of the list give the x and y coordinates of the
    # upper-left corner of the screen area covered by the character (in pixels
    # relative to the widget) and the last two elements give the width and
    # height of the character, in pixels.
    # The bounding box may refer to a region outside the visible area of the
    # window.
    def bbox(index)
      execute(:bbox, index).to_a(&:to_i)
    end

    # Delete one or more elements of the spinbox.
    # First is the index of the first character to delete, and last is the
    # index of the character just after the last one to delete.
    # If last is not specified it defaults to first+1, i.e.
    # a single character is deleted.
    # This command returns an empty string.
    def delete(first, last = None)
      execute_only(:delete, first, last)
    end

    # Returns the spinbox's string.
    def get
      execute(:get)
    end

    # Arrange for the insertion cursor to be displayed just before the
    # character given by index.
    def icursor(index)
      execute_only(:icursor, index)
    end

    # Returns the name of the window element corresponding to coordinates x and
    # y in the spinbox.
    # Return value is one of: none, buttondown, buttonup, entry.
    def identify(x, y)
      execute(:identify, x, y).to_sym
    end

    # Returns the numerical index corresponding to index.
    def index(index)
      execute(:index, index)
    end

    # Insert the characters of string just before the character indicated by
    # index. Returns an empty string.
    def insert(index, string)
      execute_only(:insert, index, string)
    end

    # Causes the specified element, either buttondown or buttonup, to be
    # invoked, triggering the action associated with it.
    def invoke(element)
      execute(:invoke, element)
    end

    # Records x and the current view in the spinbox window; used in conjunction
    # with later scan dragto commands.
    # Typically this command is associated with a mouse button press in the
    # widget.
    def scan_mark(x)
      execute_only(:scan, :mark, x)
    end

    # This command computes the difference between its x argument and the x
    # argument to the last scan mark command for the widget.
    # It then adjusts the view left or right by 10 times the difference in
    # x-coordinates. This command is typically associated with mouse motion
    # events in the widget, to produce the effect of dragging the spinbox at
    # high speed through the window.
    def scan_dragto(x)
      execute_only(:scan, :dragto, x)
    end

    # Locate the end of the selection nearest to the character given by index,
    # and adjust that end of the selection to be at index (i.e.
    # including but not going beyond index).
    # The other end of the selection is made the anchor point for future select
    # to commands.
    # If the selection is not currently in the spinbox, then a new selection is
    # created to include the characters between index and the most recent
    # selection anchor point, inclusive.
    def selection_adjust(index)
      execute_only(:selection, :adjust, index)
    end

    # Clear the selection if it is currently in this widget.
    # If the selection is not in this widget then the command has no effect.
    def selection_clear
      execute_only(:selection, :clear)
    end

    # Sets or gets the currently selected element.
    # If a spinbutton element is specified, it will be displayed depressed.
    def selection_element(element = None)
      execute(:selection, :element, element)
    end

    # Set the selection anchor point to just before the character given by
    # index. Does not change the selection.
    def selection_from(index)
      execute_only(:selection, :from, index)
    end

    # Returns 1 if there is are characters selected in the spinbox, 0 if
    # nothing is selected.
    def selection_present
      execute(:selection, :present).to_boolean
    end

    # Sets the selection to include the characters starting with the one
    # indexed by start and ending with the one just before end.
    # If end refers to the same character as start or an earlier one, then the
    # spinbox's selection is cleared.
    def selection_range(from, to)
      execute(:selection, :range, from, to)
    end

    # If index is before the anchor point, set the selection to the characters
    # from index up to but not including the anchor point.
    # If index is the same as the anchor point, do nothing.
    # If index is after the anchor point, set the selection to the characters
    # from the anchor point up to but not including index.
    # The anchor point is determined by the most recent select from or select
    # adjust command in this widget.
    # If the selection is not in this widget then a new selection is created
    # using the most recent anchor point specified for the widget.
    # Returns an empty string.
    def selection_to(index)
      execute(:selection, :to, index)
    end

    # If string is specified, the spinbox will try and set it to this value,
    # otherwise it just returns the spinbox's string.
    # If validation is on, it will occur when setting the string.
    def set(string = None)
      if None == string
        execute(:set)
      else
        execute_only(:set, string)
      end
    end

    # This command is used to force an evaluation of the validateCommand
    # independent of the conditions specified by the validate option.
    # This is done by temporarily setting the validate option to all.
    # It returns 0 or 1.
    def validate
      execute(:validate).to_boolean
    end

    # Returns a list containing two elements.
    # Each element is a real fraction between 0 and 1; together they describe
    # the horizontal span that is visible in the window.
    # For example, if the first element is .2 and the second element is .6, 20%
    # of the spinbox's text is off-screen to the left, the middle 40% is
    # visible in the window, and 40% of the text is off-screen to the right.
    # These are the same values passed to scrollbars via the -xscrollcommand
    # option.
    #
    # Adjusts the view in the window so that the character given by index is
    # displayed at the left edge of the window.
    def xview(index = None)
      if None == index
        execute(:xview)
      else
        execute_only(:xview, index)
      end
    end

    # Adjusts the view in the window so that the character fraction of the way
    # through the text appears at the left edge of the window.
    # Fraction must be a fraction between 0 and 1.
    def xview_moveto(fraction)
      execute(:xview, :moveto, fraction)
    end

    # This command shifts the view in the window left or right according to
    # number and what.
    # Number must be an integer.
    # What must be either units or pages or an abbreviation of one of these.
    # If what is units, the view adjusts left or right by number average-width
    # characters on the display; if it is pages then the view adjusts by number
    # screenfuls. If number is negative then characters farther to the left
    # become visible; if it is positive then characters farther to the right
    # become visible.
    def xview_scroll(number, what)
      execute(:xview, :scroll, number, what)
    end
  end
end
