module Tk
  module_function

  # Pops up a message window and waits for user response.
  # This procedure creates and displays a message window with an
  # application-specified message, an icon and a set of buttons.
  # Each of the buttons in the message window is identified by a unique symbolic
  # name (see the :type options).
  #
  # After the message window is popped up, [message_box] waits for the user to
  # select one of the buttons.
  # Then it returns the symbolic name of the selected button.
  #
  # The following options pairs are supported:
  #
  #   default: name
  #     Name gives the symbolic name of the default button for this message
  #     window (:ok, :cancel, and so on).
  #     See :type for a list of the symbolic names.
  #     If this option is not specified, the first button in the dialog will be
  #     made the default.
  #
  #   detail: string
  #     Specifies an auxiliary message to the main message given by the :message
  #     option. Where supported by the underlying OS, the message detail will be
  #     presented in a less emphasized font than the main message.
  #
  #   icon: icon_image
  #     Specifies an icon to display.
  #     icon_image must be one of the following: :error, :info, :question or
  #     :warning. If this option is not specified, then the info icon will be
  #     displayed.
  #
  #   message: string
  #     Specifies the message to display in this message box.
  #
  #   parent: window
  #     Makes window the logical parent of the message box.
  #     The message box is displayed on top of its parent window.
  #
  #   title: string
  #     Specifies a string to display as the title of the message box.
  #     The default value is an empty string.
  #
  #   type: predefined_type
  #     Arranges for a predefined set of buttons to be displayed.
  #
  # The following values are possible for predefined_type:
  #
  # :abortretryignore
  #   Displays three buttons whose symbolic names are :abort, :retry and :ignore.
  # :ok
  #   Displays one button whose symbolic name is :ok.
  # :okcancel
  #   Displays two buttons whose symbolic names are :ok and :cancel.
  # :retrycancel
  #   Displays two buttons whose symbolic names are :retry and :cancel.
  # :yesno
  #   Displays two buttons whose symbolic names are :yes and :no.
  # :yesnocancel
  #   Displays three buttons whose symbolic names are :yes, :no and :cancel.
  def message_box(options = None)
    Tk.execute(:tk_messageBox, options.to_tcl_options?).to_sym
  end
end