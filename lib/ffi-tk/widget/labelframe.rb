# frozen_string_literal: true

module Tk
  # A titled, bordered frame for grouping related widgets.
  # Wraps Tk's `labelframe` command.
  class LabelFrame < Frame
    include Configure
    include Cget

    # Option schema (labelframe(3tk) WIDGET-SPECIFIC + options(3tk) STANDARD).
    # LabelFrame overrides tk_command, so it inherits nothing from Frame and
    # declares its full schema. -width/-height are screen distances (:string);
    # -labelanchor is a keyword (:symbol); -labelwidget names the widget used as
    # the label (:pathname).
    classic_options
    widget_options(
      class: :string,
      colormap: :string,
      container: :boolean,
      height: :string,
      labelanchor: :symbol,
      labelwidget: :pathname,
      visual: :string,
      width: :string
    )

    def self.tk_command
      'labelframe'
    end
  end
end
