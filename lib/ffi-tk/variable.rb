module Tk
  # This class is optimized towards getting variables from Tcl.
  # Setting and unsetting are working via eval to keep the code short and the
  # amount of housekeeping around the dual GC setup low.
  #
  # Usually, getting varialbes vastly outnumbers the cases where variables are
  # set, in particular within FFI::TK, where most use-cases for Tk::Variable are
  # to retrieve values set by Tk.
  #
  # TODO: hook into the Ruby GC to remove the name_obj once done.
  class Variable
    attr_reader :name, :bytesize

    def initialize(name)
      @name     = "$#{name}".freeze
      @bytesize = @name.bytesize

      # this is definitely not recommended by the Tcl docs, it's like a Ruby
      # Symbol.
      # Unfortunately the Tcl_IncrRefCount and Tcl_DecrRefCount are macros and
      # cannot be accessed by FFI.
      # self.name_obj = FFI::Tcl::Obj.new(FFI::Tcl.new_string_obj(name, name.bytesize))
      # name_obj[:refCount] = 1
    end

    def get
      name_obj = FFI::Tcl.new_string_obj(@name, @bytesize)
      var = FFI::Tcl.obj_get_var2(Tk.interp, name_obj, nil, 0)

      if var.to_i == 0
        raise NameError, "Failure during lookup of %p" % [name]
      else
        FFI::Tcl::EvalResult.guess(Tk.interp, var, :to_string)
      end
    end

    def set(value)
      Tk.execute_only('set', name, value)
    end

    def unset
      Tk.execute_only('unset', name)
    end
  end
end