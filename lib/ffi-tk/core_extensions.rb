module Tk
  # Already converted statement, don't process again
  class TclString < String
    def to_tcl
      self
    end
  end

  # A lot of conversion helpers...

  module CoreExtensions
    module Array
      def to_tcl
        TclString.new('{' << map(&:to_tcl).compact.join(' ') << '}')
      end

      def tcl_options_to_hash(hints = {})
        ::Hash[each_slice(2).map{|key, value|
          key = key.sub(/^-/, '').to_sym

          case hint = hints[key]
          when :boolean
            [key, Tk.boolean(value)]
          when :symbol
            [key, value.to_sym]
          when :float
            [key, Float(value)]
          else
            [key, value]
          end
        }]
      end
    end

    module Hash
      def to_tcl
        pairs = map{|key, val| "#{key.to_tcl} #{val.to_tcl}" }
        TclString.new(pairs.join(' '))
      end

      def to_tcl_options
        pairs = map{|key, val| "#{key.to_tcl_option} #{val.to_tcl}" }
        TclString.new(pairs.join(' '))
      end
      alias to_tcl_options? to_tcl_options
    end

    module Proc
      def to_tcl
        @id, @command = Tk.register_proc(self)
        @command.to_tcl
      end
    end

    module Regexp
      def to_tcl
        embed = []
        embed << 'i' if options & ::Regexp::IGNORECASE != 0
        embed << 'x' if options & ::Regexp::EXTENDED != 0
        embed << 'n' if options & ::Regexp::MULTILINE != 0

        if embed.empty?
          TclString.new(source.to_tcl)
        else
          TclString.new("(?#{embed.join})#{source}".to_tcl)
        end
      end
    end

    module String
      def to_tcl
        TclString.new('"' << gsub(/[\[\]$"\\]/, '\\\\\&') << '"')
      end

      def to_tcl_option
        TclString.new(sub(/\A(?=[^-])/, '-'))
      end
    end

    module Symbol
      def to_tcl
        TclString.new(to_s.dump)
      end

      def to_tcl_option
        TclString.new(to_s.sub(/\A(?=[^-])/, '-'))
      end
    end

    module Numeric
      def to_tcl
        TclString.new(to_s)
      end
    end

    module Float
      def tcl_to_ruby(option, hints)
        self
      end
    end

    module Fixnum
      def tcl_to_ruby(option, hints)
        name = option.sub(/^-/, '').to_sym

        if type = hints[name]
          case type
          when :boolean
            Tk.boolean(self)
          else
            self
          end
        end
      end

      def to_boolean
        Tk.boolean(self)
      end
    end

    module TrueClass
      def to_tcl
        TclString.new('1')
      end
    end

    module FalseClass
      def to_tcl
        TclString.new('0')
      end
    end

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
      else
        warn "Won't include %p with %p, %p exists" % [into, ext, collisions] if $DEBBUG
      end
    end
  end
end
