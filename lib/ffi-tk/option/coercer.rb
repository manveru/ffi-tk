# frozen_string_literal: true

module Tk
  module Option
    # The one type-directed Tcl-string -> Ruby-value converter.
    #
    # Coercion reads the option's *raw* Tcl string (never EvalResult.guess), so
    # it is immune to Tcl shimmering. It applies the empty-value rule: an empty
    # raw value becomes the type's empty instance where one exists (:string ->
    # "", :list -> []) and nil otherwise, so nil always means "absent / no value
    # / no object bound", never a flattened empty string.
    module Coercer
      module_function

      # Coerce +raw+ (a raw Tcl string) to Ruby according to the Option +type+.
      # Raises Tk::UnknownOptionType for a type outside the closed vocabulary.
      # One exhaustive switch over the 12-type vocabulary by design.
      def coerce(type, raw) # rubocop:disable Metrics/CyclomaticComplexity
        string = raw.to_s
        empty = string.empty?

        case type
        when :string   then string
        when :list     then empty ? [] : split_list(string)
        when :integer  then empty ? nil : Integer(string)
        when :float    then empty ? nil : Float(string)
        when :symbol   then empty ? nil : string.to_sym
        when :boolean  then empty ? nil : Tk.boolean(string)
        when :color, :font, :bitmap, :command
          empty ? nil : string
        when :variable then empty ? nil : Tk::Variable.new(string)
        when :pathname then empty ? nil : Tk.pathname_to_widget(string)
        else
          raise Tk::UnknownOptionType, format('no coercion for option type %p', type)
        end
      end

      # Split a raw Tcl list into its String elements using a real Tcl list
      # parse (build a string obj and reuse EvalResult.map_list_core), so an
      # unbalanced list raises loudly rather than silently mangling. Elements
      # stay strings; the caller decides any further typing.
      def split_list(raw)
        # Touch the interpreter first: the FFI::Tcl.* wrappers (new_string_obj,
        # ...) are only defined once Tk.init has run, and Tk.interp triggers it.
        interp = Tk.interp
        obj = FFI::Tcl.new_string_obj(raw, raw.bytesize)
        FFI::Tcl::EvalResult.map_list_core(interp, obj) do |pointer|
          FFI::Tcl::EvalResult.to_string(interp, pointer)
        end
      end
    end
  end
end
