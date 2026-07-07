# frozen_string_literal: true

module Tk
  module Tile
    # A themed slider for a numeric range.
    # Wraps Tk's `ttk::scale`.
    class Scale < Tk::Scale
      def self.tk_command
        'ttk::scale'
      end
      include TileWidget

      # Option schema (ttk::scale WIDGET-SPECIFIC + ttk::widget STANDARD). The
      # themed scale drops the classic knobs (-resolution, -tickinterval, ...);
      # -from/-to/-value are real numbers (:float), -length a screen distance
      # reported verbatim (:string), -state the compatibility keyword (:symbol).
      ttk_options
      widget_options(
        command: :command,
        from: :float,
        length: :string,
        orient: :symbol,
        state: :symbol,
        to: :float,
        value: :float,
        variable: :variable
      )
    end
  end
end
