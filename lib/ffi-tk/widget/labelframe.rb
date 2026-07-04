# frozen_string_literal: true

module Tk
  class LabelFrame < Frame
    include Configure
    include Cget

    def self.tk_command
      'labelframe'
    end
  end
end
