# frozen_string_literal: true

module Tk
  class Canvas
    # Items of type polygon appear as polygonal or curved filled regions on the
    # display. [Polygon] supports coordinate indexing operations using the
    # [Canvas] methods: [Canvas.dchars], [Canvas.index], and [Canvas.insert].
    class Polygon < Item
      # Types from canvas(3tk) POLYGON ITEMS (which include -outlineoffset).
      # Like oval plus -joinstyle (:symbol), -splinesteps (:integer) and -smooth,
      # which is quad-state (boolean OR smoothing-method name) and so :string,
      # not :boolean -- see Line for why a :boolean would invert the "raw" method.
      item_options(
        dash: :string, activedash: :string, disableddash: :string,
        dashoffset: :string, fill: :color, activefill: :color,
        disabledfill: :color, offset: :string, outline: :color,
        activeoutline: :color, disabledoutline: :color, outlineoffset: :string,
        outlinestipple: :bitmap, activeoutlinestipple: :bitmap,
        disabledoutlinestipple: :bitmap, stipple: :bitmap,
        activestipple: :bitmap, disabledstipple: :bitmap, state: :symbol,
        tags: :list, width: :string, activewidth: :string,
        disabledwidth: :string, joinstyle: :symbol, smooth: :string,
        splinesteps: :integer
      )
    end
  end
end
