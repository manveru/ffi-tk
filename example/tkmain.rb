require './lib/tcl'

class ThreadSpecificData < FFI::Struct
  layout(
    :interp, :pointer,
    :command, :string,
    :line, :string,
    :tty, :int
  )
end

Tcl = FFI::Tcl

def main(
  argc, # number of arguments
  argv, # array of argument strings
  interp, # tcl interpreter
  &block # Application-specific initialization function to call after
  )      # most initialization but before starting to execute commands.

  if Tcl.Tcl_InitStubs(interp, Tcl::TCL_VERSION, 1).nil?
    abort "Couldn't initialize stubs"
  end

  tsd = ThreadSpecificData
  tsdPtr = tsd.new(Tcl.Tcl_GetThreadData(tsd.new, tsd.size))

  Tcl::Tcl_FindExecutable(argv[0])
  tsdPtr[:interp] = interp
  tsdPtr[:tty] = $stdin.tty? ? 1 : 0

  Tcl.Tcl_Preserve(interp)

  appname = FFI::MemoryPointer.from_string("the app name")
  Tcl.Tcl_ExternalToUtfDString(nil, argv[0], -1, appname)
  Tcl.Tcl_SetVar(interp, "argv0", Tcl.Tcl_DStringValue(appname), Tcl::TCL_GLOBAL_ONLY)
  Tcl.Tcl_DStringFree(appname)

  Tcl.Tcl_SetVar2Ex(interp, "argc", nil, Tcl_NewIntObj(argc), Tcl::TCL_GLOBAL_ONLY)
  argvPtr = Tcl.Tcl_NewListObj(0, nil)
  Tcl.Tcl_SetVar2Ex(interp, "argv", nil, argvPtr, Tcl::TCL_GLOBAL_ONLY)

  Tcl.Tcl_SetVar(interp, "tcl_interactive", "0", Tcl::TCL_GLOBAL_ONLY)

  inChannel = Tcl.Tcl_GetStdChannel(Tcl::TCL_STDIN)
  p inChannel: inChannel
  if inChannel
    Tcl.Tcl_CreateChannelHandler(inChannel, Tcl::TCL_READABLE, StdinProc,
                                 inChannel)
  end

  if tsdPtr[:tty]
    Prompt(interp, 0)
  end
end

interp = Tcl.Tcl_CreateInterp()
main(0, [], interp)
