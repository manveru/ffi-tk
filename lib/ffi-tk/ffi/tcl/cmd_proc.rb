# frozen_string_literal: true

module FFI
  module Tcl
    # FFI binding for a classic Tcl command's C arguments (clientData, interp, argc, argv).
    class CmdProc < PrettyStruct
      layout :clientData, :int,
             :interp,     Interp,
             :argc,       :int,
             :argv,       :pointer
    end
  end
end
