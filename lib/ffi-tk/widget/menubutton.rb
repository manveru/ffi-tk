# frozen_string_literal: true

module Tk
  # A button that posts an associated menu when pressed.
  # Wraps Tk's `menubutton` command.
  class MenuButton < Button
    include Configure
    include Cget

    def self.tk_command
      'menubutton'
    end
  end
end
