# frozen_string_literal: true
module Tk
  @library       = Variable.new('tk_library')

  @version       = Variable.new('tk_version')
  @patchlevel    = Variable.new('tk_patchLevel')

  @strict_motif  = Variable.new('tk_strictMotif')

  @text_redraw   = Variable.new('tk_textRedraw')
  @text_relayout = Variable.new('tk_textRelayout')

  module_function

  # This variable holds the file name for a directory containing a library of
  # Tcl scripts related to Tk.
  # These scripts include an initialization file that is normally processed
  # whenever a Tk application starts up, plus other files containing procedures
  # that implement default behaviors for widgets.
  # The initial value of tcl_library is set when Tk is added to an interpreter;
  # this is done by searching several different directories until one is found
  # that contains an appropriate Tk startup script.
  # If the TK_LIBRARY environment variable exists, then the directory it names
  # is checked first.
  # If TK_LIBRARY is not set or does not refer to an appropriate directory, then
  # Tk checks several other directories based on a compiled-in default location,
  # the location of the Tcl library directory, the location of the binary
  # containing the application, and the current working directory.
  # The variable can be modified by an application to switch to a different
  # library.
  def library
    @library.to_s
  end

  def library=(new_library)
    @library.set(new_library.to_s)
  end

  # Contains a decimal integer giving the current patch level for Tk.
  # The patch level is incremented for each new release or patch, and it
  # uniquely identifies an official version of Tk.
  def patchlevel
    @patchlevel.to_s
  end

  # This variable is set to zero by default.
  # If an application sets it to one, then Tk attempts to adhere as closely as
  # possible to Motif look-and-feel standards.
  # For example, active elements such as buttons and scrollbar sliders will not
  # change color when the pointer passes over them.
  def strict_motif
    @strict_motif.to_boolean
  end

  def strict_motif=(new_value)
    @strict_motif.set(new_value ? true : false)
  end

  # These variables are set by text widgets when they have debugging turned on.
  # The values written to these variables can be used to test or debug text
  # widget operations.
  # These variables are mostly used by Tk's test suite.
  def text_redraw
    @text_redraw.get
  end

  def text_relayout
    @text_relayout.get
  end

  # Tk sets this variable in the interpreter for each application.
  # The variable holds the current version number of the Tk library in the form
  # major.minor. Major and minor are integers.
  # The major version number increases in any Tk release that includes changes
  # that are not backward compatible (i.e.
  # whenever existing Tk applications and scripts may have to change to work
  # with the new release).
  # The minor version number increases with each new release of Tk, except that
  # it resets to zero whenever the major version number changes.
  def version
    @version.to_s
  end
end
