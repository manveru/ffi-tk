require 'ffi'

$LOAD_PATH.unshift File.dirname(__FILE__)

require 'ffi-tk/tcl'
require 'ffi-tk/tk'

module Tk
  Error = Class.new(RuntimeError)

  autoload :Widget,     'ffi-tk/widget'
  autoload :Bind,       'ffi-tk/bind'
  autoload :Destroy,    'ffi-tk/destroy'
  autoload :Pack,       'ffi-tk/pack'
  autoload :Button,     'ffi-tk/button'
  autoload :Event,      'ffi-tk/event'
  autoload :Text,       'ffi-tk/text'
  autoload :Entry,      'ffi-tk/entry'
  autoload :EvalResult, 'ffi-tk/eval_result'
  autoload :Root,       'ffi-tk/root'

  None = Object.new

  module_function

  def interp
    @interp
  end

  def root
    @root
  end

  def init
    @interp = FFI::Tcl::Interp.create
    @register = Hash.new(0)
    @mutex = Mutex.new
    FFI::Tcl.init(@interp)
    FFI::Tk.init(@interp)
    @root = Root.new

    eval 'proc _esc {s} {format {"%s"} [regsub -all {"} [regsub -all {\\\\} $s {\\\\\\\\}] {\\"}]}'
    eval 'set _events {}'
    eval 'proc _ev {args} {global _events; foreach arg $args {append escaped [_esc $arg]}; lappend _events "([concat $escaped])"}'
    eval 'proc _get_ev {} {global _events; set ret [lindex $_events 0]; set _events [lrange $_events 1 end]; set ret}'
  end

  def mainloop
    while @interp.wait_for_event(0.1)
      @interp.do_one_event(0)

      eval('_get_ev')
      result = @interp.string_result

      unless result.empty?
        handle_event(result)
      end
    end
  end

  def handle_event(string)
    values = string[2..-3].split

    event_id = Integer(values.shift)
    event_bind = values.shift
    event = Event.new(event_id, event_bind)

    Event::PROPERTIES.each do |code, conv, name|
      value = values.shift
      next if value == '??'
      converted = __send__(conv, value)
      event[name] = converted
    end

    event.invoke
  end

  def register_object(parent, object)
    parent_name = parent.respond_to?(:tk_pathname) ? parent.tk_pathname : parent
    name = object.class.name.downcase
    id = nil

    @mutex.synchronize do
      id = @register[name] += 1
    end

    if parent_name[-1] == '.'
      "#{parent_name}#{name}#{id}"
    else
      "#{parent_name}.#{name}#{id}"
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
    EvalResult.guess(@interp.obj_result)
  end

  def convert_arguments(*args)
    args.map{|arg|
      case arg
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