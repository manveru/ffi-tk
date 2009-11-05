module Tk
  module_function

  # Pops up a dialog box for the user to select a color.
  #
  # If the user selects a color, this method will return the name of the color.
  # If the user cancels the dialog, nil will be returned.
  #
  # The following options are possible:
  #
  #   initialcolor: color
  #     Specifies the color to display in the dialog.
  #
  #   parent: window
  #     Makes window the logical parent of the color dialog.
  #     The dialog is displayed on top of its parent window.
  #
  #   title: string
  #     Specifies a string to display as the title of the dialog box.
  #     If this option is not specified, then a default title will be displayed.
  #
  # @example usage
  #
  #   Tk::Button.new(Tk.root,
  #     bg: Tk.choose_color(initial_color: 'gray', title: 'Choose color'))
  def choose_color(options = None)
    Tk.execute(:tk_chooseColor, options.to_tcl_options?).to_s?
  end
end