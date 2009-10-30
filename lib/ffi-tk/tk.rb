module Tk
  class << self
    attr_reader :interp, :root, :callbacks
  end

  @register = Hash.new(0)
  @callbacks = {}
  @mutex = Mutex.new

  module_function

  def init
    @interp = FFI::Tcl::Interp.create

    FFI::Tcl.init(@interp)
    FFI::Tcl::EvalResult.reset_types(interp)
    FFI::Tk.init(@interp)

    @root = Root.new

    eval('namespace eval RubyFFI {}')

    FFI::Tcl.create_obj_command(interp, 'RubyFFI::callback', TCL_CALLBACK, 0, TCL_DELETE)
    FFI::Tcl.create_obj_command(interp, 'RubyFFI::event',    TCL_EVENT,    0, TCL_DELETE)
  end

  # without our callbacks, nothing goes anymore, abort mission
  def tcl_delete(client_data)
    raise RuntimeError, "tcl function is going to be removed"
  end
  TCL_DELETE = method(:tcl_delete)

  # TODO: support for break and continue return status (by catch/throw)
  # 1 means true, 0 means false.
  def tcl_callback(client_data, interp, objc, objv)
    cmd, id, *args = tcl_cmd_args(interp, objc, objv)
    result = handle_callback(id, *args)
    FFI::Tcl::Interp.new(interp).obj_result = result
    return OK
  end
  TCL_CALLBACK = method(:tcl_callback)

  # TODO: support for break and continue return status (by catch/throw)
  def tcl_event(client_data, interp, objc, objv)
    cmd, *args = tcl_cmd_args(interp, objc, objv)
    Event.handle(*args)
    return OK
  end
  TCL_EVENT = method(:tcl_event)

  def tcl_cmd_args(interp, objc, objv)
    length = FFI::MemoryPointer.new(0)
    array = objv.read_array_of_pointer(objc)
    array.map{|e|
      obj = FFI::Tcl::EvalResult.guess(interp, e)
      obj.respond_to?(:dup) ? obj.dup : obj
    }
  end

  def mainloop
    @running = true

    while @running && @interp.wait_for_event(0.1)
      @interp.do_one_event(0)
    end
  end

  def stop
    @running = false
  end

  def handle_callback(id, *args)
    callback = @callbacks.fetch(id.to_i)
    callback.call(*args)
  end

  def register_object(parent, object)
    parent_name = parent.respond_to?(:tk_pathname) ? parent.tk_pathname : parent
    name = object.class.name.downcase
    id = uuid(name)

    if parent_name[-1] == '.'
      "#{parent_name}#{name}#{id}"
    else
      "#{parent_name}.#{name}#{id}"
    end
  end

  def register_proc(proc, argument_string = '')
    id = uuid(:proc){|uuid| @callbacks[uuid] = proc }
    return id, %(RubyFFI::callback #{id} #{argument_string})
  end

  def unregister_proc(id)
    @callbacks.delete(id)
  end

  def uuid(name)
    @mutex.synchronize do
      id = @register[name]
      @register[name] += 1
      yield id if block_given?
      id
    end
  end

  def eval(string)
    @interp.eval(string)
  end

  def execute_only(*args)
    @interp.eval(convert_arguments(*args))
  end

  def execute(*args)
    @interp.eval(convert_arguments(*args))
    result
  end

  def result
    @interp.guess_result
  end

  def convert_arguments(*args)
    args.map{|arg|
      case arg
      when None
        ''
      when Hash
        hash_to_tcl(arg)
      when String, Symbol
        string_to_tcl(arg)
      when Array
        array_to_tcl(arg)
      when true
        1
      when false
        0
      when Numeric
        arg
      else
        if arg.respond_to?(:to_tcl)
          arg.to_tcl
        else
          raise ArgumentError, "Unknown argument: %p" % [arg]
        end
      end
    }.join(' ')
  end

  def hash_to_tcl(hash)
    hash.map{|key, value|
      tcl = convert_arguments(value)
      "#{key} #{tcl}"
    }.join(' ')
  end

  def string_to_tcl(string)
    string.to_s.dump
  end

  def array_to_tcl(array)
    array.inspect
  end

  def exit
    execute('exit')
  end
end