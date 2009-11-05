module Tk
  class Menu
    include Cget, Configure

    def initialize(parent, options = {})
      @parent = parent
      Tk.execute('menu', assign_pathname, options.to_tcl_options)
    end

    # Change the state of the entry indicated by index to active and redisplay
    # it using its active colors.
    # Any previously-active entry is deactivated.
    # If index is specified as none, or if the specified entry is disabled,
    # then the menu ends up with no active entry.
    # Returns an empty string.
    def activate(index)
      execute(:activate, index)
    end

    # Add a new entry to the bottom of the menu.
    # The new entry's type is given by type and must be one of cascade,
    # checkbutton, command, radiobutton, or separator, or a unique abbreviation
    # of one of the above.
    # If additional arguments are present, they specify any of the following
    # options: -activebackground value Specifies a background color to use for
    # displaying this entry when it is active.
    # If this option is specified as an empty string (the default), then the
    # activeBackground option for the overall menu is used.
    # If the tk_strictMotif variable has been set to request strict Motif
    # compliance, then this option is ignored and the -background option is
    # used in its place.
    # This option is not available for separator or tear-off entries.
    # -activeforeground value Specifies a foreground color to use for
    # displaying this entry when it is active.
    # If this option is specified as an empty string (the default), then the
    # activeForeground option for the overall menu is used.
    # This option is not available for separator or tear-off entries.
    # -accelerator value Specifies a string to display at the right side of the
    # menu entry.
    # Normally describes an accelerator keystroke sequence that may be typed to
    # invoke the same function as the menu entry.
    # This option is not available for separator or tear-off entries.
    # -background value Specifies a background color to use for displaying this
    # entry when it is in the normal state (neither active nor disabled).
    # If this option is specified as an empty string (the default), then the
    # background option for the overall menu is used.
    # This option is not available for separator or tear-off entries.
    # -bitmap value Specifies a bitmap to display in the menu instead of a
    # textual label, in any of the forms accepted by Tk_GetBitmap.
    # This option overrides the -label option (as controlled by the -com‐ pound
    # option) but may be reset to an empty string to enable a textual label to
    # be displayed.
    # If a -image option has been specified, it overrides -bitmap.
    # This option is not available for separator or tear-off entries.
    # -columnbreak value When this option is zero, the entry appears below the
    # previous entry.
    # When this option is one, the entry appears at the top of a new column in
    # the menu.
    # -command value Specifies a Tcl command to execute when the menu entry is
    # invoked. Not available for separator or tear-off entries.
    # -compound value Specifies whether the menu entry should display both an
    # image and text, and if so, where the image should be placed relative to
    # the text.
    # Valid values for this option are bottom, cen‐ ter, left, none, right and
    # top. The default value is none, meaning that the button will display
    # either an image or text, depending on the values of the -image and
    # -bitmap options.
    # -font value Specifies the font to use when drawing the label or
    # accelerator string in this entry.
    # If this option is specified as an empty string (the default) then the
    # font option for the overall menu is used.
    # This option is not available for separator or tear-off entries.
    # -foreground value Specifies a foreground color to use for displaying this
    # entry when it is in the normal state (neither active nor disabled).
    # If this option is specified as an empty string (the default), then the
    # foreground option for the overall menu is used.
    # This option is not available for separator or tear-off entries.
    # -hidemargin value Specifies whether the standard margins should be drawn
    # for this menu entry.
    # This is useful when creating palette with images in them, i.e., color
    # palettes, pattern palettes, etc.
    # 1 indicates that the margin for the entry is hidden; 0 means that the
    # margin is used.
    # -image value Specifies an image to display in the menu instead of a text
    # string or bitmap.
    # The image must have been created by some previous invocation of image
    # create. This option overrides the -label and -bitmap options (as
    # controlled by the -compound option) but may be reset to an empty string
    # to enable a textual or bitmap label to be displayed.
    # This option is not available for separator or tear-off entries.
    # -indicatoron value Available only for checkbutton and radiobutton
    # entries. Value is a boolean that determines whether or not the indicator
    # should be displayed.
    # -label value Specifies a string to display as an identifying label in the
    # menu entry.
    # Not available for separator or tear-off entries.
    # -menu value Available only for cascade entries.
    # Specifies the path name of the submenu associated with this entry.
    # The submenu must be a child of the menu.
    # -offvalue value Available only for checkbutton entries.
    # Specifies the value to store in the entry's associated variable when the
    # entry is deselected.
    # -onvalue value Available only for checkbutton entries.
    # Specifies the value to store in the entry's associated variable when the
    # entry is selected.
    # -selectcolor value Available only for checkbutton and radiobutton
    # entries. Specifies the color to display in the indicator when the entry
    # is selected.
    # If the value is an empty string (the default) then the selectColor option
    # for the menu determines the indicator color.
    # -selectimage value Available only for checkbutton and radiobutton
    # entries. Specifies an image to display in the entry (in place of the
    # -image option) when it is selected.
    # Value is the name of an image, which must have been created by some
    # previous invocation of image create.
    # This option is ignored unless the -image option has been specified.
    # -state value Specifies one of three states for the entry: normal, active,
    # or disabled.
    # In normal state the entry is displayed using the foreground option for
    # the menu and the background option from the entry or the menu.
    # The active state is typically used when the pointer is over the entry.
    # In active state the entry is displayed using the activeForeground option
    # for the menu along with the activebackground option from the entry.
    # Disabled state means that the entry should be insensitive: the default
    # bindings will refuse to activate or invoke the entry.
    # In this state the entry is displayed according to the disabledForeground
    # option for the menu and the background option from the entry.
    # This option is not available for separa‐ tor entries.
    # -underline value Specifies the integer index of a character to underline
    # in the entry.
    # This option is also queried by the default bindings and used to implement
    # keyboard traversal.
    # 0 corresponds to the first character of the text displayed in the entry,
    # 1 to the next character, and so on.
    # If a bitmap or image is displayed in the entry then this option is
    # ignored. This option is not available for separator or tear-off entries.
    # -value value Available only for radiobutton entries.
    # Specifies the value to store in the entry's associated variable when the
    # entry is selected.
    # If an empty string is specified, then the -label option for the entry as
    # the value to store in the variable.
    # -variable value Available only for checkbutton and radiobutton entries.
    # Specifies the name of a global value to set when the entry is selected.
    # For checkbutton entries the variable is also set when the entry is
    # deselected. For radiobutton entries, changing the variable causes the
    # currently-selected entry to deselect itself.
    # The add widget command returns an empty string.
    def add(type, options = None)
      if None == options
        execute(:add, type)
      else
        execute(:add, type, options.to_tcl_options)
      end
    end

    # Makes a clone of the current menu named newPathName.
    # This clone is a menu in its own right, but any changes to the clone are
    # propagated to the original menu and vice versa.
    # cloneType can be normal, menubar, or tearoff.
    # Should not normally be called outside of the Tk library.
    # See the CLONES section for more information.
    def clone(newPathname, cloneType = None)
      execute(:clone, newPathname, cloneType)
    end

    # Delete all of the menu entries between index1 and index2 inclusive.
    # If index2 is omitted then it defaults to index1.
    # Attempts to delete a tear-off menu entry are ignored (instead, you should
    # change the tearOff option to remove the tear-off entry).
    def delete(index1, index2 = None)
      execute(:delete, index1, index2)
    end

    # Returns the current value of a configuration option for the entry given
    # by index.
    # Option may have any of the values accepted by the add widget command.
    def entrycget(index, option)
      execute(:entrycget, index, option)
    end

    # This command is similar to the configure command, except that it applies
    # to the options for an individual entry, whereas configure applies to the
    # options for the menu as a whole.
    # Options may have any of the values accepted by the add widget command.
    # If options are specified, options are modified as indicated in the
    # command and the command returns an empty string.
    # If no options are specified, returns a list describing the current
    # options for entry index (see Tk_ConfigureInfo for information on the
    # format of this list).
    def entryconfigure(index, options = None)
      common_configure(:entryconfigure, index, options)
    end

    # Returns the numerical index corresponding to index, or none if index was
    # specified as none.
    def index(index)
      execute(:index, index)
    end

    # Same as the add widget command except that it inserts the new entry just
    # before the entry given by index, instead of appending to the end of the
    # menu. The type, option, and value arguments have the same interpretation
    # as for the add widget command.
    # It is not possible to insert new menu entries before the tear-off entry,
    # if the menu has one.
    def insert(index, type, options = None)
      if None == options
        execute(:insert, index, type)
      else
        execute(:insert, index, type, options.to_tcl_options)
      end
    end

    # Invoke the action of the menu entry.
    # See the sections on the individual entries above for details on what
    # happens. If the menu entry is disabled then nothing happens.
    # If the entry has a command associated with it then the result of that
    # command is returned as the result of the invoke widget command.
    # Otherwise the result is an empty string.
    # Note: invoking a menu entry does not automatically unpost the menu; the
    # default bindings normally take care of this before invoking the invoke
    # widget command.
    def invoke(index)
      execute(:invoke, index)
    end

    # Arrange for the menu to be displayed on the screen at the root-window
    # coordinates given by x and y.
    # These coordinates are adjusted if necessary to guarantee that the entire
    # menu is visible on the screen.
    # This command normally returns an empty string.
    # If the postCommand option has been specified, then its value is executed
    # as a Tcl script before posting the menu and the result of that script is
    # returned as the result of the post widget command.
    # If an error returns while executing the command, then the error is
    # returned without posting the menu.
    def post(x, y)
      execute(:post, x, y).to_s?
    end

    # Posts the submenu associated with the cascade entry given by index, and
    # unposts any previously posted submenu.
    # If index does not correspond to a cascade entry, or if pathName is not
    # posted, the command has no effect except to unpost any currently posted
    # submenu.
    def postcascade(index)
      execute(:postcascade, index)
    end

    # Returns the type of the menu entry given by index.
    # This is the type argument passed to the add widget command when the entry
    # was created, such as command or separator, or tearoff for a tear- off
    # entry.
    def type(index)
      execute(:type, index)
    end

    # Unmap the window so that it is no longer displayed.
    # If a lower-level cascaded menu is posted, unpost that menu.
    # Returns an empty string.
    # This subcommand does not work on Windows and the Mac‐ intosh, as those
    # platforms have their own way of unposting menus.
    def unpost
      execute(:unpost)
    end

    # Returns a decimal string giving the x-coordinate within the menu window
    # of the leftmost pixel in the entry specified by index.
    # │
    def xposition(index)
      execute(:xposition, index)
    end

    # Returns a decimal string giving the y-coordinate within the menu window
    # of the topmost pixel in the entry specified by index.
    # This is the most common case.
    # You create a menu widget that will become the menu bar.
    # You then add cascade entries to this menu, specifying the pull down menus
    # you wish to use in your menu bar.
    # You then create all of the pulldowns.
    # Once you have done this, specify the menu using the -menu option of the
    # toplevel's widget command.
    # See the toplevel manual entry for details.
    # This is the compatible way to do menu bars.
    # You create one menubutton widget for each top-level menu, and typically
    # you arrange a series of menubuttons in a row in a menubar window.
    # You also create the top-level menus and any cascaded submenus, and tie
    # them together with -menu options in menubuttons and cascade menu entries.
    # The top-level menu must be a child of the menubutton, and each submenu
    # must be a child of the menu that refers to it.
    # Once you have done this, the default bindings will allow users to
    # traverse and invoke the tree of menus via its menubutton; see the
    # menubutton manual entry for details.
    # Popup menus typically post in response to a mouse button press or
    # keystroke. You create the popup menus and any cascaded submenus, then you
    # call the tk_popup procedure at the appropriate time to post the top-level
    # menu. An option menu consists of a menubutton with an associated menu
    # that allows you to select one of several values.
    # The current value is displayed in the menubutton and is also stored in a
    # global variable.
    # Use the tk_optionMenu procedure to create option menubuttons and their
    # menus. You create a torn-off menu by invoking the tear-off entry at the
    # top of an existing menu.
    # The default bindings will create a new menu that is a copy of the
    # original menu and leave it perma‐ nently posted as a top-level window.
    # The torn-off menu behaves just the same as the original menu.
    # and unposts the menu.
    # If the current menu is a top-level menu posted from a menubutton, then
    # the current menubutton is unposted and the next menubutton to the left is
    # posted. Otherwise the key has no effect.
    # The left-right order of menubuttons is determined by their stacking
    # order: Tk assumes that the lowest menubutton (which by default is the
    # first one created) is on the left.
    # Otherwise, if the current menu was posted from a menubutton, then the
    # current menubutton is unposted and the next menubutton to the right is
    # posted.
    def yposition(index)
      execute(:yposition, index)
    end
  end
end