# frozen_string_literal: true

module Tk
  # Create and manipulate frame widgets
  # A frame is a simple widget.
  # Its primary purpose is to act as a spacer or container for complex window
  # layouts. The only features of a frame are its background color and an
  # optional 3-D border to make the frame appear raised or sunken.
  class Frame < Widget
    include Configure
    include Cget

    # Option schema (frame(3tk) WIDGET-SPECIFIC + options(3tk) STANDARD).
    # -width/-height are screen distances (Tk_GetPixels), so they keep the raw
    # string per the standard-set screen-distance rule. -class/-colormap/-visual
    # are creation-only descriptor strings; -container is a boolean.
    classic_options
    widget_options(
      class: :string,
      colormap: :string,
      container: :boolean,
      height: :string,
      visual: :string,
      width: :string
    )

    def self.tk_command
      'frame'
    end
  end
end
