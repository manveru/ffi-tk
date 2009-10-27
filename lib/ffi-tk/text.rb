module Tk
  class Text < Widget
    def initialize(parent, options = {})
      @parent = parent
      Tk.execute('text', assign_pathname, options)
    end

    # pathName insert index chars ?tagList chars tagList ...?
    #
    # Inserts all of the chars arguments just before the character at index.
    #
    # If index refers to the end of the text (the character after the last
    # newline) then the new text is inserted just before the last newline
    # instead.
    # If there is a single chars argument and no tagList, then the new text will
    # receive any tags that are present on both the character before and the
    # character after the insertion point; if a tag is present on only one of
    # these characters then it will not be applied to the new text.
    # If tagList is specified then it consists of a list of tag names; the new
    # characters will receive all of the tags in this list and no others,
    # regardless of the tags present around the insertion point.
    # If multiple chars-tagList argument pairs are present, they produce the
    # same effect as if a separate pathName insert widget command had been
    # issued for each pair, in order.
    # The last tagList argument may be omitted.
    def insert(index, string, taglist = nil, *rest)
      execute('insert', index, *[string, taglist, *rest].compact)
    end
  end
end