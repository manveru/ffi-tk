module Tk
  # This class is used for communication of variables with Tcl.
  class Variable
    attr_reader :name, :tcl_name, :bytesize

    def initialize(name)
      @name = name.freeze
      @tcl_name = "$#{name}".freeze
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
      get.to_boolean
    end

    def to_f
      get.to_f
    end
  end
end