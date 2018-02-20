# frozen_string_literal: true
module Tk
  # This class is used for communication of variables with Tcl.
  class Variable
    include Comparable

    attr_reader :name, :tcl_name, :bytesize

    def initialize(name, value = None)
      @name = name.freeze
      @tcl_name = "$#{name}"
      set(value) unless None == value
    end

    def get
      Tk.execute('set', name)
    rescue RuntimeError
      raise NameError, "can't read %p: no such variable" % [name]
    end

    def set(value)
      Tk.execute_only('set', name, value)
    end

    def unset
      Tk.execute_only('unset', name)
    end

    def to_tcl
      TclString.new(name)
    end

    def to_s
      get.to_s
    end

    def to_i
      get.to_i
    end

    def to_boolean
      got = get

      if got.respond_to?(:to_boolean)
        got.to_boolean
      elsif got == '0'
        false
      elsif got == '1'
        true
      else
        got
      end
    end

    def to_f
      get.to_f
    end

    def <=>(other)
      case other
      when self.class
        get <=> other.get
      else
        get <=> other
      end
    end
  end
end
