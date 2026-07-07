# frozen_string_literal: true

module Tk
  # A button that posts an associated menu when pressed.
  # Wraps Tk's `menubutton` command.
  class MenuButton < Button
    include Configure
    include Cget

    # Option schema (menubutton(3tk) WIDGET-SPECIFIC + options(3tk) STANDARD).
    # MenuButton overrides tk_command, so it inherits nothing from Button and
    # declares its full schema (and, unlike Button, has no -command/-default,
    # but adds -direction and -menu). -width/-height are integer counts, not
    # screen distances. -menu names the associated menu widget (:pathname).
    classic_options
    widget_options(
      direction: :symbol,
      height: :integer,
      indicatoron: :boolean,
      menu: :pathname,
      state: :symbol,
      width: :integer
    )

    def self.tk_command
      'menubutton'
    end
  end
end
