module Tk
  # Create and manipulate frame widgets
  # A frame is a simple widget.
  # Its primary purpose is to act as a spacer or container for complex window
  # layouts. The only features of a frame are its background color and an
  # optional 3-D border to make the frame appear raised or sunken.
  class Frame < Widget
    include Cget, Configure

    def self.tk_command; 'frame'; end
  end
end
