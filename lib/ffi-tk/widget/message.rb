module Tk
  # Create and manipulate message widgets
  #
  # A message is a widget that displays a textual string.
  #
  # A message widget has three special features.
  #
  # First, it breaks up its string into lines in order to produce a given aspect
  # ratio for the window.
  # The line breaks are chosen at word boundaries wherever possible (if not even
  # a single word would fit on a line, then the word will be split across
  # lines). Newline characters in the string will force line breaks; they can be
  # used, for example, to leave blank lines in the display.
  #
  # The second feature of a message widget is justification.
  # The text may be displayed left-justified (each line starts at the left side
  # of the window), centered on a line-by-line basis, or right-justified (each
  # line ends at the right side of the window).
  #
  # The third feature of a message widget is that it handles control characters
  # and non-printing characters specially.
  # Tab characters are replaced with enough blank space to line up on the next
  # 8-character boundary.
  # Newlines cause line breaks.
  # Other control characters (ASCII code less than 0x20) and characters not
  # defined in the font are displayed as a four-character sequence \xhh where hh
  # is the two-digit hexadecimal number corresponding to the character.
  # In the unusual case where the font does not contain all of the characters in
  # "0123456789abcdef\x" then control characters and undefined characters
  # are not displayed at all.
  class Message < Widget
    INITIALIZE_COMMAND = name.downcase.freeze
    include Cget, Configure
  end
end