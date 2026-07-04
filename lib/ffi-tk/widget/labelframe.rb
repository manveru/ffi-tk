# frozen_string_literal: true

module Tk
  # A titled, bordered frame for grouping related widgets.
  # Wraps Tk's `labelframe` command.
  class LabelFrame < Frame
    include Configure
    include Cget

    def self.tk_command
      'labelframe'
    end
  end
end
