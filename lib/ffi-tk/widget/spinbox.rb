module Tk
  class Spinbox
    def initialize(parent, options = {})
      @parent = parent
      Tk.execute('spinbox', assign_pathname, options.to_tcl_options)
    end


    def option(?arg arg ...?)
      execute(:option, ?arg arg ...?)
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
      execute(:bbox, index)
    end

    # Returns the current value of the configuration option given by option.
    # Option may have any of the values accepted by the spinbox command.
    def cget(option)
      execute(:cget, option)
    end

    # Query or modify the configuration options of the widget.
    # If no option is specified, returns a list describing all of the available
    # options for pathName (see Tk_ConfigureInfo for information on the format
    # of this list).
    # If option is specified with no value, then the command returns a list
    # describing the one named option (this list will be identical to the
    # corresponding sublist of the value returned if no option is specified).
    # If one or more option-value pairs are specified, then the command
    # modifies the given widget option(s) to have the given value(s); in this
    # case the command returns an empty string.
    # Option may have any of the values accepted by the spinbox command.
    def configure(?option? ?value option value ...?)
      execute(:configure, ?option? ?value option value ...?)
    end

    # Delete one or more elements of the spinbox.
    # First is the index of the first character to delete, and last is the
    # index of the character just after the last one to delete.
    # If last is not specified it defaults to first+1, i.e.
    # a single character is deleted.
    # This command returns an empty string.
    def delete(first ?last?)
      execute(:delete, first ?last?)
    end

    # Returns the spinbox's string.
    def get
      execute(:get)
    end

    # Arrange for the insertion cursor to be displayed just before the
    # character given by index.
    # Returns an empty string.
    def icursor(index)
      execute(:icursor, index)
    end

    # Returns the name of the window element corresponding to coordinates x and
    # y in the spinbox.
    # Return value is one of: none, buttondown, buttonup, entry.
    def identify(x y)
      execute(:identify, x y)
    end

    # Returns the numerical index corresponding to index.
    def index(index)
      execute(:index, index)
    end

    # Insert the characters of string just before the character indicated by
    # index. Returns an empty string.
    def insert(index string)
      execute(:insert, index string)
    end

    # Causes the specified element, either buttondown or buttonup, to be
    # invoked, triggering the action associated with it.
    def invoke(element)
      execute(:invoke, element)
    end

    # This command is used to implement scanning on spinboxes.
    # It has two forms, depending on option:
    def scan(option args)
      execute(:scan, option args)
    end

    # Records x and the current view in the spinbox window; used in conjunction
    # with later scan dragto commands.
    # Typically this command is associated with a mouse button press in the
    # wid‐ get.
    # It returns an empty string.
    def scan(mark x)
      execute(:scan, mark x)
    end

    # This command computes the difference between its x argument and the x
    # argument to the last scan mark command for the widget.
    # It then adjusts the view left or right by 10 times the dif‐ ference in
    # x-coordinates. This command is typically associated with mouse motion
    # events in the widget, to produce the effect of dragging the spinbox at
    # high speed through the window.
    # The return value is an empty string.
    def scan(dragto x)
      execute(:scan, dragto x)
    end

    # This command is used to adjust the selection within a spinbox.
    # It has several forms, depending on option:
    def selection(option arg)
      execute(:selection, option arg)
    end

    # Locate the end of the selection nearest to the character given by index,
    # and adjust that end of the selection to be at index (i.e.
    # including but not going beyond index).
    # The other end of the selection is made the anchor point for future select
    # to commands.
    # If the selection is not currently in the spinbox, then a new selection is
    # created to include the characters between index and the most recent
    # selection anchor point, inclusive.
    # Returns an empty string.
    def selection(adjust index)
      execute(:selection, adjust index)
    end

    # Clear the selection if it is currently in this widget.
    # If the selection is not in this widget then the command has no effect.
    # Returns an empty string.
    def selection(clear)
      execute(:selection, clear)
    end

    # Sets or gets the currently selected element.
    # If a spinbutton element is specified, it will be displayed depressed.
    def selection(element ?element?)
      execute(:selection, element ?element?)
    end

    # Set the selection anchor point to just before the character given by
    # index. Does not change the selection.
    # Returns an empty string.
    def selection(from index)
      execute(:selection, from index)
    end

    # Returns 1 if there is are characters selected in the spinbox, 0 if
    # nothing is selected.
    def selection(present)
      execute(:selection, present)
    end

    # Sets the selection to include the characters starting with the one
    # indexed by start and ending with the one just before end.
    # If end refers to the same character as start or an earlier one, then the
    # spinbox's selection is cleared.
    def selection(range start end)
      execute(:selection, range start end)
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
    def selection(to index)
      execute(:selection, to index)
    end

    # If string is specified, the spinbox will try and set it to this value,
    # otherwise it just returns the spinbox's string.
    # If validation is on, it will occur when setting the string.
    def set(?string?)
      execute(:set, ?string?)
    end

    # This command is used to force an evaluation of the validateCommand
    # independent of the conditions specified by the validate option.
    # This is done by temporarily setting the validate option to all.
    # It returns 0 or 1.
    def validate
      execute(:validate)
    end

    # This command is used to query and change the horizontal position of the
    # text in the widget's window.
    # It can take any of the following forms:
    def xview(args)
      execute(:xview, args)
    end

    # Returns a list containing two elements.
    # Each element is a real fraction between 0 and 1; together they describe
    # the horizontal span that is visible in the window.
    # For example, if the first element is .2 and the second element is .6, 20%
    # of the spinbox's text is off-screen to the left, the middle 40% is
    # visible in the window, and 40% of the text is off-screen to the right.
    # These are the same values passed to scrollbars via the -xscrollcommand
    # option.
    def xview
      execute(:xview)
    end

    # Adjusts the view in the window so that the character given by index is
    # displayed at the left edge of the window.
    def xview(index)
      execute(:xview, index)
    end

    # Adjusts the view in the window so that the character fraction of the way
    # through the text appears at the left edge of the window.
    # Fraction must be a fraction between 0 and 1.
    def xview(moveto fraction)
      execute(:xview, moveto fraction)
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
    def xview(scroll number what)
      execute(:xview, scroll number what)
    end
  end
end
