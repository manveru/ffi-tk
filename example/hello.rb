#!/usr/bin/env ruby

require './lib/tk'
require './lib/tcl'

class Hello
  def initialize(*args)
    argc = args.size

    pointers = args.map{|arg| FFI::MemoryPointer.from_string(arg) }
    argv = FFI::MemoryPointer.new(:pointer, pointers.size)
    argv.write_array_of_pointer(pointers)

    FFI::Tk::Tk_Main(argc, argv, method(:app_init))
  end

  def app_init(interp)
    return FFI::Tcl::ERROR if FFI::Tcl::Tcl_Init(interp) == FFI::Tcl::ERROR
    return FFI::Tcl::ERROR if FFI::Tk::Tk_Init(interp  ) == FFI::Tcl::ERROR

    init      = FFI::Tk.method(:Tk_Init)
    safe_init = FFI::Tk.method(:Tk_SafeInit)

    FFI::Tcl::Tcl_StaticPackage(interp, "Tk", init, safe_init)
    FFI::Tcl::Tcl_SetVar(interp, "tcl_rcFileName", "~/.wishrc", FFI::Tcl::TCL_GLOBAL_ONLY)

    return 0
  end
end

Hello.new('Hello')
