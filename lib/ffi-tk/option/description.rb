# frozen_string_literal: true

module Tk
  # The faithful representation of what Tk's `configure` reports for one option.
  #
  # The normal form carries the current +value+ plus the option's +default+ and
  # its resource-database +db_name+/+db_class+ (Tk's {-x dbName dbClass default
  # current} describe-tuple). +value+ and +default+ are coerced to Ruby; the
  # identifiers stay strings/symbols.
  #
  # The synonym form (Tk's 2-element {-x -canonical} describe-tuple for an alias)
  # carries only +name+ and +synonym_for+; every other field is nil.
  OptionDescription = ::Struct.new(:name, :db_name, :db_class, :default, :value, :synonym_for) do
    # True for the synonym form (an alias pointing at its canonical option).
    def synonym?
      !synonym_for.nil?
    end
  end
end
