module Tk
  # Create and inspect fonts.
  # The font command provides several facilities for dealing with fonts, such as
  # defining named fonts and inspecting the actual attributes of a font.
  module Font
    FONT_CONFIGURE_HINTS = {
      underline:  :boolean,
      overstrike: :boolean,
      weight:     :symbol,
      slant:      :symbol,
    }

    module_function

    # NOTE:
    #   the signature has been simplified to a required +font+ argument and a
    #   simple +options+ hash.
    #   The original signature is:
    #     `font actual font ?-displayof window? ?option? ?--? ?char?`
    #   But it just makes things very painful.
    # @options
    #  :displayof window
    #  :char char
    #  :option name
    def actual(font, options = {})
      window = options.fetch(:displayof, None)
      option = options.fetch(:option, None)
      char = options.fetch(:char, None)

      args = []
      args << "-displayof" << window unless window == None
      args << option.to_tcl_option unless option == None
      args << "--" << char.to_tcl unless char == None

      array = Tk.execute(:font, :actual, font, *args)
      array.tcl_options_to_hash(FONT_CONFIGURE_HINTS)
    end

    def configure(fontname, *arguments)
      if arguments.empty?
        array = Tk.execute(:font, :configure, fontname)
        array.tcl_options_to_hash(FONT_CONFIGURE_HINTS)
      elsif arguments.size == 1 && arguments.first.respond_to?(:to_hash)
        argument = arguments.first.to_hash
        Tk.execute_only(:font, :configure, fontname, argument.to_tcl_options)
      elsif arguments.size == 1
        option = arguments.first.to_tcl_option
        Tk.execute(:font, :configure, fontname, option)
      else
        raise ArgumentError, "Invalid arguments: %p" % [arguments]
      end
    end

    def create(fontname, options = {})
      Tk.execute(:font, :create, fontname, options.to_tcl_options)
    end

    def delete(*fontnames)
      Tk.execute(:font, :delete, *fontnames)
    end

    # The return value is a list of the case-insensitive names of all font
    # families that exist on window's display.
    # If the window argument is omitted, it defaults to the main window.
    def families(options = {})
      Tk.execute(:font, :families, options.to_tcl_options)
    end

    def measure(font, text, options = {})
      Tk.execute(:font, :measure, font, options.to_tcl_options, text)
    end

    def metrics(font, option, options = {})
      Tk.execute(:font, :metrics, font, options.to_tcl_options, option.to_tcl_option)
    end

    # The return value is a list of all the named fonts that are currently
    # defined.
    def names
      Tk.execute(:font, :names).to_a
    end
  end
end