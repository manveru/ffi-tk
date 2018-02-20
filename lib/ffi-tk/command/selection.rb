# frozen_string_literal: true
module Tk
  # This command provides a Tcl interface to the X selection mechanism and
  # implements the full selection functionality described in the X Inter-Client
  # Communication Conventions Manual (ICCCM).
  #
  # Note that for management of the CLIPBOARD selection (see below), the
  # clipboard command may also be used.
  module Selection
    def selection_clear(options = {})
      Selection.clear({ displayof: self }.merge(options))
    end

    def selection_get(options = {})
      Selection.get({ displayof: self }.merge(options))
    end

    def selection_handle(options = {}, &command)
      Selection.handle(self, options, &command)
    end

    def selection_own(options, &command)
      Selection.own(self, options, &command)
    end

    module_function

    # If selection exists anywhere on window's display, clear it so that no
    # window owns the selection anymore.
    # Selection specifies the X selection that should be cleared, and should be
    # an atom name such as PRIMARY or CLIPBOARD; see the Inter-Client
    # Communication Conventions Manual for complete details.
    # Selection defaults to PRIMARY and window defaults to ".".
    def clear(options = {})
      Tk.execute_only(:selection, :clear, options.to_tcl_options)
    end

    # Retrieves the value of selection from window's display and returns it as a
    # result. Selection defaults to PRIMARY and window defaults to ".".
    # Type specifies the form in which the selection is to be returned (the
    # desired "target" for conversion, in ICCCM terminology), and should be
    # an atom name such as STRING or FILE_NAME; see the Inter-Client
    # Communication Conventions Manual for complete details.
    # Type defaults to STRING.
    # The selection owner may choose to return the selection in any of several
    # different representation formats, such as STRING, UTF8_STRING, ATOM,
    # INTEGER, etc.
    # (this format is different than the selection type; see the ICCCM for all
    # the confusing details).
    # If the selection is returned in a non-string format, such as INTEGER or
    # ATOM, the selection command converts it to string format as a collection
    # of fields separated by spaces: atoms are converted to their textual names,
    # and anything else is converted to hexadecimal integers.
    # Note that selection get does not retrieve the selection in the UTF8_STRING
    # format unless told to.
    def get(options = {})
      Tk.execute(:selection, :get, options.to_tcl_options).to_s
    end

    # Creates a handler for selection requests, such that command will be
    # executed whenever selection s is owned by window and someone attempts to
    # retrieve it in the form given by type t (e.g.
    # t is specified in the selection get command).
    # S defaults to PRIMARY, t defaults to STRING, and f defaults to STRING.
    # If command is an empty string then any existing handler for window, t, and
    # s is removed.
    # Note that when the selection is handled as type STRING it is also
    # automatically handled as type UTF8_STRING as well.
    #
    # When selection is requested, window is the selection owner, and type is
    # the requested type, command will be executed as a Tcl command with two
    # additional numbers appended to it (with space separators).
    # The two additional numbers are offset and maxChars: offset specifies a
    # starting character position in the selection and maxChars gives the
    # maximum number of characters to retrieve.
    # The command should return a value consisting of at most maxChars of the
    # selection, starting at position offset.
    # For very large selections (larger than maxChars) the selection will be
    # retrieved using several invocations of command with increasing offset
    # values. If command returns a string whose length is less than maxChars,
    # the return value is assumed to include all of the remainder of the
    # selection; if the length of command's result is equal to maxChars then
    # command will be invoked again, until it eventually returns a result
    # shorter than maxChars.
    # The value of maxChars will always be relatively large (thousands of
    # characters). If command returns an error then the selection retrieval is
    # rejected just as if the selection did not exist at all.
    # The format argument specifies the representation that should be used to
    # transmit the selection to the requester (the second column of Table 2 of
    # the ICCCM), and defaults to STRING.
    #
    # If format is STRING, the selection is transmitted as 8-bit ASCII
    # characters (i.e. just in the form returned by command, in the system
    # encoding; the UTF8_STRING format always uses UTF-8 as its encoding).
    #
    # If format is ATOM, then the return value from command is divided into
    # fields separated by white space; each field is converted to its atom
    # value, and the 32-bit atom value is transmitted instead of the atom name.
    # For any other format, the return value from command is divided into fields
    # separated by white space and each field is converted to a 32-bit integer;
    # an array of integers is transmitted to the selection requester.
    #
    # The format argument is needed only for compatibility with selection
    # requesters that do not use Tk.
    # If Tk is being used to retrieve the selection then the value is converted
    # back to a string at the requesting end, so format is irrelevant.
    def handle(window, options = {}, &command)
      command = register_command(:selection_handle, &command)
      Tk.execute_only(options.to_tcl_options, window, command)
    end

    # The first form of selection own returns the path name of the window in
    # this application that owns selection on the display containing window, or
    # an empty string if no window in this application owns the selection.
    # Selection defaults to PRIMARY and window defaults to ".".
    def own(window = None, options = {}, &command)
      if window == None
        Tk.execute(:selection, :own)
      elsif window.is_a?(Hash)
        options = window

        if cmd = (options[:command] || command)
          command = register_command(:selection_own, &cmd)
          Tk.execute(:selection, :own, { command: command }.merge(options).to_tcl_options)
        else
          Tk.execute(:selection, :own, options.to_tcl_options)
        end
      else
        Tk.execute(:selection, :own, options.to_tcl_options, window)
      end
    end
  end
end
