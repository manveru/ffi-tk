# frozen_string_literal: true

module Tk
  module Option
    # The cross-widget "STANDARD OPTIONS" schemas Tk documents. These names do
    # not collide by type across widgets, so their Option types are shared.
    # Classic and themed (ttk) widgets have *different* standard sets, so there
    # are two schemas; a widget opts into exactly one via the DSL.
    #
    # Types are sourced from the Tk 8.6 man pages (options(3tk) for CLASSIC,
    # ttk_widget(3tk) for TTK). Screen-distance options (borderwidth, padx, ...)
    # are typed :integer: Tk reports them as pixel counts.
    module Standard
      # options(3tk) STANDARD OPTIONS, plus the documented aliases bg/fg/bd.
      CLASSIC = Schema.new(
        types: {
          activebackground: :color,
          activeborderwidth: :integer,
          activeforeground: :color,
          anchor: :symbol,
          background: :color,
          bitmap: :bitmap,
          borderwidth: :integer,
          compound: :symbol,
          cursor: :string,
          disabledforeground: :color,
          exportselection: :boolean,
          font: :font,
          foreground: :color,
          highlightbackground: :color,
          highlightcolor: :color,
          highlightthickness: :integer,
          image: :string,
          insertbackground: :color,
          insertborderwidth: :integer,
          insertofftime: :integer,
          insertontime: :integer,
          insertwidth: :integer,
          jump: :boolean,
          justify: :symbol,
          orient: :symbol,
          padx: :integer,
          pady: :integer,
          relief: :symbol,
          repeatdelay: :integer,
          repeatinterval: :integer,
          selectbackground: :color,
          selectborderwidth: :integer,
          selectforeground: :color,
          setgrid: :boolean,
          takefocus: :string,
          text: :string,
          textvariable: :variable,
          troughcolor: :color,
          underline: :integer,
          wraplength: :integer,
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
