# frozen_string_literal: true
module Tk
  module_function

  # Pop up a dialog box for the user to select a file to save.
  #
  # This method is usually associated with the "Save as" command in the "File"
  # menu.
  # If the user enters a file that already exists, the dialog box prompts the
  # user for confirmation whether the existing file should be overwritten or
  # not.
  #
  # If a user selects a file, the full pathname of the file is returned.
  # If the user cancels the dialog, nil is returned.
  #
  # The following options may be given:
  #
  #   defaultextension: extension
  #     Specifies a string that will be appended to the filename if the user
  #     enters a filename without an extension.
  #     The default value is the empty string, which means no extension will be
  #     appended to the filename in any case.
  #     This option is ignored on Mac OS X, which does not require extensions to
  #     filenames, and the UNIX implementation guesses reasonable values for
  #     this from the :filetypes option when this is not supplied.
  #
  #   filetypes: file_pattern_list
  #     If a File types listbox exists in the file dialog on the particular
  #     platform, this option gives the filetypes in this listbox.
  #     When the user choose a filetype in the listbox, only the files of that
  #     type are listed.
  #     If this option is unspecified, or if it is set to the empty list, or if
  #     the File types listbox is not supported by the particular platform then
  #     all files are listed regardless of their types.
  #
  #   initialdir: directory
  #     Specifies that the files in directory should be displayed when the
  #     dialog pops up.
  #     If this parameter is not specified, then the files in the current
  #     working directory are displayed.
  #     If the parameter specifies a relative path, the return value will
  #     convert the relative path to an absolute path.
  #
  #   initialfile: filename
  #     Specifies a filename to be displayed in the dialog when it pops up.
  #
  #   message: string
  #     Specifies a message to include in the client area of the dialog.
  #     This is only available on Mac OS X.
  #
  #   multiple: boolean
  #     Allows the user to choose multiple files from the dialog.
  #
  #   parent: window
  #     Makes window the logical parent of the file dialog.
  #     The file dialog is displayed on top of its parent window.
  #     On Mac OS X, this turns the file dialog into a sheet attached to the
  #     parent window.
  #
  #   title: string
  #     Specifies a string to display as the title of the dialog box.
  #     If this option is not specified, then a default title is displayed.
  #
  # On the Unix and Macintosh platforms, extensions are matched using glob-style
  # pattern matching.
  # On the Windows platform, extensions are matched by the underlying operating
  # system.
  #
  # The types of possible extensions are:
  #   * the special extension "*" matches any file
  #   * the special extension "" matches any files that do not have an extension
  #     (i.e., the filename contains no full stop character)
  #   * any character string that does not contain any wild card characters ("*"
  #     and "?").
  #
  # Due to the different pattern matching rules on the various platforms, to
  # ensure portability, wild card characters are not allowed in the extensions,
  # except as in the special extension "*".
  # Extensions without a full stop character (e.g. "~") are allowed but may not
  # work on all platforms.
  def get_save_file(options = None)
    result = Tk.execute(:tk_getSaveFile, options.to_tcl_options?)
    path = result.respond_to?(:to_str) ? result.to_str : result.to_s?
    path unless path.empty?
  end
end
