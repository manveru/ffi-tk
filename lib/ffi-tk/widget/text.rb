module Tk
  class Text < Widget
    autoload :Peer, 'ffi-tk/widget/text/peer'
    include Cget, Configure

    def initialize(parent, options = {})
      @parent = parent
      Tk.execute('text', assign_pathname, options)
    end

    # Returns a list of four elements describing the screen area of the
    # character given by index.
    # The first two elements of the list give the x and y coordinates of the
    # upper-left corner of the area occupied by the character, and the last two
    # elements give the width and height of the area.
    # If the character is only partially visible on the screen, then the return
    # value reflects just the visible part.
    # If the character is not visible on the screen then the return value is an
    # empty list.
    def bbox(index)
      execute('bbox', index)
    end

    # Compares the indices given by index1 and index2 according to the
    # relational operator given by op, and returns 1 if the relationship is
    # satisfied and 0 if it is not.
    # Op must be one of the operators <, <=, ==, >=, >, or !=.
    # If op is == then 1 is returned if the two indices refer to the same
    # character, if op is < then 1 is returned if index1 refers to an earlier
    # character in the text than index2, and so on.
    def compare(index1, op, index2)
      execute('compare', index1, op, index2) == 1
    end

    # Counts the number of relevant things between the two indices.
    # If index1 is after index2, the result will be a negative number (and this
    # holds for each of the possible options).
    # The actual items which are counted depend on the options given.
    # The result is a list of integers, one for the result of each counting option given.
    #
    # Valid counting options are :chars, :displaychars, :displayindices,
    # :displaylines, :indices, :lines, :xpixels and :ypixels.
    # The default value, if no option is specified, is :indices.
    # There is an additional possible option :update which is a modifier.
    # If given, then all subsequent options ensure that any possible out of date
    # information is recalculated.
    # This currently only has any effect for the :ypixels count (which, if
    # :update is not given, will use the text widget's current cached value for
    # each line).
    # The count options are interpreted as follows:
    #
    # :chars
    #   count all characters, whether elided or not. Do not count embedded
    #   windows or images.
    # :displaychars
    #   count all non-elided characters.
    # :displayindices
    #   count all non-elided characters, windows and images.
    # :displaylines
    #   count all display lines (i.e. counting one for each time a line wraps)
    #   from the line of the first index up to, but not including the display
    #   line of the second index. Therefore if they are both on the same display
    #   line, zero will be returned. By definition displaylines are visible and
    #   therefore this only counts portions of actual visible lines.
    # :indices
    #   count all characters and embedded windows or images (i.e. everything
    #   which counts in text-widget index space), whether they are elided or
    #   not.
    # :lines
    #   count all logical lines (irrespective of wrapping) from the line of the
    #   first index up to, but not including the line of the second index.
    #   Therefore if they are both on the same line, zero will be returned.
    #   Logical lines are counted whether they are currently visible
    #   (non-elided) or not.
    # :xpixels
    #   count the number of horizontal pixels from the first pixel of the first
    #   index to (but not including) the first pixel of the second index. To
    #   count the total desired width of the text widget (assuming wrapping is
    #   not enabled), first find the longest line and then use
    #   `text.count("#{line}.0", "#{line}.0", :xpixels)`.
    # :ypixels
    #   count the number of vertical pixels from the first pixel of the first
    #   index to (but not including) the first pixel of the second index. If
    #   both indices are on the same display line, zero will be returned. To
    #   count the total number of vertical pixels in the text widget, use
    #   `text.count('1.0', 'end', :ypixels)`, and to ensure this is up to date,
    #   use `text.count('1.0', 'end', :update, :ypixels)`.
    #
    # The command returns a positive or negative integer corresponding to the
    # number of items counted between the two indices. One such integer is
    # returned for each counting option given, so a list is returned if more
    # than one option was supplied. For example `text.count('1.3', '4.5',
    # :xpixels, :ypixels` is perfectly valid and will return a list of two
    # elements.
    def count(*options, index1, index2)
      args = options.map{|option| tcl_option(option) }
      execute('count', *args, index1, index2)
    end

    # If boolean is specified, then it must have one of the true or false values
    # accepted by Tcl_GetBoolean.
    # If the value is a true one then internal consistency checks will be turned
    # on in the B-tree code associated with text widgets.
    # If boolean has a false value then the debugging checks will be turned off.
    # In either case the command returns an empty string.
    # If boolean is not specified then the command returns on or off to indicate
    # whether or not debugging is turned on.
    # There is a single debugging switch shared by all text widgets: turning
    # debugging on or off in any widget turns it on or off for all widgets.
    # For widgets with large amounts of text, the consistency checks may cause a
    # noticeable slow-down.
    # When debugging is turned on, the drawing routines of the text widget set
    # the global variables tk_textRedraw and tk_textRelayout to the lists of
    # indices that are redrawn.
    # The values of these variables are tested by Tk's test suite.
    def debug(boolean = None)
      if boolean == None
        execute('debug') == 1
      else
        execute_only('debug', boolean ? true : false)
      end
    end

    def debug?
      execute('debug') == 1
    end

    # Delete a range of characters from the text.
    # If both index1 and index2 are specified, then delete all the characters
    # starting with the one given by index1 and stopping just before index2
    # (i.e. the character at index2 is not deleted).
    # If index2 does not specify a position later in the text than index1 then
    # no characters are deleted.
    # If index2 is not specified then the single character at index1 is deleted.
    # It is not allowable to delete characters in a way that would leave the
    # text without a newline as the last character.
    # The command returns an empty string.
    # If more indices are given, multiple ranges of text will be deleted.
    # All indices are first checked for validity before any deletions are made.
    # They are sorted and the text is removed from the last range to the first
    # range to deleted text does not cause an undesired index shifting
    # side-effects.
    # If multiple ranges with the same start index are given, then the longest
    # range is used.
    # If overlapping ranges are given, then they will be merged into spans that
    # do not cause deletion of text outside the given ranges due to text shifted
    # during deletion.
    def delete(index1, *rest)
      execute('delete', index1, *rest)
    end

    # Returns a list with five elements describing the area occupied by the
    # display line containing index.
    # The first two elements of the list give the x and y coordinates of the
    # upper-left corner of the area occupied by the line, the third and fourth
    # elements give the width and height of the area, and the fifth element
    # gives the position of the baseline for the line, measured down from the
    # top of the area.
    # All of this information is measured in pixels.
    # If the current wrap mode is none and the line extends beyond the
    # boundaries of the window, the area returned reflects the entire area of
    # the line, including the portions that are out of the window.
    # If the line is shorter than the full width of the window then the area
    # returned reflects just the portion of the line that is occupied by
    # characters and embedded windows.
    # If the display line containing index is not visible on the screen then the
    # return value is an empty list.
    def dlineinfo(index)
      execute('dlineinfo', index).map(&:to_i)
    end

    # Return the contents of the text widget from index1 up to, but not
    # including index2, including the text and information about marks, tags,
    # and embedded windows. If index2 is not specified, then it defaults to one
    # character past index1. The information is returned in the following
    # format:
    #
    # pathName dump ?switches? index1 ?index2?
    def dump(*arguments, given_index)
      arguments = arguments.dup
      invocation = []
      indices = [given_index]

      while arg = arguments.shift
        case arg.to_s
        when /^-?command$/
          command = arguments.shift
          invocation << ['-command', command]
        when /^-?(all|image|mark|tag|text|window)$/
          invocation << tcl_option(arg)
        else
          indices.unshift(arg)
        end
      end

      execute('dump', *invocation, *indices)
    end

    # If boolean is not specified, returns the modified flag of the widget.
    # The insert, delete, edit undo and edit redo commands or the user can set
    # or clear the modified flag.
    # If boolean is specified, sets the modified flag of the widget to boolean.
    def edit_modified(boolean = None)
      if boolean == None
        execute('edit', 'modified')
      else
        execute_only('edit', 'modified', boolean ? true : false)
      end
    end

    def edit_modified?
      execute('edit', 'modified')
    end

    # When the -undo option is true, reapplies the last undone edits provided no
    # other edits were done since then.
    # Generates an error when the redo stack is empty.
    # Does nothing when the -undo option is false.
    def edit_redo
      execute_only('edit', 'redo')
    end

    # Clears the undo and redo stacks.
    def edit_reset
      execute_only('edit', 'reset')
    end

    # Inserts a separator (boundary) on the undo stack. Does nothing when the
    # -undo option is false.
    def edit_separator
      execute_only('edit', 'separator')
    end

    # Undoes the last edit action when the -undo option is true.
    # An edit action is defined as all the insert and delete commands that are
    # recorded on the undo stack in between two separators.
    # Generates an error when the undo stack is empty.
    # Does nothing when the -undo option is false.
    def edit_undo
      execute_only('edit', 'undo')
    end

    # Return a range of characters from the text.
    #
    # The return value will be all the characters in the text starting with the
    # one whose index is index1 and ending just before the one whose index is
    # index2 (the character at index2 will not be returned).
    #
    # If index2 is omitted then the single character at index1 is returned.
    # If there are no characters in the specified range (e.g. index1 is past the
    # end of the file or index2 is less than or equal to index1) then an empty
    # string is returned.
    #
    # If the specified range contains embedded windows, no information about
    # them is included in the returned string.
    # If multiple index pairs are given, multiple ranges of text will be
    # returned in a list.
    # Invalid ranges will not be represented with empty strings in the list.
    # The ranges are returned in the order passed to [get].
    #
    # @see get_displaychars
    def get(index, *indices)
      execute('get', index, *indices).to_s
    end

    # Same as [get], but within each range, only those characters which are not
    # elided will be returned.
    # This may have the effect that some of the returned ranges are empty
    # strings.
    def get_displaychars(index, *indices)
      execute('get', '-displaychars', index, *indices)
    end

    def image_cget(index, option)
      option = tcl_option(option)
      option_to_ruby(option, execute('image', 'cget', index))
    end

    # Query or modify the configuration options for an embedded image.
    # If no option is specified, returns a list describing all of the available
    # options for the embedded image at index (see Tk_ConfigureInfo for
    # information on the format of this list).
    # If option is specified with no value, then the command returns a list
    # describing the one named option (this list will be identical to the
    # corresponding sublist of the value returned if no option is specified).
    # If one or more option-value pairs are specified, then the command modifies
    # the given option(s) to have the given value(s); in this case the command
    # returns an empty string.
    # See EMBEDDED IMAGES for information on the options that are supported.
    def image_configure(index, *arguments)
      if arguments.empty?
        execute('image', 'configure', index)
      elsif arguments.size == 1 && arguments.first.respond_to?(:to_hash)
        execute_only('image', 'configure', index, arguments.first.to_hash)
      elsif arguments.size == 1
        argument = tcl_option(arguments.first)
        value = execute('image', 'configure', index, argument)
        option_to_ruby(argument, value)
      else
        raise ArgumentError, "Invalid arguments: %p" % [arguments]
      end
    end

    # This command creates a new image annotation, which will appear in the text
    # at the position given by index.
    # Any number of option-value pairs may be specified to configure the
    # annotation.
    # Returns a unique identifier that may be used as an index to refer to this
    # image.
    # See EMBEDDED IMAGES for information on the options that are supported, and
    # a description of the identifier returned.
    def image_create(index, options = {})
      execute('image', 'create', index, options)
    end

    def image_names
      execute('image', 'names')
    end

    # Returns the position corresponding to index in the form line.char where
    # line is the line number and char is the character number. Index may have
    # any of the forms described under INDICES above.
    def index(index)
      execute('index', index)
    end

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
      execute_only('insert', index, *[string, taglist, *rest].compact)
    end

    # If direction is not specified, returns left or right to indicate which of
    # its adjacent characters markName is attached to.
    # If direction is specified, it must be left or right; the gravity of
    # markName is set to the given value.
    def mark_gravity(name, direction = None)
      if direction == None
        execute('mark', 'gravity', name).to_sym
      else
        execute_only('mark', 'gravity', name, direction)
      end
    end

    # Returns a list whose elements are the names of all the marks that are
    # currently set.
    def mark_names
      execute('mark', 'names').to_a.map(&:to_sym)
    end

    # Returns the name of the next mark at or after index.
    # If index is specified in numerical form, then the search for the next mark
    # begins at that index.
    # If index is the name of a mark, then the search for the next mark begins
    # immediately after that mark.
    # This can still return a mark at the same position if there are multiple
    # marks at the same index.
    # These semantics mean that the mark next operation can be used to step
    # through all the marks in a text widget in the same order as the mark
    # information returned by the pathName dump operation.
    # If a mark has been set to the special end index, then it appears to be
    # after end with respect to the pathName mark next operation.
    # nil is returned if there are no marks after index.
    def mark_next(index)
      execute('mark', 'next', index).to_sym
    end

    # Returns the name of the mark at or before index.
    # If index is specified in numerical form, then the search for the previous
    # mark begins with the character just before that index.
    # If index is the name of a mark, then the search for the next mark begins
    # immediately before that mark.
    # This can still return a mark at the same position if there are multiple
    # marks at the same index.
    # These semantics mean that the pathName mark previous operation can be used
    # to step through all the marks in a text widget in the reverse order as the
    # mark information returned by the pathName dump operation.
    # nil is returned if there are no marks before index.
    def mark_previous(index)
      execute('mark', 'previous', index).to_sym
    end

    # Sets the mark named markName to a position just before the character at
    # index.
    # If markName already exists, it is moved from its old position; if it does
    # not exist, a new mark is created.
    def mark_set(name, index)
      execute_only('mark', 'set', name, index)
    end

    # Remove the mark corresponding to each of the markName arguments.
    # The removed marks will not be usable in indices and will not be returned
    # by future calls to [mark_names].
    def mark_unset(*names)
      execute_only('mark', 'unset', *names)
    end

    def peer_create(options = {})
      Peer.new(self)
    end

    def peer_names
      execute('peer', 'names').to_a.map(&:to_s)
    end
  end
end