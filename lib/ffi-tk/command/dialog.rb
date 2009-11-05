module Tk
  module_function

  # Create modal dialog and wait for response
  #
  # @param window
  #   Name of top-level window to use for dialog.
  #   Any existing window by this name is destroyed.
  #
  # @param title [String]
  #   Text to appear in the window manager's title bar for the dialog.
  #
  # @param text [String]
  #   Message to appear in the top portion of the dialog box.
  #
  # @param bitmap [nil String]
  #   If non-nil, specifies a bitmap to display in the top portion of the
  #   dialog, to the left of the text.
  #   If this is nil then no bitmap is displayed in the dialog.
  #
  # @param default [nil Fixnum]
  #   If this is an integer greater than or equal to zero, then it gives the
  #   index of the button that is to be the default button for the dialog (0 for
  #   the leftmost button, and so on).
  #   If less than zero or nil then there will not be any default button.
  #
  # @param answers
  #   There will be one button for each of these arguments.
  #   Each answer element specifies text to display in a button, in order from
  #   left to right.
  #
  # After creating a dialog box, [dialog] waits for the user to select one of
  # the buttons either by clicking on the button with the mouse or by typing
  # return to invoke the default button (if any).
  #
  # Then it returns the index of the selected button: 0 for the leftmost button,
  # 1 for the button next to it, and so on.
  # If the dialog's window is destroyed before the user selects one of the
  # buttons, then nil is returned.
  #
  # While waiting for the user to respond, [dialog] sets a local grab.
  # This prevents the user from interacting with the application in any way
  # except to invoke the dialog box.
  #
  # @example usage
  #
  #   reply = Tk.dialog('.foo', 'The Title', 'Do you want to say yes?',
  #     'questhead', 0, 'Yes', 'No', "I'm not sure")
  def dialog(window, title, text, bitmap, default, *answers)
    answer = Tk.execute(:tk_dialog,
      window, title, text, bitmap, default, *answers).to_i
    return answer unless answer == -1
  end
end