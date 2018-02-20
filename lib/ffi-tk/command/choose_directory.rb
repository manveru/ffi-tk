# frozen_string_literal: true
module Tk
  module_function

  # Pops up a dialog box for the user to select a directory.
  #
  # The following options are possible:
  #
  #   initialdir: dirname
  #     Specifies that the directories in directory should be displayed when the
  #     dialog pops up.
  #     If this parameter is not specified, then the directories in the current
  #     working directory are displayed.
  #     If the parameter specifies a relative path, the return value will
  #     convert the relative path to an absolute path.
  #
  #   mustexist: boolean
  #     Specifies whether the user may specify non-existent directories.
  #     If this parameter is true, then the user may only select directories
  #     that already exist.
  #     The default value is false.
  #
  #   parent: window
  #     Makes window the logical parent of the dialog.
  #     The dialog is displayed on top of its parent window.
  #     On Mac OS X, this turns the file dialog into a sheet attached to the
  #     parent window.
  #
  #   title: string
  #     Specifies a string to display as the title of the
  #     dialog box.
  #     If this option is not specified, then a default title will be displayed.
  #
  # @example usage
  #
  #   dir = Tk.choose_directory(initialdir: '~', title: 'Choose a directory')
  #
  #   if dir
  #     Tk::Label.new(Tk.root, text: "Selected #{dir}")
  #   else
  #     Tk::Label.new(Tk.root, text: 'No directory selected')
  #   end
  def choose_directory(options = None)
    Tk.execute(:tk_chooseDirectory, options.to_tcl_options?).to_s?
  end
end
