# frozen_string_literal: true

module Tk
  # Raised when an option has no declared Option type (coercion cannot proceed
  # without one). Loud and specific, per the fail-fast contract.
  UnknownOptionType = Class.new(Error)

  module Option
    # The mapping from an Option name to its Option type, for a specific widget.
    #
    # A frozen value object holding two flat tables: +types+ ({canonical name =>
    # type}) and +aliases+ ({alias => canonical name}). Lookup never traverses a
    # Ruby class hierarchy: composition across the standard and widget-specific
    # sets is done explicitly through #merge, and an undeclared option raises
    # rather than falling back to any ancestor.
    #
    # Names are normalised to dashless Symbols (+:background+, +:bg+), so a
    # schema keyed either way answers to `:bg`, `'bg'`, `:-bg`, `'-bg'` alike.
    class Schema
      attr_reader :types, :aliases

      # Normalise an option name to a dashless Symbol.
      def self.normalize(name)
        name.to_s.sub(/\A-/, '').to_sym
      end

      def initialize(types: {}, aliases: {})
        @types = normalize_types(types).freeze
        @aliases = normalize_aliases(aliases).freeze
        freeze
      end

      # The Option type for +name+, following an alias to its canonical option.
      # Raises Tk::UnknownOptionType when the option is not declared here.
      def type_for(name)
        key = canonical(name)
        @types.fetch(key) do
          raise Tk::UnknownOptionType, format('undeclared option %p', name)
        end
      end

      # The canonical option name for +name+ (itself when it is not an alias).
      # Pure alias resolution; it does not assert the option exists.
      def canonical(name)
        key = self.class.normalize(name)
        @aliases.fetch(key, key)
      end

      # Every declared name, canonical options and aliases alike.
      def names
        @types.keys + @aliases.keys
      end

      # A new Schema composing this one with +other+; +other+ wins on collision
      # (widget-specific options override the standard set they share a name
      # with, e.g. spinbox's :boolean `-wrap` over a `:symbol` one).
      def merge(other)
        self.class.new(
          types: @types.merge(other.types),
          aliases: @aliases.merge(other.aliases)
        )
      end

      def ==(other)
        other.is_a?(self.class) && types == other.types && aliases == other.aliases
      end
      alias eql? ==

      def hash
        [self.class, @types, @aliases].hash
      end

      private

      def normalize_types(types)
        types.transform_keys { |name| self.class.normalize(name) }
      end

      def normalize_aliases(aliases)
        aliases.each_with_object({}) do |(name, canonical), out|
          out[self.class.normalize(name)] = self.class.normalize(canonical)
        end
      end
    end

    # The neutral element for Schema#merge (a schema declaring nothing).
    Schema::EMPTY = Schema.new
  end
end
