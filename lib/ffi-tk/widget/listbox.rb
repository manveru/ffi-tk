module Tk
  class Listbox < Widget
    INITIALIZE_COMMAND = name.downcase.freeze
    include Cget, Configure

    def clear
      delete 0, :end
    end

    def value
    end

    def value=(enumerable)
      clear
      enumerable.each{|element| insert(:end, element) }
    end

    # Sets the active element to the one indicated by index.
    # If index is outside the range of elements in the listbox then the closest
    # element is activated.
    # The active element is drawn as speci‐ fied by -activestyle when the
    # widget has the input focus, and its index may be retrieved with the index
    # active.
    def activate(index)
      execute_only(:activate, index)
    end

    # Returns a list of four numbers describing the bounding box of the text in
    # the element given by index.
    # The first two elements of the list give the x and y coordinates of the
    # upper-left corner of the screen area covered by the text (specified in
    # pixels relative to the widget) and the last two elements give the width
    # and height of the area, in pixels.
    # If no part of the element given by index is visible on the screen, or if
    # index refers to a non-existent element, then the result is an empty
    # string; if the element is partially visible, the result gives the full
    # area of the element, including any parts that are not visible.
    def bbox(index)
      execute(:bbox, index).to_a(&:to_i)
    end

    # Returns a list containing the numerical indices of all of the elements in
    # the listbox that are currently selected.
    # If there are no elements selected in the listbox then an empty string is
    # returned.
    def curselection
      execute(:curselection).to_a(&:to_i)
    end

    # Deletes one or more elements of the listbox.
    # First and last are indices specifying the first and last elements in the
    # range to delete.
    # If last is not specified it defaults to first, i.e.
    # a single element is deleted.
    def delete(first, last = None)
      execute(:delete, first, last)
    end

    # If last is omitted, returns the contents of the listbox element indicated
    # by first, or an empty string if first refers to a non-existent element.
    # If last is specified, the command returns a list whose elements are all
    # of the listbox elements between first and last, inclusive.
    # Both first and last may have any of the standard forms for indices.
    def get(first, last = None)
      execute(:get, first, last)
    end

    # Returns the integer index value that corresponds to index.
    # If index is end the return value is a count of the number of elements in
    # the listbox (not the index of the last element).
    def index(index)
      execute(:index, index)
    end

    # Inserts zero or more new elements in the list just before the element
    # given by index.
    # If index is specified as end then the new elements are added to the end
    # of the list.
    # Returns an empty string.
    def insert(index, *elements)
      execute_only(:insert, index, *elements)
    end

    # Returns the current value of the item configuration option given by
    # option. Option may have any of the values accepted by the listbox
    # itemconfigure command.
    def itemcget(index, option)
      execute(:itemcget, index, option.to_tcl_option)
    end

    # Query or modify the configuration options of an item in the listbox.
    # If no option is specified, returns a list describing all of the available
    # options for the item (see Tk_ConfigureInfo for information on the format
    # of this list).
    # If option is specified with no value, then the command returns a list
    # describing the one named option (this list will be identical to the
    # correspond‐ ing sublist of the value returned if no option is specified).
    # If one or more option-value pairs are specified, then the command
    # modifies the given widget option(s) to have the given value(s); in this
    # case the command returns an empty string.
    # The following options are currently supported for items: -background
    # color Color specifies the background color to use when displaying the
    # item. It may have any of the forms accepted by Tk_GetColor.
    # -foreground color Color specifies the foreground color to use when
    # displaying the item.
    # It may have any of the forms accepted by Tk_GetColor.
    # -selectbackground color color specifies the background color to use when
    # displaying the item while it is selected.
    # It may have any of the forms accepted by Tk_GetColor.
    # -selectforeground color color specifies the foreground color to use when
    # displaying the item while it is selected.
    # It may have any of the forms accepted by Tk_GetColor.
    def itemconfigure(index, options = None)
      common_configure(:itemconfigure, index, options)
    end

    # Given a y-coordinate within the listbox window, this command returns the
    # index of the (visible) listbox element nearest to that y-coordinate.
    def nearest(y)
      execute(:nearest, y)
    end

    # Records x and y and the current view in the listbox window; used in
    # conjunction with later scan dragto commands.
    # Typically this command is associated with a mouse button press in the
    # widget. It returns an empty string.
    def scan_mark(x, y)
      execute_only(:scan, :mark, x, y)
    end

    # This command computes the difference between its x and y arguments and
    # the x and y arguments to the last scan mark command for the widget.
    # It then adjusts the view by 10 times the dif‐ ference in coordinates.
    # This command is typically associated with mouse motion events in the
    # widget, to produce the effect of dragging the list at high speed through
    # the window.
    # The return value is an empty string.
    def scan_dragto(x, y)
      execute_only(:scan, :dragto, x, y)
    end

    # Adjust the view in the listbox so that the element given by index is
    # visible. If the element is already visible then the command has no
    # effect; if the element is near one edge of the window then the listbox
    # scrolls to bring the element into view at the edge; otherwise the listbox
    # scrolls to center the element.
    def see(index)
      execute(:see, index)
    end

    # Sets the selection anchor to the element given by index.
    # If index refers to a non-existent element, then the closest element is
    # used. The selection anchor is the end of the selection that is fixed
    # while dragging out a selection with the mouse.
    # The index anchor may be used to refer to the anchor element.
    def selection_anchor(index)
      execute(:selection, :anchor, index)
    end

    # If any of the elements between first and last (inclusive) are selected,
    # they are deselected.
    # The selection state is not changed for elements outside this range.
    def selection_clear(first, last = None)
      execute(:selection, :clear, first, last)
    end

    # Returns 1 if the element indicated by index is currently selected, 0 if
    # it is not.
    def selection_includes(index)
      execute(:selection, :includes, index)
    end

    # Selects all of the elements in the range between first and last,
    # inclusive, without affecting the selection state of elements outside that
    # range.
    def selection_set(first, last = None)
      execute(:selection, :set, first, last)
    end

    # Returns a decimal string indicating the total number of elements in the
    # listbox.
    def size
      execute(:size)
    end

    # Returns a list containing two elements.
    # Each element is a real fraction between 0 and 1; together they describe
    # the horizontal span that is visible in the window.
    # For example, if the first element is .2 and the second element is .6, 20%
    # of the listbox's text is off-screen to the left, the middle 40% is
    # visible in the window, and 40% of the text is off-screen to the right.
    # These are the same values passed to scrollbars via the -xscrollcommand
    # option.
    #
    # Adjusts the view in the window so that the character position given by
    # index is displayed at the left edge of the window.
    # Character positions are defined by the width of the character 0.
    def xview(index = None)
      if None == index
        execute(:xview).to_a(&:to_f)
      else
        execute_only(:xview, index)
      end
    end

    # Adjusts the view in the window so that fraction of the total width of the
    # listbox text is off-screen to the left.
    # fraction must be a fraction between 0 and 1.
    def xview_moveto(fraction)
      execute_only(:xview, :moveto, fraction)
    end

    # This command shifts the view in the window left or right according to
    # number and what.
    # Number must be an integer.
    # What must be either units or pages or an abbreviation of one of these.
    # If what is units, the view adjusts left or right by number character
    # units (the width of the 0 character) on the display; if it is pages then
    # the view adjusts by number screen‐ fuls.
    # If number is negative then characters farther to the left become visible;
    # if it is positive then characters farther to the right become visible.
    def xview_scroll(number, what)
      execute(:xview, :scroll, number, what)
    end

    # Returns a list containing two elements, both of which are real fractions
    # between 0 and 1.
    # The first element gives the position of the listbox element at the top of
    # the window, relative to the listbox as a whole (0.5 means it is halfway
    # through the listbox, for example).
    # The second element gives the position of the listbox element just after
    # the last one in the win‐ dow, relative to the listbox as a whole.
    # These are the same values passed to scrollbars via the -yscrollcommand
    # option.
    #
    # Adjusts the view in the window so that the element given by index is
    # displayed at the top of the window.
    def yview(index = None)
      if None == index
        execute(:yview).to_a(&:to_f)
      else
        execute(:yview, index)
      end
    end

    # Adjusts the view in the window so that the element given by fraction
    # appears at the top of the window.
    # Fraction is a fraction between 0 and 1; 0 indicates the first element in
    # the listbox, 0.33 indicates the element one-third the way through the
    # listbox, and so on.
    def yview_moveto(fraction)
      execute_only(:yview, :moveto, fraction)
    end

    # This command adjusts the view in the window up or down according to
    # number and what.
    # Number must be an integer.
    # What must be either units or pages.
    # If what is units, the view adjusts up or down by number lines; if it is
    # pages then the view adjusts by number screenfuls.
    # If number is negative then earlier elements become visible; if it is
    # positive then later ele‐ ments become visible.
    def yview_scroll(number, what)
      execute_only(:yview, :scroll, number, what)
    end
  end
end