# frozen_string_literal: true

module Tk
  class Canvas
    # Items of type polygon appear as polygonal or curved filled regions on the
    # display. [Polygon] supports coordinate indexing operations using the
    # [Canvas] methods: [Canvas.dchars], [Canvas.index], and [Canvas.insert].
    class Polygon < Item
      # Types from canvas(3tk) POLYGON ITEMS. Like oval plus -joinstyle
      # (:symbol), -smooth (:boolean) and -splinesteps (:integer). Tk reports
      # -outlineoffset here too (the man page omits it), so it is declared.
      item_options(
        dash: :string, activedash: :string, disableddash: :string,
        dashoffset: :string, fill: :color, activefill: :color,
        disabledfill: :color, offset: :string, outline: :color,
        activeoutline: :color, disabledoutline: :color, outlineoffset: :string,
        outlinestipple: :bitmap, activeoutlinestipple: :bitmap,
        disabledoutlinestipple: :bitmap, stipple: :bitmap,
        activestipple: :bitmap, disabledstipple: :bitmap, state: :symbol,
        tags: :list, width: :string, activewidth: :string,
        disabledwidth: :string, joinstyle: :symbol, smooth: :boolean,
        splinesteps: :integer
      )
    end
  end
end
