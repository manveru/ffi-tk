module Tk
  class PanedWindow < Widget
    include Cget, Configure

    def self.tk_command; 'panedwindow'; end

    # Add one or more windows to the panedwindow, each in a separate pane.
    # The arguments consist of the names of one or more windows followed by
    # pairs of arguments that specify how to manage the windows.
    # Option may have any of the values accepted by the configure subcommand.
    def add(window, *arguments)
      options, windows = arguments.partition{|arg| arg.respond_to?(:to_tcl_options) }

      if option = options.first
        execute(:add, window, *windows, option.to_tcl_options)
      else
        execute(:add, window, *windows)
      end
    end

    # Remove the pane containing window from the panedwindow.
    # All geometry management options for window will be forgotten.
    def forget(window, *windows)
      execute_only(:forget, window, *windows)
    end

    # Identify the panedwindow component underneath the point given by x and y,
    # in window coordinates.
    # If the point is over a sash or a sash handle, the result is a two element
    # list containing the index of the sash or handle, and a word indicating
    # whether it is over a sash or a handle, such as {0 sash} or {2 handle}.
    # If the point is over any other part of the panedwindow, the result is an
    # empty list.
    def identify(x, y)
      execute(:identify, x, y)
    end

    # Return a list containing the x and y coordinates of the most recent proxy
    # location.
    def proxy_coord
      execute(:proxy, :coord).to_a
    end

    # Remove the proxy from the display.
    def proxy_forget
      execute(:proxy, :forget)
    end

    # Place the proxy at the given x and y coordinates.
    def proxy_place(x, y)
      execute(:proxy, :place, x, y)
    end

    # Return the current x and y coordinate pair for the sash given by index.
    # Index must be an integer between 0 and 1 less than the number of panes in
    # the panedwindow.
    # The coordinates given are those of the top left corner of the region
    # containing the sash.
    def sash_coord(index)
      execute(:sash, :coord, index)
    end

    # This command computes the difference between the given coordinates and
    # the coordinates given to the last sash mark command for the given sash.
    # It then moves that sash the computed dif‐ ference.
    def sash_dragto(index, x, y)
      execute_only(:sash, :dragto, index, x, y)
    end

    # Records x and y for the sash given by index; used in conjunction with
    # later sash dragto commands to move the sash.
    def sash_mark(index, x, y)
      execute(:sash, :mark, index, x, y)
    end

    # Place the sash given by index at the given coordinates.
    def sash_place(index, x, y)
      execute(:sash, :place, index, x, y)
    end

    # Query a management option for window.
    # Option may be any value allowed by the paneconfigure subcommand.
    def panecget(window, option)
      execute(:panecget, window, option.to_tcl_option)
    end

    # Query or modify the management options for window.
    # If no option is specified, returns a list describing all of the available
    # options for pathName (see Tk_ConfigureInfo for information on the format
    # of this list).
    # If option is specified with no value, then the command returns a list
    # describing the one named option (this list will be identical to the
    # corresponding sublist of the value returned if no option is specified).
    # If one or more option-value pairs are specified, then the command
    # modifies the given widget option(s) to have the given value(s); in this
    # case the command returns an empty string.
    # The following options are supported: -after window Insert the window
    # after the window specified.
    # window should be the name of a window already managed by pathName.
    # -before window Insert the window before the window specified.
    # window should be the name of a window already managed by pathName.
    # -height size Specify a height for the window.
    # The height will be the outer dimension of the window including its
    # border, if any.
    # If size is an empty string, or if -height is not specified, then the
    # height requested internally by the window will be used initially; the
    # height may later be adjusted by the movement of sashes in the
    # panedwindow. Size may be any value accepted by Tk_GetPixels.
    # -hide boolean Controls the visibility of a pane.
    # When the boolean is true (according to Tcl_GetBoolean) the pane will not
    # be visible, but it will still be maintained in the list of panes.
    # │ -minsize n Specifies that the size of the window cannot be made less
    # than n.
    # This constraint only affects the size of the widget in the paned
    # dimension — the x dimension for horizontal panedwin‐ dows, the y
    # dimension for vertical panedwindows.
    # May be any value accepted by Tk_GetPixels.
    # -padx n Specifies a non-negative value indicating how much extra space to
    # leave on each side of the window in the X-direction.
    # The value may have any of the forms accepted by Tk_GetPixels.
    # -pady n Specifies a non-negative value indicating how much extra space to
    # leave on each side of the window in the Y-direction.
    # The value may have any of the forms accepted by Tk_GetPixels.
    # -sticky style If a window's pane is larger than the requested dimensions
    # of the window, this option may be used to position (or stretch) the
    # window within its pane.
    # Style is a string that contains zero or more of the characters n, s, e or
    # w. The string can optionally contains spaces or commas, but they are
    # ignored. Each letter refers to a side (north, south, east, or west) that
    # the window will “stick” to.
    # If both n and s (or e and w) are specified, the window will be stretched
    # to fill the entire height (or width) of its cavity.
    # -stretch when Controls how extra space is allocated to each of the panes.
    # When is one of always, first, last, middle, and never.
    # The panedwindow will calculate the required size of all its panes.
    # │ Any remaining (or deficit) space will be distributed to those panes
    # marked for stretching.
    # The space will be distributed based on each panes current ratio of the
    # whole. The when values │ have the following definition: │ always │ This
    # pane will always stretch.
    # │ first │ Only if this pane is the first pane (left-most or top-most)
    # will it stretch.
    # │ last │ Only if this pane is the last pane (right-most or bottom-most)
    # will it stretch.
    # This is the default value.
    # │ middle │ Only if this pane is not the first or last pane will it
    # stretch. │ never │ This pane will never stretch.
    # │ -width size Specify a width for the window.
    # The width will be the outer dimension of the window including its border,
    # if any.
    # If size is an empty string, or if -width is not specified, then the width
    # requested internally by the window will be used initially; the width may
    # later be adjusted by the movement of sashes in the panedwindow.
    # Size may be any value accepted by Tk_Get‐ Pixels.
    def paneconfigure(window, options = None)
      common_configure([:paneconfigure, window], options)
    end

    # Returns an ordered list of the widgets managed by pathName.
    def panes
      execute(:panes).to_a
    end
  end
end
