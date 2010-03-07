class Object
  undef :type if respond_to?(:type)
end

module Tk
  @register = Hash.new(0)
  @widgets = {}
  @callbacks = {}
  @mutex = Mutex.new

  class << self
    attr_reader :callbacks, :widgets
  end

  module_function


  def init
    if RUN_EVENTLOOP_ON_MAIN_THREAD
      @interp = FFI::Tcl.setup_eventloop_on_main_thread
    else
      @interp = FFI::Tcl.setup_eventloop_on_new_thread
    end

    FFI::Tcl.init(@interp)
    FFI::Tcl::EvalResult.reset_types(@interp)
    FFI::Tk.init(@interp)

    @root = Root.new

    @interp.eval('namespace eval RubyFFI {}')

    FFI::Tcl.create_obj_command(@interp, 'RubyFFI::callback', TCL_CALLBACK, 0, TCL_DELETE)
    FFI::Tcl.create_obj_command(@interp, 'RubyFFI::event',    TCL_EVENT,    0, TCL_DELETE)

    module_eval('class << Tk; attr_reader :interp, :root; end')

    return @interp
  end

  # A little something so people don't have to call Tk.init
  def interp
    Tk.init
    @interp
  end

  # A little something so people don't have to call Tk.init
  def root
    Tk.init
    @root
  end

  def mainloop
    @running = true

    while @running && interp.wait_for_event(0.1)
      interp.do_one_event(0)
    end
  end

  def stop
    @running = false
  end

  def eval(string)
    interp.eval(string)
  end

  def execute_only(*args)
    interp.eval(convert_arguments(*args))
  end

  def execute(*args)
    interp.eval(convert_arguments(*args))
    result
  end

  def result
    interp.guess_result
  end

  def exit
    execute('exit')
  end

  def update(idletasks = None)
    execute('update', idletasks)
  end

  def callback_break
    throw :callback_break
  end

  def callback_continue
    throw :callback_continue
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
    id = id.first if id.is_a?(Array)

    catch :callback_break do
      catch :callback_continue do
        result = handle_callback(id, *args)
        FFI::Tcl::Interp.new(interp).obj_result = result

        return OK
      end

      return CONTINUE
    end

    return BREAK
  rescue => ex
    FFI::Tcl::Interp.new(interp).obj_result = ex
    return ERROR
  end
  TCL_CALLBACK = method(:tcl_callback)

  # TODO: support for break and continue return status (by catch/throw)
  def tcl_event(client_data, interp, objc, objv)
    cmd, id, sequence, *args = tcl_cmd_args(interp, objc, objv)

    catch :callback_break do
      catch :callback_continue do
        Event::Data.new(id.to_i, sequence.to_s, *args).call

        return OK
      end

      return CONTINUE
    end

    return BREAK
  rescue => ex
    FFI::Tcl::Interp.new(interp).obj_result = ex
    return ERROR
  end
  TCL_EVENT = method(:tcl_event)

  def tcl_cmd_args(interp, objc, objv)
    length = FFI::MemoryPointer.new(0)
    array = objv.read_array_of_pointer(objc)
    array.map{|e|
      obj = FFI::Tcl::EvalResult.guess(interp, e)
      case obj
      when Fixnum, Float
        obj
      else
        obj.respond_to?(:dup) ? obj.dup : obj
      end
    }
  end

  def handle_callback(id, *args)
    callback = @callbacks.fetch(id.to_i)
    callback.call(*args)
  end

  def register_object(parent, object)
    parent_name = parent.respond_to?(:tk_pathname) ? parent.tk_pathname : parent
    cmd = object.class.tk_command

    id = "#{cmd}#{uuid(cmd)}"
    pathname = [parent_name, id].join('.').squeeze('.')
    @widgets[pathname] = object

    return pathname
  end

  def unregister_object(object)
    @widgets.delete_if{|path, obj| obj == object }
  end

  def unregister_objects(*objects)
    @widgets.delete_if{|path, obj| objects.include?(obj) }
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

  def boolean(obj)
    boolean_pointer = FFI::MemoryPointer.new(:int)
    FFI::Tcl.get_boolean(interp, obj.to_s, boolean_pointer)
    boolean_pointer.get_int(0) == 1
  end

  def convert_arguments(*args)
    args.map(&:to_tcl).compact.join(' ')
  end

  def pathname_to_widget(pathname)
    @widgets[pathname]
  end
end
