module Tk
  class Canvas
    class Item < Struct.new(:canvas, :id)
      OPTION_MAP = {
        activebackground:       :bitmap,
        activebitmap:           :bitmap,
        activedash:             :integer,
        activefill:             :color,
        activeforeground:       :bitmap,
        activeimage:            :string,
        activeoutline:          :color,
        activeoutlinestipple:   :bitmap,
        activestipple:          :bitmap,
        activewidth:            :integer,
        anchor:                 :string,
        arrow:                  :symbol,
        arrowshape:             :list,
        background:             :color,
        bitmap:                 :bitmap,
        capstyle:               :symbol,
        dash:                   :integer,
        dashoffset:             :integer,
        disabledbackground:     :bitmap,
        disabledbitmap:         :bitmap,
        disableddash:           :integer,
        disabledfill:           :color,
        disabledforeground:     :bitmap,
        disabledimage:          :string,
        disabledoutline:        :color,
        disabledoutlinestipple: :bitmap,
        disabledstipple:        :bitmap,
        disabledwidth:          :integer,
        extent:                 :float,
        fill:                   :color,
        font:                   :font,
        foreground:             :color,
        height:                 :integer,
        image:                  :string,
        joinstyle:              :symbol,
        justify:                :symbol,
        offset:                 :string,
        outline:                :color,
        outlineoffset:          :integer,
        outlinestipple:         :bitmap,
        smooth:                 :boolean,
        splinesteps:            :integer,
        start:                  :float,
        state:                  :symbol,
        stipple:                :bitmap,
        style:                  :symbol,
        tags:                   :list,
        text:                   :string,
        underline:              :integer,
        width:                  :integer,
        width:                  :integer,
        window:                 :pathname
      }

      def self.create(canvas, type, id)
        klass = Canvas.const_get(type.to_s.capitalize)
        klass.new(canvas, id)
      end

      OPTIONS_CODE = <<-RUBY
def %s
  Cget.type_to_ruby(%p, canvas.itemcget(id, %p))
end
      RUBY

      def self.options(*names)
        names.each do |name|
          type = OPTION_MAP.fetch(name)
          class_eval(OPTIONS_CODE % [name, type, name], __FILE__, __LINE__)
        end
      end

      def to_tcl
        TclString.new(id.to_s)
      end

      def inspect
        "#<%s %d>" % [self.class.name, id]
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

      def bind(sequence = None, &command)
        canvas.bind(self, sequence, &command)
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

      def configure(*arguments)
        canvas.itemconfigure(self, *arguments)
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