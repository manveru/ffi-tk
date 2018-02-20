# frozen_string_literal: true
module Tk
  # Create and inspect fonts.
  # The font command provides several facilities for dealing with fonts, such as
  # defining named fonts and inspecting the actual attributes of a font.
  class Font
    def initialize(string_or_hash)
      if string_or_hash.respond_to?(:to_str)
        string_or_hash =~ /^(.*)\s+(\d+)?$/

        params = {}
        params[:family] = Regexp.last_match(1).to_s
        params[:size] = Regexp.last_match(2).to_i if Regexp.last_match(2)

        @font = Font.create(params)
      elsif string_or_hash.respond_to?(:to_hash)
        @font = Font.create(string_or_hash)
      else
        raise ArgumentError
      end
    end

    def actual(options = {})
      Font.actual(@font, options)
    end

    def actual_hash(options = {})
      Font.actual(@font, options)
    end

    def measure(text, options = {})
      Font.measure(@font, text, options)
    end

    def metrics(option, options = {})
      Font.metrics(@font, option, options)
    end

    def configure(argument = None)
      Font.configure(@font, argument)
    end

    def to_tcl
      TclString.new(@font)
    end

    FONT_CONFIGURE_HINTS = {
      underline:  :boolean,
      overstrike: :boolean,
      weight:     :symbol,
      slant:      :symbol
    }.freeze

    def self.execute(command, *args)
      Tk.execute(:font, command, *args)
    end

    def self.execute_only(command, *args)
      Tk.execute_only(:font, command, *args)
    end

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
    def self.actual(font, options = {})
      window = options.fetch(:displayof, None)
      option = options.fetch(:option, None)
      char = options.fetch(:char, None)

      args = []
      args << '-displayof' << window unless window == None
      args << option.to_tcl_option unless option == None
      args << '--' << char.to_tcl unless char == None

      array = execute(:actual, font, *args)
      array.tcl_options_to_hash(FONT_CONFIGURE_HINTS)
    end

    def self.configure(fontname, argument = None)
      Configure.common(
        self, [:configure, fontname], argument, FONT_CONFIGURE_HINTS
      )
    end

    def self.create(fontname, options = None)
      if fontname.respond_to?(:to_tcl_options)
        options = fontname
        fontname = None
        options = options.to_tcl_options
      end

      execute(:create, fontname, options)&.to_str
    end

    def self.delete(*fontnames)
      execute(:delete, *fontnames)
    end

    # The return value is a list of the case-insensitive names of all font
    # families that exist on window's display.
    # If the window argument is omitted, it defaults to the main window.
    def self.families(options = {})
      execute(:families, options.to_tcl_options)
    end

    def self.measure(font, text, options = {})
      execute(:measure, font, options.to_tcl_options, text)
    end

    def self.metrics(font, option, options = {})
      execute(:metrics, font, options.to_tcl_options, option.to_tcl_option)
    end

    # The return value is a list of all the named fonts that are currently
    # defined.
    def self.names
      execute(:names).to_a
    end
  end
end
