require 'ffi'

module FFI
  module Tcl
    extend FFI::Library

    ffi_lib 'libtcl8.5'

    callback :app_init_proc, [:pointer], :int
    attach_function :Tcl_Main, [:int, :pointer, :app_init_proc], :void
    attach_function :Tcl_CreateInterp, [], :pointer
    attach_function :Tcl_GetVersion, [:pointer, :pointer, :pointer, :pointer], :void
    attach_function :Tcl_Init, [:pointer], :int
    attach_function :Tcl_DeleteInterp, [:pointer], :void
    attach_function :Tcl_Release, [:pointer, :pointer], :void
    attach_function :Tcl_SetStartupScript, [:pointer, :pointer], :void
    attach_function :Tcl_Exit, [:int], :void
    attach_function :Tcl_InitStubs, [:pointer, :string, :int], :string
    attach_function :Tcl_GetThreadData, [:pointer, :int], :pointer
    attach_function :Tcl_FindExecutable, [:string], :void
    attach_function :Tcl_Preserve, [:pointer], :void
    attach_function :Tcl_ExternalToUtfDString, [:pointer, :string, :int, :pointer], :string
    attach_function :Tcl_DStringFree, [:pointer], :void
    attach_function :Tcl_NewIntObj, [:int], :pointer

    # Tcl_SetVar(interp, varName, newValue, flags)
    attach_function :Tcl_SetVar, [:pointer, :string, :string, :int], :string

    callback :init, [:pointer], :int
    callback :safe_init, [:pointer], :int
    attach_function :Tcl_StaticPackage, [:pointer, :string, :init, :safe_init], :void

    require 'ffi/tools/const_generator'
    kqc = FFI::ConstGenerator.new do |c|
      c.include 'tcl.h'

      def c.int(name)
        const(name, '%d', '(int)', name.sub(/^TCL_/, ''))
      end

      def c.string(name)
        const(name, '%s', '(char*)', name.sub(/^TCL_/, ''))
      end

      # Release levels
      c.int "TCL_ALPHA_RELEASE"
      c.int "TCL_BETA_RELEASE"
      c.int "TCL_FINAL_RELEASE"
      c.int "TCL_MAJOR_VERSION"
      c.int "TCL_MINOR_VERSION"
      c.int "TCL_RELEASE_LEVEL"
      c.int "TCL_RELEASE_SERIAL"
      c.string "TCL_VERSION"
      c.string "TCL_PATCH_LEVEL"


      # Definition of values for default stacksize and the possible flags to be
      # given to Tcl_CreateThread.
      c.int 'TCL_THREAD_STACK_DEFAULT' # Use default size for stack
      c.int 'TCL_THREAD_NOFLAGS' # Standard flags, default behaviour
      c.int 'TCL_THREAD_JOINABLE' # Mark the thread as joinable


      # Flag values passed to Tcl_StringCaseMatch.
      c.int 'TCL_MATCH_NOCASE'


      # Flag values passed to Tcl_GetRegExpFromObj.
      c.int 'TCL_REG_BASIC'    # BREs (convenience)
      c.int 'TCL_REG_EXTENDED' # EREs
      c.int 'TCL_REG_ADVF'     # advanced features in EREs
      c.int 'TCL_REG_ADVANCED' # AREs (which are also EREs)
      c.int 'TCL_REG_QUOTE'    # no special characters, none
      c.int 'TCL_REG_NOCASE'   # ignore case */
      c.int 'TCL_REG_NOSUB'    # don't care about subexpressions
      c.int 'TCL_REG_EXPANDED' # expanded format, white space & c.int comments
      c.int 'TCL_REG_NLSTOP'   # \n doesn't match . or [^ ]
      c.int 'TCL_REG_NLANCH'   # ^ matches after \n, $ before
      c.int 'TCL_REG_NEWLINE'  # newlines are line terminators
      c.int 'TCL_REG_CANMATCH' # report details on partial/limited matches


      # Flags values passed to Tcl_RegExpExecObj.
      c.int 'TCL_REG_NOTBOL' # Beginning of string does not match ^.
      c.int 'TCL_REG_NOTEOL' # End of string does not match $.


      # When a TCL command returns, the interpreter contains a result from the
      # command. Programmers are strongly encouraged to use one of the
      # functions Tcl_GetObjResult() or Tcl_GetStringResult() to read the
      # interpreter's result.
      # See the SetResult man page for details.
      # Besides this result, the command function returns an integer code,
      # which is one of the following:

      # Command completed normally; the interpreter's result contains the
      # command's result.
      c.int 'TCL_OK'

      # The command couldn't be completed successfully; the interpreter's
      # result describes what went wrong.
      c.int 'TCL_ERROR'

      # The command requests that the current function return; the
      # interpreter's result contains the function's return value.
      c.int 'TCL_RETURN'

      # The command requests that the innermost loop be exited; the
      # interpreter's result is meaningless.
      c.int 'TCL_BREAK'

      # Go on to the next iteration of the current loop; the interpreter's
      # result is meaningless.
      c.int 'TCL_CONTINUE'

      # Flags to control what substitutions are performed by Tcl_SubstObj():
      c.int 'TCL_SUBST_COMMANDS'
      c.int 'TCL_SUBST_VARIABLES'
      c.int 'TCL_SUBST_BACKSLASHES'
      c.int 'TCL_SUBST_ALL'


      # Flag values passed to Tcl_ConvertElement.

      # forces it not to enclose the element in braces, but to use backslash
      # quoting instead.
      c.int 'TCL_DONT_USE_BRACES'

      # disables the default quoting of the '#' character. It is safe to leave
      # the hash unquoted when the element is not the first element of a list,
      # and this flag can be used by the caller to indicate that condition.
      c.int 'TCL_DONT_QUOTE_HASH'


      # Flag that may be passed to Tcl_GetIndexFromObj to force it to disallow
      # abbreviated strings.
      c.int 'TCL_EXACT'


      # Flag values passed to Tcl_RecordAndEval, Tcl_EvalObj, Tcl_EvalObjv.
      c.int 'TCL_NO_EVAL' #	Just record this command
      c.int 'TCL_EVAL_GLOBAL' #	Execute script in global namespace
      c.int 'TCL_EVAL_DIRECT' #	Do not compile this script

      #	Magical Tcl_EvalObjv mode for aliases/ensembles
      #   o Run in iPtr->lookupNsPtr or global namespace
      #   o Cut out of error traces
      #   o Don't reset the flags controlling ensemble error message rewriting.
      c.int 'TCL_EVAL_INVOKE'

      # Special freeProc values that may be passed to Tcl_SetResult (see the
      # man page for details):
      c.int 'TCL_VOLATILE'
      c.int 'TCL_STATIC'
      c.int 'TCL_DYNAMIC'
    end

    puts kqc.to_ruby

    class ThreadSpecificData < FFI::Struct
      layout(
        :handlersActive, :int, # non-zero when handler is active
        :pendingPtr, :pointer, # topmost search in progress, NULL if none

        # List of generic handler records
        :genericList, :pointer, # first handler in the list, or NULL
        :lastGenericPtr, :pointer, # last handler in the list, or NULL

        # List of client message handler records
        :cmList, :pointer, # first handler in the list, or NULL
        :lastCmPtr, :pointer, # last handler in the list, or NULL

        # If someone has called Tk_RestrictEvents, the information below keeps
        # track of it.
        :restrictProc, :pointer, # function to call or NULL
        :restrictArg, :pointer, # argument to pass to restrictProc
        :firstExitPtr, :pointer, # first in list of all exit handlers for this
                                 # thread
        :inExit, :int # True when this thread is exiting, this is used as a
                      # hack to decide to close the standard channels
      )
    end

    class Tcl_DString < FFI::Struct
      layout(
        :string, :string,
        :length, :int,
        :spaceAvl, :int,
        :staticSpace, :char
      )
    end

    ERROR = 1

    TCL_ALPHA_RELEASE  = 0
    TCL_BETA_RELEASE   = 1
    TCL_FINAL_RELEASE  = 2
    TCL_GLOBAL_ONLY    = 1
    TCL_NAMESPACE_ONLY = 2
    TCL_APPEND_VALUE   = 4
    TCL_LIST_ELEMENT   = 8

    module_function

    def version
      pointers = Array.new(4){ MemoryPointer.new(:int) }
      Tcl_GetVersion(*pointers)
      pointers.map{|pointer| pointer.get_int(0) }
    end

    VERSION = version
    TCL_VERSION = VERSION.first(2).join('.')
    TCL_PATCH_LEVEL = VERSION.first(3).join('.')

    # here come macros

    def Tcl_DStringValue(pointer)
      if pointer.is_a?(Tcl_DString)
        pointer[:string]
      else
        Tcl_DString.new(pointer)[:string]
      end
    end
  end
end
