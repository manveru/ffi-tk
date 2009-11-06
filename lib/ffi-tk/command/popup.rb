module Tk
  # This procedure posts a menu at a given position on the screen and configures
  # Tk so that the menu and its cascaded children can be traversed with the
  # mouse or the keyboard.
  # +menu+ is the name of a menu widget and +x+ and +y+ are the root coordinates
  # at which to display the menu.
  # If +entry+ is omitted, the menu's upper left corner is positioned at the
  # given point.
  # Otherwise +entry gives the index of an entry in +menu+ and the menu will be
  # positioned so that the +entry+ is positioned over the given point.
  def self.popup(menu, x, y, entry = None)
    Tk.execute_only(:tk_popup, menu, x, y, entry)
  end
end