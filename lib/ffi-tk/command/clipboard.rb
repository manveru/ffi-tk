module Tk
  # Manipulate Tk clipboard
  #
  # This command provides an interface to the Tk clipboard, which stores data
  # for later retrieval.
  # In order to copy data into the clipboard, [Clipboard.clear] must be called,
  # followed by a sequence of one or more calls to [Clipboard.append].
  # To ensure that the clipboard is updated atomically, all appends should be
  # completed before returning to the event loop.
  module Clipboard
    def clipboard_clear
      Clipboard.clear(self)
    end

    def clipboard_append(options = {})
      Clipboard.append({displayof: self}.merge(options))
    end

    def clipboard_get(type = None)
      Clipboard.get(self, type)
    end

    module_function

    # Claims ownership of the clipboard on window's display and removes any
    # previous contents.
    # Window defaults to ".".
    def clear(window = None)
      Tk.execute_only(:clipboard, :clear, window)
    end

    # Appends data to the clipboard on window's display in the form given by
    # type with the representation given by format and claims ownership of the
    # clipboard on window's display.
    # Type specifies the form in which the selection is to be returned (the
    # desired âtargetâ for conversion, in ICCCM terminology), and should be
    # an atom name such as STRING or FILE_NAME; see the Inter-Client
    # Communication Conventions Manual for complete details.
    # Type defaults to STRING.
    # The format argument specifies the representation that should be used to
    # transmit the selection to the requester (the second column of Table 2 of
    # the ICCCM), and defaults to STRING.
    # If format is STRING, the selection is transmitted as 8-bit ASCII
    # characters. If format is ATOM, then the data is divided into fields
    # separated by white space; each field is converted to its atom value, and
    # the 32-bit atom value is transmitted instead of the atom name.
    # For any other format, data is divided into fields separated by white space
    # and each field is converted to a 32-bit integer; an array of integers is
    # transmitted to the selection requester.
    # Note that strings passed to clipboard append are concatenated before
    # conversion, so the caller must take care to ensure appropriate spacing
    # across string boundaries.
    # All items appended to the clipboard with the same type must have the same
    # format. The format argument is needed only for compatibility with
    # clipboard requesters that do not use Tk.
    # If the Tk toolkit is being used to retrieve the CLIPBOARD selection then
    # the value is converted back to a string at the requesting end, so format
    # is irrelevant.
    def append(options = {})
      args = []

      displayof, format, type, data =
        options.values_at(:displayof, :format, :type, :data)

      displayof = displayof.to_tcl if displayof.respond_to?(:to_tcl)
      format = format.to_s.upcase if format

      args << "-displayof" << displayof if displayof
      args << "-format" << format.to_s.upcase" if format
      args << "-type" << type.to_s.upcase if type
      args << "--" << data.to_s

      Tk.execute_only(:clipboard, :append, *args)
    end

    # Retrieve data from the clipboard on window's display.
    # Window defaults to ".".
    # Type specifies the form in which the data is to be returned and should be
    # an atom name such as STRING or FILE_NAME.
    # Type defaults to STRING.
    # This is equivalent to [Selection.get(selection: :clipboard).
    def get(window = None, type = None)
      type = type.to_s.upcase unless type == None
      Tk.execute(:clipboard, :get, window, type)
    end
  end
end