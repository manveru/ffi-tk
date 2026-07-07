# frozen_string_literal: true

module Tk
  module Option
    # The cross-widget "STANDARD OPTIONS" schemas Tk documents. These names do
    # not collide by type across widgets, so their Option types are shared.
    # Classic and themed (ttk) widgets have *different* standard sets, so there
    # are two schemas; a widget opts into exactly one via the DSL.
    #
    # Types are sourced from the Tk 8.6 man pages (options(3tk) for CLASSIC,
    # ttk_widget(3tk) for TTK). Screen-distance options (borderwidth, padx,
    # selectborderwidth, ...) are typed :string, not :integer: a widget built on
    # the old Tk_ConfigureWidget path reports cget for them as the ORIGINAL
    # distance string ("2m", "3c", "2i"), while a Tk_SetOptions widget reports a
    # pixel count -- and it varies per (widget, option), so Label -borderwidth
    # gives "2m" but Listbox -borderwidth gives "8", and Text -selectborderwidth
    # gives "2m" but Text -insertwidth gives "8". One shared type must serve
    # every classic widget losslessly, so it keeps the raw string; a consumer
    # that wants pixels converts on demand. Genuine integers (an -underline
    # index, the millisecond options) stay :integer -- they never take a
    # distance suffix.
    module Standard
      # options(3tk) STANDARD OPTIONS, plus the documented aliases bg/fg/bd.
      CLASSIC = Schema.new(
        types: {
          activebackground: :color,
          activeborderwidth: :string,
          activeforeground: :color,
          anchor: :symbol,
          background: :color,
          bitmap: :bitmap,
          borderwidth: :string,
          compound: :symbol,
          cursor: :string,
          disabledforeground: :color,
          exportselection: :boolean,
          font: :font,
          foreground: :color,
          highlightbackground: :color,
          highlightcolor: :color,
          highlightthickness: :string,
          # An image is referenced by its Tk image name; cget reports "" when
          # none is bound. Typed :string (the vocabulary has no :image type),
          # deliberately preserving Tk's "" rather than reshaping it to nil --
          # faithful to cget, per docs/adr/0001. The nil-means-unbound reading
          # is a conscious trade, not an oversight.
          image: :string,
          insertbackground: :color,
          insertborderwidth: :string,
          insertofftime: :integer,
          insertontime: :integer,
          insertwidth: :string,
          jump: :boolean,
          justify: :symbol,
          orient: :symbol,
          padx: :string,
          pady: :string,
          relief: :symbol,
          repeatdelay: :integer,
          repeatinterval: :integer,
          selectbackground: :color,
          selectborderwidth: :string,
          selectforeground: :color,
          setgrid: :boolean,
          takefocus: :string,
          text: :string,
          textvariable: :variable,
          troughcolor: :color,
          underline: :integer,
          wraplength: :string,
          xscrollcommand: :command,
          yscrollcommand: :command
        },
        aliases: {
          bg: :background,
          fg: :foreground,
          bd: :borderwidth
        }
      )

      # ttk_widget(3tk) STANDARD OPTIONS (plus the scrollable-widget scroll
      # commands). Themed widgets have no classic colours/relief; -takefocus can
      # be empty/0/1 or a command prefix, so it stays :string (lossless).
      TTK = Schema.new(
        types: {
          class: :string,
          cursor: :string,
          style: :string,
          takefocus: :string,
          xscrollcommand: :command,
          yscrollcommand: :command
        }
      )
    end
  end
end
