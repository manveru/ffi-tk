module Tk
  module Scrollable

    # Returns a list containing two elements.
    # Each element is a real fraction between 0 and 1; together they describe
    # the portion of the document's horizontal span that is visible in the
    # window. For example, if the first element is .2 and the second element is
    # .6, 20% of the text is off-screen to the left, the middle 40% is visible
    # in the window, and 40% of the text is off-screen to the right.
    # The fractions refer only to the lines that are actually visible in the
    # window: if the lines in the window are all very short, so that they are
    # entirely visible, the returned fractions will be 0 and 1, even if there
    # are other lines in the text that are much wider than the window.
    # These are the same values passed to scrollbars via the -xscrollcommand
    # option.
    def xview(index = None)
      if None == index
        execute(:xview).to_a(&:to_f)
      else
        execute_only(:xview, index)
      end
    end

    # Adjusts the view in the window so that fraction of the horizontal span of
    # the text is off-screen to the left.
    # Fraction is a fraction between 0 and 1.
    def xview_moveto(fraction)
      execute_only(:xview, :moveto, fraction)
    end

    # This command shifts the view in the window left or right according to
    # number and what.
    # What must be units, pages or pixels.
    # If what is units or pages then number must be an integer, otherwise
    # number may be specified in any of the forms acceptable to
    # Tk_GetPixels, such as "2.0c" or "1i" (the result is rounded to the
    # nearest integer value.
    # If no units are given, pixels are assumed).
    # If what is units, the view adjusts left or right by number
    # average-width characters on the display; if it is pages then the view
    # adjusts by number screenfuls; if it is pixels then the view adjusts by
    # number pixels.
    # If number is negative then characters farther to the left become visible;
    # if it is positive then characters farther to the right become visible.
    def xview_scroll(number, what)
      execute_only(:xview, :scroll, number, what)
    end

    # Returns a list containing two elements, both of which are real fractions
    # between 0 and 1.
    # The first element gives the position of the first visible pixel of the
    # first character (or image, etc) in the top line in the window, relative
    # to the text as a whole (0.5 means it is halfway through the text, for
    # example). The second element gives the position of the first pixel just
    # after the last visible one in the bottom line of the window, relative to
    # the text as a whole.
    # These are the same values passed to scrollbars via the -yscrollcommand
    # option.
    #
    # This command makes the first character on the line after the one given by
    # number visible at the top of the window.
    # Number must be an integer.
    # This command used to be used for scrolling, but now it is obsolete.
    def yview(index = None)
      if None == index
        execute(:yview).to_a(&:to_f)
      else
        execute_only(:yview, index)
      end
    end


    # Adjusts the view in the window so that the pixel given by fraction
    # appears at the top of the top line of the window.
    # Fraction is a fraction between 0 and 1; 0 indicates the first pixel of
    # the first character in the text, 0.33 indicates the pixel that is
    # one-third the way through the text; and so on.
    # Values close to 1 will indicate values close to the last pixel in the
    # text (1 actually refers to one pixel beyond the last pixel), but in
    # such cases the widget will never scroll beyond the last pixel, and so a
    # value of 1 will effectively be rounded back to whatever fraction
    # ensures the last pixel is at the bottom of the window, and some other
    # pixel is at the top.
    def yview_moveto(fraction)
      execute_only(:yview, :moveto, fraction)
    end

    # This command adjust the view in the window up or down according to number
    # and what.
    # What must be units, pages or pixels.
    # If what is units or pages then number must be an integer, otherwise
    # number may be specified in any of the forms acceptable to
    # Tk_GetPixels, such as "2.0c" or "1i" (the result is rounded to the
    # nearest integer value.
    # If no units are given, pixels are assumed).
    # If what is units, the view adjusts up or down by number lines on the
    # display; if it is pages then the view adjusts by number screenfuls; if
    # it is pixels then the view adjusts by number pixels.
    # If number is negative then earlier positions in the text become visible;
    # if it is positive then later positions in the text become visible.
    def yview_scroll(number, what)
      execute_only(:yview, :scroll, number, what)
    end

    # Changes the view in the widget's window to make index visible.
    #
    # The widget chooses where index appears in the window:
    # [1] If index is already visible somewhere in the window then the command
    #     does nothing.
    # [2] If index is only a few lines off-screen above the window then it will
    #     be positioned at the top of the window.
    # [3] If index is only a few lines off-screen below the window then it will
    #     be positioned at the bottom of the window.
    # [4] Otherwise, index will be centered in the window.
    #
    # The [yview_pickplace] method has been obsoleted by the [see] method.
    # [see] handles both x- and y-motion to make a location visible, whereas the
    # [yview_pickplace] mode only handles motion in y).
    def yview_pickplace(index)
      execute(:yview, '-pickplace', index)
    end

    def yscrollbar(sbar)
      @yscrollbar = sbar
      @yscrollbar.orient :vertical

      self.yscrollcommand {|*arg| @yscrollbar.set(*arg); true }
      @yscrollbar.command {|action,fraction| self.yview_moveto(fraction) }
      @yscrollbar
    end

    def xscrollbar(sbar)
      @xscrollbar = sbar
      @xscrollbar.orient :horizontal

      self.xscrollcommand {|*arg| @xscrollbar.set(*arg); true }
      @xscrollbar.command {|action,fraction| self.xview_moveto(fraction) }
      @xscrollbar
    end

    def xscrollcommand(&block)
      configure(:xscrollcommand => block) if block
    end

    def yscrollcommand(&block)
      configure(:yscrollcommand => block) if block
    end

  end
end

