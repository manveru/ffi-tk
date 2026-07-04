# frozen_string_literal: true

module Tk
  class MenuButton < Button
    include Configure
    include Cget

    def self.tk_command
      'menubutton'
    end
  end
end
