# frozen_string_literal: true

module Tk
  # Read a widget's configuration option and coerce it to a Ruby value.
  # Backs the shared `cget` command.
  module Cget
    # Read one option's value and coerce it to Ruby. Coercion is type-directed
    # from the raw Tcl string (never EvalResult.guess), so it is immune to Tcl
    # shimmering; the receiver's declared Option schema supplies the type.
    def cget(option)
      schema = self.class.option_schema
      Option::Coercer.coerce(schema.type_for(option), execute_string('cget', option.to_tcl_option))
    end
  end
end
