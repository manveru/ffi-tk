# frozen_string_literal: true
module Tk
  # An entry is a widget that displays a one-line text string and allows that
  # string to be edited using widget methods described below, which are
  # typically bound to keystrokes and mouse actions.
  # When first created, an entry's string is empty.
  # A portion of the entry may be selected as described below.
  # If an entry is exporting its selection (see the exportSelection option),
  # then it will observe the standard X11 protocols for handling the selection;
  # entry selections are available as type STRING.
  # Entries also observe the standard Tk rules for dealing with the input focus.
  # When an entry has the input focus it displays an insertion cursor to
  # indicate where new characters will be inserted.
  #
  # Entries are capable of displaying strings that are too long to fit entirely
  # within the widget's window.
  # In this case, only a portion of the string will be displayed; methods
  # described below may be used to change the view in the window.
  # Entries use the standard xScrollCommand mechanism for interacting with
  # scrollbars (see the description of the xScrollCommand option for details).
  # They also support scanning, as described below.
  class Entry < Widget
    include Cget, Configure

    def self.tk_command
      'entry'
    end

    def value
      get
    end

    def value=(string)
      delete 0, :end
      insert 0, string
    end

    def clear
      delete 0, :end
    end

    def cursor
      index(:insert)
    end

    def cursor=(index)
      icursor(index)
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

    # Delete one or more elements of the entry.
    # First is the index of the first character to delete, and last is the index
    # of the character just after the last one to delete.
    # If last is not specified it defaults to first+1, i.e. a single character
    # is deleted.
    def delete(first, last = None)
      execute(:delete, first, last)
    end

    # Returns the entry's string.
    def get
      execute(:get).to_s
    end

    # Arrange for the insertion cursor to be displayed just before the character
    # given by index.
    def icursor(index)
      execute_only(:icursor, index)
    end

    # Returns the numerical index corresponding to index.
    def index(index)
      execute(:index, index)
    end

    # Insert the characters of string just before the character indicated by
    # index.
    def insert(index, string)
      execute_only(:insert, index, string)
    end

    # Records x and the current view in the entry window; used in conjunction
    # with later scan dragto commands.
    # Typically this command is associated with a mouse button press in the
    # widget.
    def scan_mark(x)
      execute_only(:scan, :mark, x)
    end

    # This command computes the difference between its x argument and the x
    # argument to the last scan mark command for the widget.
    # It then adjusts the view left or right by 10 times the difference in
    # x-coordinates.
    # This command is typically associated with mouse motion events in the
    # widget, to produce the effect of dragging the entry at high speed through
    # the window.
    def scan_dragto(x)
      execute_only(:scan, :dragto, x)
    end

    # Locate the end of the selection nearest to the character given by index,
    # and adjust that end of the selection to be at index (i.e. including but
    # not going beyond index).
    # The other end of the selection is made the anchor point for future select
    # to commands.
    # If the selection is not currently in the entry, then a new selection is
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

    # Set the selection anchor point to just before the character given by
    # index.
    # Does not change the selection.
    def selection_from(index)
      execute_only(:selection, :from, index)
    end

    # Returns true if there is are characters selected in the entry, false if
    # nothing is selected.
    def selection_present
      execute(:selection, :present) == 1
    end

    # Sets the selection to include the characters starting with the one indexed
    # by start and ending with the one just before end.
    # If end refers to the same character as start or an earlier one, then the
    # entry's selection is cleared.
    def selection_range(from, to)
      execute_only(:selection, :range, from, to)
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
    def selection_to(index)
      execute_only(:selection, :to, index)
    end

    # This command is used to force an evaluation of the validateCommand
    # independent of the conditions specified by the validate option.
    # This is done by temporarily setting the validate option to all.
    # It returns true or false.
    def validate
      execute(:validate) == 1
    end

    # Adjusts the view in the window so that the character given by index is
    # displayed at the left edge of the window.
    #
    # If no index is given, it returns a list containing two elements.
    # Each element is a real fraction between 0 and 1; together they describe
    # the horizontal span that is visible in the window.
    # For example, if the first element is 0.2 and the second element is 0.6,
    # 20% of the entry's text is off-screen to the left, the middle 40% is
    # visible in the window, and 40% of the text is off-screen to the right.
    # These are the same values passed to scrollbars via the :xscrollcommand
    # option.
    def xview(index = None)
      if index == None
        execute(:xview)
      else
        execute_only(:xview, index)
      end
    end

    # Adjusts the view in the window so that the character fraction of the way
    # through the text appears at the left edge of the window.
    # Fraction must be a fraction between 0 and 1.
    def xview_moveto(fraction)
      execute_only(:xview, :moveto, fraction)
    end

    # This command shifts the view in the window left or right according to
    # number and what.
    # Number must be an integer.
    # What must be either units or pages or an abbreviation of one of these.
    # If what is units, the view adjusts left or right by number average-width
    # characters on the display; if it is pages then the view adjusts by number
    # screenfuls.
    # If number is negative then characters farther to the left become visible;
    # if it is positive then characters farther to the right become visible.
    def xview_scroll(number, what)
      execute_only(:xview, :scroll, number, what)
    end
  end
end
