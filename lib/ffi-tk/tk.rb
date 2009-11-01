module Tk
  class << self
    attr_reader :interp, :root, :callbacks
  end

  @register = Hash.new(0)
  @callbacks = {}
  @mutex = Mutex.new

  # A little something so people know what they have to do.
  # Might simply call Tk.init in it instead (and issue a warning)?
  @interp = BasicObject.new
  def @interp.method_missing(*args)
    Kernel.raise "Call Tk.init before using Tk"
  end

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
    cmd, id, sequence, *args = tcl_cmd_args(interp, objc, objv)
    Event::Data.new(id.to_i, sequence.to_s, *args).call
    return OK
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

  def exit
    execute('exit')
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

    end

    module String
      def to_tcl
        TclString.new(self =~ /\A\w+\Z/ ? dup : dump)
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

  # Already converted statement, don't process again
  class TclString < String
    def to_tcl
      self
    end
  end

  def boolean(obj)
    FFI::Tcl.get_boolean(@interp, obj)
  end

  def convert_arguments(*args)
    args.map(&:to_tcl).compact.join(' ')
  end
end