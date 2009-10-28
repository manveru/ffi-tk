module Tk
  class EvalResult < String
    def initialize(string)
      super(string.to_s)
    end

    def to_array(type = nil)
      type ? split.map(&type) : split
    end

    def to_index
      self
    end

    def to_boolean
      case self
      when 'yes', '1'
        true
      when 'no', '0', ''
        false
      else
        raise "%p is not a boolean?" % [self]
      end
    end

    def to_color
      self
    end

    def to_font
      self
    end
  end
end