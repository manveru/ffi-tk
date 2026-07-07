# frozen_string_literal: true

module Tk
  class Canvas
    Item = Struct.new(:canvas, :id) do
      OPTION_MAP = {
        activebackground: :bitmap,
        activebitmap: :bitmap,
        activedash: :integer,
        activefill: :color,
        activeforeground: :bitmap,
        activeimage: :string,
        activeoutline: :color,
        activeoutlinestipple: :bitmap,
        activestipple: :bitmap,
        activewidth: :integer,
        anchor: :string,
        arrow: :symbol,
        arrowshape: :list,
        background: :color,
        bitmap: :bitmap,
        capstyle: :symbol,
        dash: :integer,
        dashoffset: :integer,
        disabledbackground: :bitmap,
        disabledbitmap: :bitmap,
        disableddash: :integer,
        disabledfill: :color,
        disabledforeground: :bitmap,
        disabledimage: :string,
        disabledoutline: :color,
        disabledoutlinestipple: :bitmap,
        disabledstipple: :bitmap,
        disabledwidth: :integer,
        extent: :float,
        fill: :color,
        font: :font,
        foreground: :color,
        height: :integer,
        image: :string,
        joinstyle: :symbol,
        justify: :symbol,
        offset: :string,
        outline: :color,
        outlineoffset: :integer,
        outlinestipple: :bitmap,
        smooth: :boolean,
        splinesteps: :integer,
        start: :float,
        state: :symbol,
        stipple: :bitmap,
        style: :symbol,
        tags: :list,
        text: :string,
        underline: :integer,
        width: :integer,
        window: :pathname
      }.freeze

      class << self
        # This item type's frozen Option schema (canvas(3tk) item sections),
        # declared via item_options. nil on the abstract Item base.
        attr_reader :item_schema

        # Declare this item type's Option schema and generate a typed reader per
        # option. Each reader routes through itemcget, so it coerces the raw Tcl
        # string by the option's declared type (immune to shimmering). Replaces
        # the legacy OPTION_MAP lookup as the source of truth for item options.
        def item_options(types)
          @item_schema = Option::Schema.new(types: types)
          types.each_key { |name| define_method(name) { cget(name) } }
        end

        # The Item subclass implementing canvas item +type+ (:rectangle ->
        # Canvas::Rectangle).
        def class_for(type)
          Canvas.const_get(type.to_s.capitalize)
        end

        def create(canvas, type, id)
          class_for(type).new(canvas, id)
        end
      end

      def to_tcl
        TclString.new(id.to_s)
      end

      def inspect
        format('#<%s %d>', self.class.name, id)
      end

      def cget(option)
        canvas.itemcget(self, option)
      end

      def addtag(tag)
        canvas.addtag_withtag(tag, self)
      end

      def bbox
        canvas.bbox(self)
      end

      def bind(sequence = None, &)
        canvas.bind(self, sequence, &)
      end

      def coords(*coord_list)
        canvas.coords(self, *coord_list)
      end

      def dchars(first, last = None)
        canvas.dchars(self, first, last)
      end

      def delete
        canvas.delete(self)
      end

      def dtag(tag)
        canvas.dtag(self, tag)
      end

      def focus
        canvas.focus(self)
      end

      def gettags
        canvas.gettags(self)
      end

      def icursor(index)
        canvas.icursor(self, index)
      end

      def index(index)
        canvas.index(self, index)
      end

      def configure(options = None)
        canvas.itemconfigure(self, options)
      end

      def lower(below = None)
        canvas.lower(self, below)
      end

      def move(x_amount, y_amount)
        canvas.move(self, x_amount, y_amount)
      end

      def raise(above = None)
        canvas.raise(self, above)
      end

      def scale(x_origin, y_origin, x_scale, y_scale)
        canvas.scale(self, x_origin, y_origin, x_scale, y_scale)
      end

      def select_adjust(index)
        canvas.select_adjust(self, index)
      end

      def select_from(index)
        canvas.select_from(self, index)
      end

      def select_to(index)
        canvas.select_to(self, index)
      end

      def type
        canvas.type(self)
      end
    end
  end
end
