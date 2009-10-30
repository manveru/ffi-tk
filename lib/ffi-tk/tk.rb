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

    eval(<<-'TCL')
namespace eval RubyFFI {
  proc escape_string {s} {
    format {"%s"} [regsub -all {"} [regsub -all {\\\\} $s {\\\\\\\\}] {\\"}]
  }
  set events {}
  proc store_event {event} {
    variable events
    lappend events $event
  }
  proc get_event {} {
    variable events
    set ret [lindex $events 0]
    set events [lrange $events 1 end]
    set ret
  }
}
    TCL

    tcl_delete = method(:tcl_delete_callback)
    callback   = method(:tcl_callback)
    event      = method(:tcl_event)

    FFI::Tcl.create_obj_command(interp, 'RubyFFI::callback', callback, 0, tcl_delete)
    FFI::Tcl.create_obj_command(interp, 'RubyFFI::event', event, 0, tcl_delete)
  end

  # without our callbacks, nothing goes anymore, abort mission
  def tcl_delete_callback(client_data)
    raise RuntimeError, "tcl function is going to be removed"
  end

  def tcl_callback(client_data, interp, objc, objv)
    handle_callback(*tcl_cmd_args(interp, objc, objv))
    return OK
  end

  def tcl_event(client_data, interp, objc, objv)
    cmd, *args = tcl_cmd_args(interp, objc, objv)
    Event.from_obj(*args)
    return OK
  end

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
      handle_events
    end
  end

  def stop
    @running = false
  end

  def handle_events
    event = execute('RubyFFI::get_event')
    if event.respond_to?(:to_ary)
      Event.handle(*event)
    end
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

  def register_proc(proc)
    id = uuid(:proc){|uuid| @callbacks[uuid] = proc }
    return id, %(RubyFFI::callback #{id})
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
      "-#{key} #{tcl}"
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