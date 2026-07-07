# frozen_string_literal: true

module Tk
  module Tile
    # A themed single-line text entry.
    # Wraps Tk's `ttk::entry`.
    class Entry < Tk::Entry
      def self.tk_command
        'ttk::entry'
      end
      include TileWidget

      # Option schema (ttk::entry WIDGET-SPECIFIC + ttk::widget STANDARD). The
      # themed entry has no classic -disabledbackground/-readonlybackground and
      # no -vcmd/-invcmd synonyms; -state is normal/disabled/readonly (:symbol),
      # -width a character count (:integer).
      ttk_options
      widget_options(
        background: :color,
        exportselection: :boolean,
        font: :font,
        foreground: :color,
        invalidcommand: :command,
        justify: :symbol,
        show: :string,
        state: :symbol,
        textvariable: :variable,
        validate: :symbol,
        validatecommand: :command,
        width: :integer
      )
    end
  end
end
