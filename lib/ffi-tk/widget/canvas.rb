module Tk
  class Canvas
    def initialize(parent, options = {})
      @parent = parent
      Tk.execute('canvas', assign_pathname, options.to_tcl_options)
    end


    def option(?arg arg ...?)
      execute(:option, ?arg arg ...?)
    end

    # For each item that meets the constraints specified by searchSpec and the
    # args, add tag to the list of tags associated with the item if it is not
    # already present on that list.
    # It is possible that no items will satisfy the constraints given by
    # searchSpec and args, in which case the command has no effect.
    # This command returns an empty string as result.
    # SearchSpec and arg's may take any of the following forms: above tagOrId
    # Selects the item just after (above) the one given by tagOrId in the
    # display list.
    # If tagOrId denotes more than one item, then the last (topmost) of these
    # items in the display list is used.
    # all Selects all the items in the canvas.
    # below tagOrId Selects the item just before (below) the one given by
    # tagOrId in the display list.
    # If tagOrId denotes more than one item, then the first (lowest) of these
    # items in the display list is used.
    # closest x y ?halo? ?start? Selects the item closest to the point given by
    # x and y.
    # If more than one item is at the same closest distance (e.g.
    # two items overlap the point), then the top-most of these items (the last
    # one in the display list) is used.
    # If halo is specified, then it must be a non-negative value.
    # Any item closer than halo to the point is considered to overlap it.
    # The start argu‐ ment may be used to step circularly through all the
    # closest items.
    # If start is specified, it names an item using a tag or id (if by tag, it
    # selects the first item in the display list with the given tag).
    # Instead of selecting the topmost closest item, this form will select the
    # topmost closest item that is below start in the display list; if no such
    # item exists, then the selection behaves as if the start argument had not
    # been specified.
    # enclosed x1 y1 x2 y2 Selects all the items completely enclosed within the
    # rectangular region given by x1, y1, x2, and y2.
    # X1 must be no greater then x2 and y1 must be no greater than y2.
    # overlapping x1 y1 x2 y2 Selects all the items that overlap or are
    # enclosed within the rectangular region given by x1, y1, x2, and y2.
    # X1 must be no greater then x2 and y1 must be no greater than y2.
    # withtag tagOrId Selects all the items given by tagOrId.
    def addtag(tag searchSpec ?arg arg ...?)
      execute(:addtag, tag searchSpec ?arg arg ...?)
    end

    # Returns a list with four elements giving an approximate bounding box for
    # all the items named by the tagOrId arguments.
    # The list has the form “x1 y1 x2 y2” such that the drawn areas of all the
    # named elements are within the region bounded by x1 on the left, x2 on the
    # right, y1 on the top, and y2 on the bottom.
    # The return value may overestimate the actual bounding box by a few pix‐
    # els. If no items match any of the tagOrId arguments or if the matching
    # items have empty bounding boxes (i.e.
    # they have nothing to display) then an empty string is returned.
    def bbox(tagOrId ?tagOrId tagOrId ...?)
      execute(:bbox, tagOrId ?tagOrId tagOrId ...?)
    end

    # This command associates command with all the items given by tagOrId such
    # that whenever the event sequence given by sequence occurs for one of the
    # items the command will be invoked.
    # This wid‐ get command is similar to the bind command except that it
    # operates on items in a canvas rather than entire widgets.
    # See the bind manual entry for complete details on the syntax of sequence
    # and the substitutions performed on command before invoking it.
    # If all arguments are specified then a new binding is created, replacing
    # any existing binding for the same sequence and tagOrId (if the first
    # character of command is “+” then command augments an existing binding
    # rather than replacing it).
    # In this case the return value is an empty string.
    # If command is omitted then the command returns the command associated
    # with tagOrId and sequence (an error occurs if there is no such binding).
    # If both command and sequence are omitted then the command returns a list
    # of all the sequences for which bindings have been defined for tagOrId.
    # The only events for which bindings may be specified are those related to
    # the mouse and keyboard (such as Enter, Leave, ButtonPress, Motion, and
    # KeyPress) or virtual events.
    # The handling of events in canvases uses the current item defined in ITEM
    # IDS AND TAGS above.
    # Enter and Leave events trigger for an item when it becomes the current
    # item or ceases to be the current item; note that these events are
    # different than Enter and Leave events for windows.
    # Mouse-related events are directed to the current item, if any.
    # Keyboard-related events are directed to the focus item, if any (see the
    # focus widget command below for more on this).
    # If a virtual event is used in a binding, that binding can trigger only if
    # the virtual event is defined by an underlying mouse-related or
    # keyboard-related event.
    # It is possible for multiple bindings to match a particular event.
    # This could occur, for example, if one binding is associated with the
    # item's id and another is associated with one of the item's tags.
    # When this occurs, all of the matching bindings are invoked.
    # A binding associated with the all tag is invoked first, followed by one
    # binding for each of the item's tags (in order), followed by a binding
    # associated with the item's id.
    # If there are multiple matching bindings for a single tag, then only the
    # most specific binding is invoked.
    # A continue command in a binding script terminates that script, and a
    # break command terminates that script and skips any remaining scripts for
    # the event, just as for the bind command.
    # If bindings have been created for a canvas window using the bind command,
    # then they are invoked in addition to bindings created for the canvas's
    # items using the bind widget command.
    # The bind‐ ings for items will be invoked before any of the bindings for
    # the window as a whole.
    def bind(tagOrId ?sequence? ?command?)
      execute(:bind, tagOrId ?sequence? ?command?)
    end

    # Given a window x-coordinate in the canvas screenx, this command returns
    # the canvas x-coordinate that is displayed at that location.
    # If gridspacing is specified, then the canvas coordinate is rounded to the
    # nearest multiple of gridspacing units.
    def canvasx(screenx ?gridspacing?)
      execute(:canvasx, screenx ?gridspacing?)
    end

    # Given a window y-coordinate in the canvas screeny this command returns
    # the canvas y-coordinate that is displayed at that location.
    # If gridspacing is specified, then the canvas coordinate is rounded to the
    # nearest multiple of gridspacing units.
    def canvasy(screeny ?gridspacing?)
      execute(:canvasy, screeny ?gridspacing?)
    end

    # Returns the current value of the configuration option given by option.
    # Option may have any of the values accepted by the canvas command.
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
    # Option may have any of the values accepted by the canvas command.
    def configure(?option? ?value? ?option value ...?)
      execute(:configure, ?option? ?value? ?option value ...?)
    end


    def coords(tagOrId ?x0 y0 ...?)
      execute(:coords, tagOrId ?x0 y0 ...?)
    end

    # Query or modify the coordinates that define an item.
    # If no coordinates are specified, this command returns a list whose
    # elements are the coordinates of the item named by tagOrId.
    # If coordi‐ nates are specified, then they replace the current coordinates
    # for the named item.
    # If tagOrId refers to multiple items, then the first one in the display
    # list is used.
    def coords(tagOrId ?coordList?)
      execute(:coords, tagOrId ?coordList?)
    end


    def create(type x y ?x y ...? ?option value ...?)
      execute(:create, type x y ?x y ...? ?option value ...?)
    end

    # Create a new item in pathName of type type.
    # The exact format of the arguments after type depends on type, but usually
    # they consist of the coordinates for one or more points, followed by spec‐
    # ifications for zero or more item options.
    # See the subsections on individual item types below for more on the syntax
    # of this command.
    # This command returns the id for the new item.
    def create(type coordList ?option value ...?)
      execute(:create, type coordList ?option value ...?)
    end

    # For each item given by tagOrId, delete the characters, or coordinates, in
    # the range given by first and last, inclusive.
    # If some of the items given by tagOrId do not support indexing opera‐
    # tions then they ignore dchars.
    # Text items interpret first and last as indices to a character, line and
    # polygon items interpret them indices to a coordinate (an x,y pair).
    # Indices are described in INDICES above.
    # If last is omitted, it defaults to first.
    # This command returns an empty string.
    def dchars(tagOrId first ?last?)
      execute(:dchars, tagOrId first ?last?)
    end

    # Delete each of the items given by each tagOrId, and return an empty
    # string.
    def delete(?tagOrId tagOrId ...?)
      execute(:delete, ?tagOrId tagOrId ...?)
    end

    # For each of the items given by tagOrId, delete the tag given by
    # tagToDelete from the list of those associated with the item.
    # If an item does not have the tag tagToDelete then the item is unaffected
    # by the command.
    # If tagToDelete is omitted then it defaults to tagOrId.
    # This command returns an empty string.
    def dtag(tagOrId ?tagToDelete?)
      execute(:dtag, tagOrId ?tagToDelete?)
    end

    # This command returns a list consisting of all the items that meet the
    # constraints specified by searchCommand and arg's.
    # SearchCommand and args have any of the forms accepted by the addtag
    # command. The items are returned in stacking order, with the lowest item
    # first.
    def find(searchCommand ?arg arg ...?)
      execute(:find, searchCommand ?arg arg ...?)
    end

    # Set the keyboard focus for the canvas widget to the item given by
    # tagOrId. If tagOrId refers to several items, then the focus is set to the
    # first such item in the display list that supports the insertion cursor.
    # If tagOrId does not refer to any items, or if none of them support the
    # insertion cursor, then the focus is not changed.
    # If tagOrId is an empty string, then the focus item is reset so that no
    # item has the focus.
    # If tagOrId is not specified then the command returns the id for the item
    # that currently has the focus, or an empty string if no item has the
    # focus. Once the focus has been set to an item, the item will display the
    # insertion cursor and all keyboard events will be directed to that item.
    # The focus item within a canvas and the focus window on the screen (set
    # with the focus command) are totally independent: a given item does not
    # actually have the input focus unless (a) its canvas is the focus window
    # and (b) the item is the focus item within the canvas.
    # In most cases it is advisable to follow the focus widget command with the
    # focus command to set the focus window to the canvas (if it was not there
    # already).
    def focus(?tagOrId?)
      execute(:focus, ?tagOrId?)
    end

    # Return a list whose elements are the tags associated with the item given
    # by tagOrId.
    # If tagOrId refers to more than one item, then the tags are returned from
    # the first such item in the dis‐ play list.
    # If tagOrId does not refer to any items, or if the item contains no tags,
    # then an empty string is returned.
    def gettags(tagOrId)
      execute(:gettags, tagOrId)
    end

    # Set the position of the insertion cursor for the item(s) given by tagOrId
    # to just before the character whose position is given by index.
    # If some or all of the items given by tagOrId do not support an insertion
    # cursor then this command has no effect on them.
    # See INDICES above for a description of the legal forms for index.
    # Note: the insertion cursor is only displayed in an item if that item
    # currently has the keyboard focus (see the widget command focus, below),
    # but the cursor position may be set even when the item does not have the
    # focus. This command returns an empty string.
    def icursor(tagOrId index)
      execute(:icursor, tagOrId index)
    end

    # This command returns a decimal string giving the numerical index within
    # tagOrId corresponding to index.
    # Index gives a textual description of the desired position as described in
    # INDICES above.
    # Text items interpret index as an index to a character, line and polygon
    # items interpret it as an index to a coordinate (an x,y pair).
    # The return value is guaranteed to lie between 0 and the number of
    # characters, or coordinates, within the item, inclusive.
    # If tagOrId refers to multiple items, then the index is processed in the
    # first of these items that supports indexing operations (in display list
    # order).
    def index(tagOrId index)
      execute(:index, tagOrId index)
    end

    # For each of the items given by tagOrId, if the item supports text or
    # coordinate, insertion then string is inserted into the item's text just
    # before the character, or coordinate, whose index is beforeThis.
    # Text items interpret beforeThis as an index to a character, line and
    # polygon items interpret it as an index to a coordinate (an x,y pair).
    # For lines and polygons the string must be a valid coordinate sequence.
    # See INDICES above for information about the forms allowed for beforeThis.
    # This command returns an empty string.
    def insert(tagOrId beforeThis string)
      execute(:insert, tagOrId beforeThis string)
    end

    # Returns the current value of the configuration option for the item given
    # by tagOrId whose name is option.
    # This command is similar to the cget widget command except that it applies
    # to a par‐ ticular item rather than the widget as a whole.
    # Option may have any of the values accepted by the create widget command
    # when the item was created.
    # If tagOrId is a tag that refers to more than one item, the first (lowest)
    # such item is used.
    def itemcget(tagOrId option)
      execute(:itemcget, tagOrId option)
    end

    # This command is similar to the configure widget command except that it
    # modifies item-specific options for the items given by tagOrId instead of
    # modifying options for the overall canvas widget.
    # If no option is specified, returns a list describing all of the available
    # options for the first item given by tagOrId (see Tk_ConfigureInfo for
    # information on the format of this list).
    # If option is specified with no value, then the command returns a list
    # describing the one named option (this list will be identical to the
    # corresponding sublist of the value returned if no option is specified).
    # If one or more option-value pairs are specified, then the command
    # modifies the given widget option(s) to have the given value(s) in each of
    # the items given by tagOrId; in this case the command returns an empty
    # string. The options and values are the same as those permissible in the
    # create widget command when the item(s) were created; see the sections
    # describing individual item types below for details on the legal options.
    def itemconfigure(tagOrId ?option? ?value? ?option value ...?)
      execute(:itemconfigure, tagOrId ?option? ?value? ?option value ...?)
    end

    # Move all of the items given by tagOrId to a new position in the display
    # list just before the item given by belowThis.
    # If tagOrId refers to more than one item then all are moved but the rela‐
    # tive order of the moved items will not be changed.
    # BelowThis is a tag or id; if it refers to more than one item then the
    # first (lowest) of these items in the display list is used as the des‐
    # tination location for the moved items.
    # Note: this command has no effect on window items.
    # Window items always obscure other item types, and the stacking order of
    # window items is determined by the raise and lower commands, not the raise
    # and lower widget commands for canvases.
    # This command returns an empty string.
    def lower(tagOrId ?belowThis?)
      execute(:lower, tagOrId ?belowThis?)
    end

    # Move each of the items given by tagOrId in the canvas coordinate space by
    # adding xAmount to the x-coordinate of each point associated with the item
    # and yAmount to the y-coordinate of each point associated with the item.
    # This command returns an empty string.
    def move(tagOrId xAmount yAmount)
      execute(:move, tagOrId xAmount yAmount)
    end

    # Generate a Postscript representation for part or all of the canvas.
    # If the -file option is specified then the Postscript is written to a file
    # and an empty string is returned; otherwise the Postscript is returned as
    # the result of the command.
    # If the interpreter that owns the canvas is marked as safe, the operation
    # will fail because safe interpreters are not allowed to write files.
    # If the -channel option is specified, the argument denotes the name of a
    # channel already opened for writing.
    # The Postscript is written to that channel, and the channel is left open
    # for further writing at the end of the operation.
    # The Postscript is created in Encapsulated Postscript form using version
    # 3.0 of the Document Structuring Conventions.
    # Note: by default Postscript is only generated for information that
    # appears in the canvas's window on the screen.
    # If the canvas is freshly created it may still have its initial size of
    # 1x1 pixel so nothing will appear in the Postscript.
    # To get around this problem either invoke the update command to wait for
    # the canvas window to reach its final size, or else use the -width and
    # -height options to specify the area of the canvas to print.
    # The option-value argument pairs provide additional information to control
    # the generation of Postscript.
    # The following options are supported: -colormap varName VarName must be
    # the name of an array variable that specifies a color mapping to use in
    # the Postscript.
    # Each element of varName must consist of Postscript code to set a
    # particular color value (e.g.
    # “1.0 1.0 0.0 setrgbcolor”).
    # When outputting color information in the Postscript, Tk checks to see if
    # there is an element of varName with the same name as the color.
    # If so, Tk uses the value of the element as the Postscript command to set
    # the color.
    # If this option has not been specified, or if there is no entry in varName
    # for a given color, then Tk uses the red, green, and blue intensities from
    # the X color.
    # -colormode mode Specifies how to output color information.
    # Mode must be either color (for full color output), gray (convert all
    # colors to their gray-scale equivalents) or mono (convert all colors to
    # black or white).
    # -file fileName Specifies the name of the file in which to write the
    # Postscript. If this option is not specified then the Postscript is
    # returned as the result of the command instead of being written to a file.
    # -fontmap varName VarName must be the name of an array variable that
    # specifies a font mapping to use in the Postscript.
    # Each element of varName must consist of a Tcl list with two elements,
    # which are the name and point size of a Postscript font.
    # When outputting Postscript commands for a particular font, Tk checks to
    # see if varName contains an element with the same name as the font.
    # If there is such an element, then the font information contained in that
    # element is used in the Postscript.
    # Otherwise Tk attempts to guess what Postscript font to use.
    # Tk's guesses generally only work for well-known fonts such as Times and
    # Helvetica and Courier, and only if the X font name does not omit any
    # dashes up through the point size.
    # For example, -*-Courier-Bold-R-Normal--*-120-* will work but
    # *Courier-Bold-R-Normal*120* will not; Tk needs the dashes to parse the
    # font name).
    # -height size Specifies the height of the area of the canvas to print.
    # Defaults to the height of the canvas window.
    # -pageanchor anchor Specifies which point of the printed area of the
    # canvas should appear over the positioning point on the page (which is
    # given by the -pagex and -pagey options).
    # For example, -pageanchor n means that the top center of the area of the
    # canvas being printed (as it appears in the canvas window) should be over
    # the positioning point.
    # Defaults to center.
    # -pageheight size Specifies that the Postscript should be scaled in both x
    # and y so that the printed area is size high on the Postscript page.
    # Size consists of a floating-point number followed by c for centimeters, i
    # for inches, m for millimeters, or p or nothing for printer's points (1/72
    # inch). Defaults to the height of the printed area on the screen.
    # If both -pageheight and -pagewidth are specified then the scale factor
    # from -pagewidth is used (non-uniform scaling is not implemented).
    # -pagewidth size Specifies that the Postscript should be scaled in both x
    # and y so that the printed area is size wide on the Postscript page.
    # Size has the same form as for -pageheight.
    # Defaults to the width of the printed area on the screen.
    # If both -pageheight and -pagewidth are specified then the scale factor
    # from -pagewidth is used (non-uniform scaling is not implemented).
    # -pagex position Position gives the x-coordinate of the positioning point
    # on the Postscript page, using any of the forms allowed for -pageheight.
    # Used in conjunction with the -pagey and -pageanchor options to determine
    # where the printed area appears on the Postscript page.
    # Defaults to the center of the page.
    # -pagey position Position gives the y-coordinate of the positioning point
    # on the Postscript page, using any of the forms allowed for -pageheight.
    # Used in conjunction with the -pagex and -pageanchor options to determine
    # where the printed area appears on the Postscript page.
    # Defaults to the center of the page.
    # -rotate boolean Boolean specifies whether the printed area is to be
    # rotated 90 degrees.
    # In non-rotated output the x-axis of the printed area runs along the short
    # dimension of the page (“portrait”ori‐ entation); in rotated output the
    # x-axis runs along the long dimension of the page
    # (“landscape”orientation). Defaults to non-rotated.
    # -width size Specifies the width of the area of the canvas to print.
    # Defaults to the width of the canvas window.
    # -x position Specifies the x-coordinate of the left edge of the area of
    # the canvas that is to be printed, in canvas coordinates, not window
    # coordinates. Defaults to the coordinate of the left edge of the window.
    # -y position Specifies the y-coordinate of the top edge of the area of the
    # canvas that is to be printed, in canvas coordinates, not window
    # coordinates. Defaults to the coordinate of the top edge of the window.
    def postscript(?option value option value ...?)
      execute(:postscript, ?option value option value ...?)
    end

    # Move all of the items given by tagOrId to a new position in the display
    # list just after the item given by aboveThis.
    # If tagOrId refers to more than one item then all are moved but the rela‐
    # tive order of the moved items will not be changed.
    # AboveThis is a tag or id; if it refers to more than one item then the
    # last (topmost) of these items in the display list is used as the des‐
    # tination location for the moved items.
    # Note: this command has no effect on window items.
    # Window items always obscure other item types, and the stacking order of
    # window items is determined by the raise and lower commands, not the raise
    # and lower widget commands for canvases.
    # This command returns an empty string.
    def raise(tagOrId ?aboveThis?)
      execute(:raise, tagOrId ?aboveThis?)
    end

    # Rescale all of the items given by tagOrId in canvas coordinate space.
    # XOrigin and yOrigin identify the origin for the scaling operation and
    # xScale and yScale identify the scale factors for x- and y-coordinates,
    # respectively (a scale factor of 1.0 implies no change to that
    # coordinate). For each of the points defining each item, the x-coordinate
    # is adjusted to change the distance from xOrigin by a factor of xScale.
    # Similarly, each y-coordinate is adjusted to change the distance from
    # yOrigin by a factor of yScale.
    # This command returns an empty string.
    def scale(tagOrId xOrigin yOrigin xScale yScale)
      execute(:scale, tagOrId xOrigin yOrigin xScale yScale)
    end

    # This command is used to implement scanning on canvases.
    # It has two forms, depending on option:
    def scan(option args)
      execute(:scan, option args)
    end

    # Records x and y and the canvas's current view; used in conjunction with
    # later scan dragto commands.
    # Typically this command is associated with a mouse button press in the
    # widget and x and y are the coordinates of the mouse.
    # It returns an empty string.
    def scan(mark x y)
      execute(:scan, mark x y)
    end

    # This command computes the difference between its x and y arguments (which
    # are typically mouse coordinates) and the x and y arguments to the last
    # scan mark command for the widget.
    # It then adjusts the view by gain times the difference in coordinates,
    # where gain defaults to 10.
    # This command is typically associated with mouse motion events in the
    # widget, to produce the effect of dragging the canvas at high speed
    # through its window.
    # The return value is an empty string.
    def scan(dragto x y ?gain?.)
      execute(:scan, dragto x y ?gain?.)
    end

    # Manipulates the selection in one of several ways, depending on option.
    # The command may take any of the forms described below.
    # In all of the descriptions below, tagOrId must refer to an item that
    # supports indexing and selection; if it refers to multiple items then the
    # first of these that supports indexing and the selection is used.
    # Index gives a textual description of a position within tagOrId, as
    # described in INDICES above.
    def select(option ?tagOrId arg?)
      execute(:select, option ?tagOrId arg?)
    end

    # Locate the end of the selection in tagOrId nearest to the character given
    # by index, and adjust that end of the selection to be at index (i.e.
    # including but not going beyond index).
    # The other end of the selection is made the anchor point for future select
    # to commands.
    # If the selection is not currently in tagOrId then this command behaves
    # the same as the select to wid‐ get command.
    # Returns an empty string.
    def select(adjust tagOrId index)
      execute(:select, adjust tagOrId index)
    end

    # Clear the selection if it is in this widget.
    # If the selection is not in this widget then the command has no effect.
    # Returns an empty string.
    def select(clear)
      execute(:select, clear)
    end

    # Set the selection anchor point for the widget to be just before the
    # character given by index in the item given by tagOrId.
    # This command does not change the selection; it just sets the fixed end of
    # the selection for future select to commands.
    # Returns an empty string.
    def select(from tagOrId index)
      execute(:select, from tagOrId index)
    end

    # Returns the id of the selected item, if the selection is in an item in
    # this canvas.
    # If the selection is not in this canvas then an empty string is returned.
    def select(item)
      execute(:select, item)
    end

    # Set the selection to consist of those characters of tagOrId between the
    # selection anchor point and index.
    # The new selection will include the character given by index; it will
    # include the character given by the anchor point only if index is greater
    # than or equal to the anchor point.
    # The anchor point is determined by the most recent select adjust or select
    # from com‐ mand for this widget.
    # If the selection anchor point for the widget is not currently in tagOrId,
    # then it is set to the same character given by index.
    # Returns an empty string.
    def select(to tagOrId index)
      execute(:select, to tagOrId index)
    end

    # Returns the type of the item given by tagOrId, such as rectangle or text.
    # If tagOrId refers to more than one item, then the type of the first item
    # in the display list is returned.
    # If tagOrId does not refer to any items at all then an empty string is
    # returned.
    def type(tagOrId)
      execute(:type, tagOrId)
    end

    # This command is used to query and change the horizontal position of the
    # information displayed in the canvas's window.
    # It can take any of the following forms:
    def xview(?args?)
      execute(:xview, ?args?)
    end

    # Returns a list containing two elements.
    # Each element is a real fraction between 0 and 1; together they describe
    # the horizontal span that is visible in the window.
    # For example, if the first element is .2 and the second element is .6, 20%
    # of the canvas's area (as defined by the -scrollregion option) is
    # off-screen to the left, the middle 40% is visible in the window, and 40%
    # of the canvas is off-screen to the right.
    # These are the same values passed to scrollbars via the -xscrollcommand
    # option.
    def xview
      execute(:xview)
    end

    # Adjusts the view in the window so that fraction of the total width of the
    # canvas is off-screen to the left.
    # Fraction must be a fraction between 0 and 1.
    def xview(moveto fraction)
      execute(:xview, moveto fraction)
    end

    # This command shifts the view in the window left or right according to
    # number and what.
    # Number must be an integer.
    # What must be either units or pages or an abbreviation of one of these.
    # If what is units, the view adjusts left or right in units of the
    # xScrollIncrement option, if it is greater than zero, or in units of
    # one-tenth the window's width otherwise.
    # If what is pages then the view adjusts in units of nine-tenths the
    # window's width.
    # If number is negative then information farther to the left becomes
    # visible; if it is positive then information farther to the right becomes
    # visible.
    def xview(scroll number what)
      execute(:xview, scroll number what)
    end

    # This command is used to query and change the vertical position of the
    # information displayed in the canvas's window.
    # It can take any of the following forms:
    def yview(?args?)
      execute(:yview, ?args?)
    end

    # Returns a list containing two elements.
    # Each element is a real fraction between 0 and 1; together they describe
    # the vertical span that is visible in the window.
    # For example, if the first element is .6 and the second element is 1.0,
    # the lowest 40% of the canvas's area (as defined by the -scrollregion
    # option) is visible in the window.
    # These are the same values passed to scrollbars via the -yscrollcommand
    # option.
    def yview
      execute(:yview)
    end

    # Adjusts the view in the window so that fraction of the canvas's area is
    # off-screen to the top.
    # Fraction is a fraction between 0 and 1.
    def yview(moveto fraction)
      execute(:yview, moveto fraction)
    end

    # This command adjusts the view in the window up or down according to
    # number and what.
    # Number must be an integer.
    # What must be either units or pages.
    # If what is units, the view adjusts up or down in units of the
    # yScrollIncrement option, if it is greater than zero, or in units of
    # one-tenth the window's height otherwise.
    # If what is pages then the view adjusts in units of nine-tenths the
    # window's height.
    # If number is negative then higher information becomes visible; if it is
    # positive then lower information becomes visible.
    def yview(scroll number what)
      execute(:yview, scroll number what)
    end


    def create(arc x1 y1 x2 y2 ?option value option value ...?)
      execute(:create, arc x1 y1 x2 y2 ?option value option value ...?)
    end


    def create(arc coordList ?option value option value ...?)
      execute(:create, arc coordList ?option value option value ...?)
    end


    def create(bitmap x y ?option value option value ...?)
      execute(:create, bitmap x y ?option value option value ...?)
    end


    def create(bitmap coordList ?option value option value ...?)
      execute(:create, bitmap coordList ?option value option value ...?)
    end


    def create(image x y ?option value option value ...?)
      execute(:create, image x y ?option value option value ...?)
    end


    def create(image coordList ?option value option value ...?)
      execute(:create, image coordList ?option value option value ...?)
    end


    def create(line x1 y1... xn yn ?option value option value ...?)
      execute(:create, line x1 y1... xn yn ?option value option value ...?)
    end


    def create(line coordList ?option value option value ...?)
      execute(:create, line coordList ?option value option value ...?)
    end


    def create(oval x1 y1 x2 y2 ?option value option value ...?)
      execute(:create, oval x1 y1 x2 y2 ?option value option value ...?)
    end


    def create(oval coordList ?option value option value ...?)
      execute(:create, oval coordList ?option value option value ...?)
    end


    def create(polygon x1 y1 ... xn yn ?option value option value ...?)
      execute(:create, polygon x1 y1 ... xn yn ?option value option value ...?)
    end


    def create(polygon coordList ?option value option value ...?)
      execute(:create, polygon coordList ?option value option value ...?)
    end


    def create(rectangle x1 y1 x2 y2 ?option value option value ...?)
      execute(:create, rectangle x1 y1 x2 y2 ?option value option value ...?)
    end


    def create(rectangle coordList ?option value option value ...?)
      execute(:create, rectangle coordList ?option value option value ...?)
    end


    def create(text x y ?option value option value ...?)
      execute(:create, text x y ?option value option value ...?)
    end


    def create(text coordList ?option value option value ...?)
      execute(:create, text coordList ?option value option value ...?)
    end


    def create(window x y ?option value option value ...?)
      execute(:create, window x y ?option value option value ...?)
    end


    def create(window coordList ?option value option value ...?)
      execute(:create, window coordList ?option value option value ...?)
    end
  end
end
