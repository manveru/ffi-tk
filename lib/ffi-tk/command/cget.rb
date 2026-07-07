# frozen_string_literal: true

module Tk
  # Read a widget's configuration option and coerce it to a Ruby value.
  # Backs the shared `cget` command.
  module Cget
    OPTIONS_BY_TYPE = {
      integer: %w[
        height width maxundo spacing1 spacing2 spacing3 borderwidth bd
        highlightthickness insertborderwidth insertofftime insertontime
        insertwidth padx pady selectborderwidth endline startline length
        maximum
      ],
      boolean: %w[
        autoseparators blockcursor undo exportselection setgrid takefocus
      ],
      color: %w[
        inactiveselectbackground disabledbackground disabledforeground background
        bg foreground fg highlightbackground highlightcolor insertbackground
        selectbackground selectforeground readonlybackground
      ],
      command: %w[
        invalidcommand invcmd yscrollcommand xscrollcommand validatecommand
        command vcmd
      ],
      string: %w[tabs cursor text show default class],
      font: %w[font],
      symbol: %w[wrap tabstyle relief justify validate orient mode selectmode],
      variable: %w[textvariable],
      bitmap: %w[stipple],
      list: %w[padding state style columns displaycolumns]
    }.freeze

    CGET_MAP = OPTIONS_BY_TYPE.each_with_object({}) do |(type, options), map|
      options.each { |option| map["-#{option}"] = type }
    end.freeze

    # Read one option's value and coerce it to Ruby. When the receiver's class
    # has a declared Option schema, coercion is type-directed from the raw Tcl
    # string (immune to shimmering); otherwise the legacy CGET_MAP path runs
    # (transition rule — removed once every widget has a schema).
    def cget(option)
      if (schema = self.class.option_schema)
        Option::Coercer.coerce(schema.type_for(option), execute_string('cget', option.to_tcl_option))
      else
        tcl = option.to_tcl_option
        Cget.option_to_ruby(tcl, execute('cget', tcl))
      end
    end

    module_function

    def option_to_ruby(name, value)
      raise format('Unknown type for %p: %p', name, value) unless (type = CGET_MAP[name.to_tcl_option])

      type_to_ruby(type, value)
    end

    def type_to_ruby(type, value)
      case type
      when :integer
        value.respond_to?(:to_i?) ? value.to_i? : value.to_i
      when :symbol
        value&.to_sym
      when :boolean
        Tk.boolean(value)
      when :color, :string, :font, :bitmap
        value.respond_to?(:to_s?) ? value.to_s? : value
      when :variable
        Variable.new(value.to_s?) if value.respond_to?(:to_s?)
      when :list
        list_to_ruby(value)
      when :float
        value.to_f
      when :pathname
        Tk.pathname_to_widget(value.to_s)
      when :command
        string = value.to_s
        string unless string.empty?
      else
        raise format('Unknown type: %p: %p', type, value)
      end
    end

    # List options (padding, columns, ...) are string-valued in Tk (they may
    # hold screen distances like "2m"). EvalResult.to_list type-guesses each
    # element from Tcl's cached obj type, so "10" comes back as 10 or "10"
    # depending on shimmering. Pin the contract to strings.
    def list_to_ruby(value)
      list =
        case value
        when Array then value
        when String then value.split
        else value.to_a
        end
      list.map(&:to_s)
    end
  end
end
