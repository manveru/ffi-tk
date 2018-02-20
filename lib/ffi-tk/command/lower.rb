# frozen_string_literal: true
module Tk
  # Change a window's position in the stacking order
  module Lower
    def lower(below = None)
      Lower.lower(self, below)
    end

    module_function

    # If the +below+ argument is omitted then the command lowers window so that
    # it is below all of its siblings in the stacking order (it will be obscured
    # by any siblings that overlap it and will not obscure any siblings).
    #
    # If +below+ is specified then it must be the path name of a window that is
    # either a sibling of window or the descendant of a sibling of window.
    # In this case the lower command will insert window into the stacking order
    # just below +below+ or the ancestor of +below+ that is a sibling of
    # window); this could end up either raising or lowering window.
    def lower(below = None)
      Tk.execute_only(:lower, window, below)
    end
  end
end
