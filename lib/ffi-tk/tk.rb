# frozen_string_literal: true

# Core extension routing plain-object value conversion for Tk.
class Object
  undef :type if respond_to?(:type)
end

# Interpreter lifecycle and the main eval/execute entry points.
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
    @interp = if RUN_EVENTLOOP_ON_MAIN_THREAD
                FFI::Tcl.setup_eventloop_on_main_thread
              else
                FFI::Tcl.setup_eventloop_on_new_thread
              end

    FFI::Tcl.init(@interp)
    FFI::Tcl::EvalResult.reset_types(@interp)
    FFI::Tk.init(@interp)

    @root = Root.new

    @interp.eval('namespace eval RubyFFI {}')

    FFI::Tcl.create_obj_command(@interp, 'RubyFFI::callback', TCL_CALLBACK, 0, TCL_DELETE)
    FFI::Tcl.create_obj_command(@interp, 'RubyFFI::event',    TCL_EVENT,    0, TCL_DELETE)

    module_eval('class << Tk; attr_reader :interp, :root; end', __FILE__, __LINE__)

    @interp
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

  # Self-rearming Tcl timer. It never crosses into Ruby; its sole purpose is
  # to guarantee Tcl_DoOneEvent returns at least once per interval so
  # #mainloop can recheck @running even on an otherwise idle display.
  HEARTBEAT_PROC = <<~TCL
    proc ::RubyFFI::heartbeat {ms} {
      set ::RubyFFI::heartbeat_id [after $ms [list ::RubyFFI::heartbeat $ms]]
    }
  TCL

  # Block in Tcl_DoOneEvent (GVL released, events serviced back-to-back)
  # until Tk.stop clears @running; the heartbeat bounds stop latency.
  #
  # With background: true the loop runs on a dedicated thread and the caller
  # gets that Thread back immediately, leaving the calling thread free for
  # non-GUI work. Because Tcl_DoOneEvent releases the GVL, other Ruby threads
  # stay responsive either way; background only matters when you need the
  # *calling* thread itself free. Unavailable where the event loop is pinned
  # to the main thread (macOS/Cocoa), which raises rather than misbehaving.
  # @running and the heartbeat are armed synchronously before the thread
  # starts, so an immediate Tk.stop cannot race the loop's startup.
  def mainloop(heartbeat: 0.1, background: false)
    if background && RUN_EVENTLOOP_ON_MAIN_THREAD
      raise 'Tk.mainloop(background: true) is unavailable on this platform: ' \
            'the event loop must run on the main thread here'
    end

    @running = true

    interp.eval(HEARTBEAT_PROC)
    interp.eval(format('::RubyFFI::heartbeat %d', (heartbeat * 1000).round))

    pump = lambda do
      interp.do_one_event(0) while @running
    ensure
      interp.eval('catch { after cancel $::RubyFFI::heartbeat_id }')
    end

    background ? Thread.new(&pump) : pump.call
  end

  def stop
    @running = false
  end

  def eval(string)
    interp.eval(string)
  end

  def execute_only(*)
    interp.eval(convert_arguments(*))
  end

  def execute(*)
    interp.eval(convert_arguments(*))
    result.tap { |r| puts format('eval= %p', r) if $DEBUG }
  end

  # Like #execute, but returns the result's raw Tcl string (never
  # EvalResult.guess). The option path reads raw strings and coerces them by
  # declared type, so it must not go through the shimmering-prone guesser.
  def execute_string(*)
    interp.eval(convert_arguments(*))
    interp.result_string
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
  def tcl_delete(_client_data)
    raise 'tcl function is going to be removed'
  end
  TCL_DELETE = method(:tcl_delete)

  # TODO: support for break and continue return status (by catch/throw)
  # 1 means true, 0 means false.
  def tcl_callback(_client_data, interp, objc, objv)
    _, id, *args = tcl_cmd_args(interp, objc, objv)
    id = id.first if id.is_a?(Array)

    catch :callback_break do
      catch :callback_continue do
        result = handle_callback(id, *args)
        FFI::Tcl::Interp.new(interp).callback_result = result

        return OK
      end

      return CONTINUE
    end

    BREAK
  rescue StandardError => e
    FFI::Tcl::Interp.new(interp).obj_result = e
    ERROR
  end
  TCL_CALLBACK = method(:tcl_callback)

  # TODO: support for break and continue return status (by catch/throw)
  def tcl_event(_client_data, interp, objc, objv)
    _, id, sequence, *args = tcl_cmd_args(interp, objc, objv)

    catch :callback_break do
      catch :callback_continue do
        Event::Data.new(id.to_i, sequence.to_s, *args).call

        return OK
      end

      return CONTINUE
    end

    BREAK
  rescue StandardError => e
    FFI::Tcl::Interp.new(interp).obj_result = e
    ERROR
  end
  TCL_EVENT = method(:tcl_event)

  def tcl_cmd_args(interp, objc, objv)
    FFI::MemoryPointer.new(0)
    array = objv.read_array_of_pointer(objc)
    array.map do |e|
      obj = FFI::Tcl::EvalResult.guess(interp, e)
      case obj
      when Integer, Float
        obj
      when nil
        nil
      else
        obj.respond_to?(:dup) ? obj.dup : obj
      end
    end
  end

  def handle_callback(id, *)
    callback = @callbacks.fetch(id.to_i)
    callback.call(*)
  end

  def register_object(parent, object)
    parent_name = parent.respond_to?(:tk_pathname) ? parent.tk_pathname : parent
    cmd = object.class.tk_command

    id = "#{cmd}#{uuid(cmd)}".gsub('::', '__') # :: is namespace convention.
    pathname = [parent_name, id].join('.').squeeze('.')
    @widgets[pathname] = object

    pathname
  end

  def unregister_object(object)
    @widgets.delete_if { |_path, obj| obj == object }
  end

  def unregister_objects(*objects)
    @widgets.delete_if { |_path, obj| objects.include?(obj) }
  end

  def register_proc(proc, argument_string = '')
    id = uuid(:proc) { |uuid| @callbacks[uuid] = proc }
    [id, %(RubyFFI::callback #{id} #{argument_string})]
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
