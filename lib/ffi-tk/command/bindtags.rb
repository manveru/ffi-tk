module Tk
  # Determine which bindings apply to a window, and order of evaluation
  #
  # When a binding is created with the [Bind.bind] command, it is associated
  # either with a particular window such as .a.b.c, a class name such as Button,
  # the keyword all, or any other string.
  # All of these forms are called binding tags.
  # Each window contains a list of binding tags that determine how events are
  # processed for the window.
  #
  # When an event occurs in a window, it is applied to each of the window's tags
  # in order: for each tag, the most specific binding that matches the given tag
  # and event is executed.
  #
  # See the [Bind.bind] command for more information on the matching process.
  module Bindtags
    # By default, each window has four binding tags consisting of the name of
    # the window, the window's class name, the name of the window's nearest
    # toplevel ancestor, and all, in that order.
    # Toplevel windows have only three tags by default, since the toplevel name
    # is the same as that of the window.
    # The bindtags command allows the binding tags for a window to be read and
    # modified.
    #
    # If bindtags is invoked with only one argument, then the current set of
    # binding tags for +window+ is returned as a list.
    # If the +taglist+ argument is specified to bindtags, then it must be a
    # proper list; the tags for +window+ are changed to the elements of the
    # list. The elements of +taglist+ may be arbitrary strings; however, any tag
    # starting with a dot is treated as the name of a window; if no window by
    # that name exists at the time an event is processed, then the tag is
    # ignored for that event.
    # The order of the elements in +taglist+ determines the order in which
    # binding scripts are executed in response to events.
    #
    # @example reversing order for .b
    #   tags = Bindtags.bindtags('.b')
    #   Bindtag.bindtags('.b', *tags.reverse)
    #
    # The above example reverses the order in which binding scripts will be
    # evaluated for a button named `.b` so that all bindings are invoked first,
    # following by bindings for `.b`'s toplevel (`.`), followed by class
    # bindings, followed by bindings for `.b`.
    # If +taglist+ is an empty list then the binding tags for +window+ are
    # returned to the default state described above.
    def self.bindtags(window, *taglist)
      if taglist.empty?
        Tk.execute(:bindtags, window)
      else
        taglist = taglist.flatten
        Tk.execute(:bindtags, window, taglist)
      end
    end
  end
end