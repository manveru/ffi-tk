module Tk
  # Change a window's position in the stacking order
  #
  # FIXME: this will shadow Kernel#raise, alternatives?
  module Raise
    def raise(above = None)
      Raise.raise(self, above)
    end

    module_function

    # If the +above+ argument is omitted then the command raises window so that
    # it is above all of its siblings in the stacking order (it will not be
    # obscured by any siblings and will obscure any siblings that overlap it).
    #
    # If +above+ is specified then it must be the path name of a window that is
    # either a sibling of window or the descendant of a sibling of window.
    # In this case the raise command will insert window into the stacking order
    # just above +above+ or the ancestor of +above+ that is a sibling of
    # window); this could end up either raising or lowering window.
    def raise(window, above = None)
      Tk.execute_only(:raise, window, above)
    end
  end
end
