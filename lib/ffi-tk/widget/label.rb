module Tk
  # A label is a widget that displays a textual string, bitmap or image.
  #
  # If text is displayed, it must all be in a single font, but it can occupy
  # multiple lines on the screen (if it contains newlines or if wrapping occurs
  # because of the wrapLength option) and one of the characters may optionally
  # be underlined using the underline option.
  #
  # The label can be manipulated in a few simple ways, such as changing its
  # relief or text.
  # Additional options may be specified to configure aspects of the label such
  # as its colors, font, text, and initial relief.
  class Label < Widget
    include Cget, Configure

    def self.tk_command; 'label'; end
  end
end
