# frozen_string_literal: true

module Tk
  # Already converted statement, don't process again
  class TclString < String
    def to_tcl
      self
    end
  end

  # A lot of conversion helpers...

  # Ruby core-class extensions for converting to and from Tcl values.
  module CoreExtensions
    # Tcl conversion helpers for Array (to_tcl, option-hash coercion).
    module Array
      def to_tcl
        TclString.new("{#{map(&:to_tcl).compact.join(' ')}}")
      end
    end

    # Tcl conversion helpers for Hash (option lists).
    module Hash
      def to_tcl
        pairs = map { |key, val| "#{key.to_tcl} #{val.to_tcl}" }
        TclString.new(pairs.join(' '))
      end

      def to_tcl_options
        pairs = map { |key, val| "#{key.to_tcl_option} #{val.to_tcl}" }
        TclString.new(pairs.join(' '))
      end
      alias to_tcl_options? to_tcl_options
    end

    # Tcl conversion helpers for Proc (callback registration).
    module Proc
      def to_tcl
        @id, @command = Tk.register_proc(self)
        @command.to_tcl
      end
    end

    # Tcl conversion helpers for Regexp.
    module Regexp
      def to_tcl
        embed = []
        embed << 'i' if options & ::Regexp::IGNORECASE != 0
        embed << 'x' if options & ::Regexp::EXTENDED != 0
        embed << 'n' if options & ::Regexp::MULTILINE != 0

        pattern = if embed.empty?
                    source
                  else
                    "(?#{embed.join})#{source}"
                  end

        TclString.new(%({#{pattern.gsub(/([^\\])(?=[{}])/, '\1\\\\\2')}}))
      end
    end

    # Tcl conversion helpers for String (quoting and escaping).
    module String
      def to_tcl
        TclString.new(%("#{gsub(/[\[\]{}$"\\]/, '\\\\\&')}"))
      end

      def to_tcl_option
        TclString.new(sub(/\A(?=[^-])/, '-'))
      end
    end

    # Tcl conversion helpers for Symbol (option names).
    module Symbol
      def to_tcl
        TclString.new(to_s.dump)
      end

      def to_tcl_option
        TclString.new(to_s.sub(/\A(?=[^-])/, '-'))
      end
    end

    # Tcl conversion helpers for Numeric.
    module Numeric
      def to_tcl
        TclString.new(to_s)
      end
    end

    # Tcl conversion helpers for Integer.
    module Integer
      def to_boolean
        Tk.boolean(self)
      end
    end

    # Tcl conversion helper for true (renders as 1).
    module TrueClass
      def to_tcl
        TclString.new('1')
      end
    end

    # Tcl conversion helper for false (renders as 0).
    module FalseClass
      def to_tcl
        TclString.new('0')
      end
    end

    # Tcl conversion helper for nil (renders as an empty string).
    module NilClass
      def to_tcl
        TclString.new('""')
      end
    end

    constants.each do |const|
      ext = const_get(const)
      into = Module.const_get(const)

      collisions = ext.instance_methods & into.instance_methods

      if collisions.empty?
        into.__send__(:include, ext)
      elsif $DEBUG
        warn format("Won't include %p with %p, %p exists", into, ext, collisions)
      end
    end
  end
end
