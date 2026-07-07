# frozen_string_literal: true

module Tk
  # A toplevel is similar to a frame except that it is created as a top-level
  # window: its X parent is the root window of a screen rather than the logical
  # parent from its path name.
  # The primary purpose of a toplevel is to serve as a container for dialog
  # boxes and other collections of widgets.
  # The only visible features of a toplevel are its background color and an
  # optional 3-D border to make the toplevel appear raised or sunken.
  class Toplevel < Widget
    include Configure
    include Cget

    # Option schema (toplevel(3tk) WIDGET-SPECIFIC + options(3tk) STANDARD).
    # -width/-height are screen distances (:string). -class/-colormap/-visual/
    # -screen/-use are creation-only descriptor strings; -container is a boolean;
    # -menu names the menubar widget (:pathname). Root inherits this schema for
    # free (it does not override tk_command).
    classic_options
    widget_options(
      class: :string,
      colormap: :string,
      container: :boolean,
      height: :string,
      menu: :pathname,
      screen: :string,
      use: :string,
      visual: :string,
      width: :string
    )

    def self.tk_command
      'toplevel'
    end
  end
end
