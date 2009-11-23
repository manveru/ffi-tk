module Tk
  class Text < Widget
    include Cget, Configure, Scrollable

    def self.tk_command; 'text'; end

    autoload :Peer, 'ffi-tk/widget/text/peer'

    SEARCH_MUTEX = Mutex.new

    def initialize(parent = Tk.root, options = None)
      @tag_commands = {}
      super
    end

    def value
      get '1.0', :end
    end

    def value=(string)
      clear
      insert :end, string
    end

    def clear
      delete '0.0', :end
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
    # If op is == then true is returned if the two indices refer to the same
    # character, if op is < then true is returned if index1 refers to an earlier
    # character in the text than index2, and so on.
    def compare(index1, op, index2)
      execute('compare', index1, op, index2).to_boolean
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
    def count(index1, index2, *options)
      args = options.map{|option| option.to_tcl_option }
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
      info = execute('dlineinfo', index).to_a
      info.empty? ? nil : info.map(&:to_i)
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
        case arg.to_tcl
        when '-command'
          command = arguments.shift
          invocation << ['-command', command]
        when /^-(all|image|mark|tag|text|window)$/
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
      execute('edit', 'modified').to_boolean
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
      Cget.option_to_ruby(option, execute('image', 'cget', index))
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
    def image_configure(index, options = None)
      common_configure([:image, :configure, index], options)
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
      execute('image', 'create', index, options.to_tcl_options)
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
        execute('mark', 'gravity', name).to_sym?
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
      execute('mark', 'next', index).to_sym?
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
      execute('mark', 'previous', index).to_sym?
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

    # Creates a peer text widget, and any optional standard configuration
    # options (as for the text command).
    # By default the peer will have the same start and end line as the parent
    # widget, but these can be overridden with the standard configuration
    # options.
    def peer_create(options = {})
      Peer.new(self, options)
    end

    # Returns a list of peers of this widget (this does not include the widget
    # itself). The order within this list is undefined.
    def peer_names
      execute('peer', 'names').to_a.map(&:to_s)
    end

    # Replaces the range of characters between +index1+ and +index2+ with the
    # given characters and tags.
    # See the section on [insert] for an explanation of the handling of taglist
    # arguments, and the docs of [delete] for an explanation of the handling of
    # the indices.
    # If +index2+ corresponds to an index earlier in the text than +index1+, an
    # error will be generated.
    # The deletion and insertion are arranged so that no unnecessary scrolling
    # of the window or movement of insertion cursor occurs.
    # In addition the undo/redo stack are correctly modified, if undo operations
    # are active in the text widget.
    # The command returns nil.
    def replace(index1, index2, chars, *taglists_and_chars)
      execute_only(:replace, index1, index2, chars, *taglists_and_chars)
    end

    # Records +x+ and +y+ and the current view in the text window, for use in
    # conjunction with later pathName scan dragto commands.
    # Typically this command is associated with a mouse button press in the
    # widget.
    # It returns nil.
    def scan_mark(x, y)
      execute_only(:scan, :mark, x, y)
    end

    # This command computes the difference between its +x+ and +y+ arguments and
    # the +x+ and +y+ arguments to the last pathName scan mark command for the
    # widget. It then adjusts the view by 10 times the difference in
    # coordinates. This command is typically associated with mouse motion events
    # in the widget, to produce the effect of dragging the text at high speed
    # through the window.
    # The return value is nil.
    def scan_dargto(x, y)
      execute_only(:scan, :dragto, x, y)
    end

    # Searches the text starting at index for a range of characters that matches
    # pattern.
    # If a match is found, the index of the first character in the match is
    # returned as result; otherwise an empty string is returned.
    # One or more of the following switches may be specified to control the
    # search:
    #
    #   :forwards
    #     The search will proceed forward through the text, finding the first
    #     matching range starting at or after the position given by index.
    #     This is the default.
    #
    #   :backwards
    #     The search will proceed backward through the text, finding the
    #     matching range closest to index whose first character is before index
    #     (it is not allowed to be at index).
    #     Note that, for a variety of reasons, backwards searches can be
    #     substantially slower than forwards searches (particularly when using
    #     :regexp), so it is recommended that performance-critical code use
    #     forward searches.
    #
    #   :exact
    #     Use exact matching: the characters in the matching range must be
    #     identical to those in pattern.
    #     This is the default.
    #
    #   :regexp
    #     Treat pattern as a regular expression and match it against the text
    #     using the rules for regular expressions (see the regexp command for
    #     details). The default matching automatically passes both the
    #     :lineanchor and :linestop options to the regexp engine (unless
    #     :nolinestop is used), so that "^", "$" match beginning and end of
    #     line, and ".", "[^" sequences will never match the newline character
    #     "\n".
    #
    #   :nolinestop
    #     This allows "." and "[^" sequences to match the newline character "\n",
    #     which they will otherwise not do (see the regexp command for details).
    #     This option is only meaningful if :regexp is also given, and an error
    #     will be thrown otherwise.
    #     For example, to match the entire text, use `text.search(/.*/m)`.
    #
    #   :nocase
    #     Ignore case differences between the pattern and the text.
    #
    #   :count varName
    #     The argument following :count gives the name of a variable; if a match
    #     is found, the number of index positions between beginning and end of
    #     the matching range will be stored in the variable.
    #     If there are no embedded images or windows in the matching range (and
    #     there are no elided characters if :elide is not given), this is
    #     equivalent to the number of characters matched.
    #     In either case, the range matchIdx to matchIdx + $count chars will
    #     return the entire matched text.
    #
    #   :all
    #     Find all matches in the given range and return a list of the indices of
    #     the first character of each match.
    #
    #     If a :count switch is given, then the returned array has two elements
    #     in the form of `[index, count]` for each successful match.
    #     Note that, even for exact searches, the elements of this list may be
    #     different, if there are embedded images, windows or hidden text.
    #     Searches with :all behave very similarly to the Tcl command regexp
    #     :all, in that overlapping matches are not normally returned.
    #     For example, applying an :all search of the pattern `\w+` against
    #     "hello there" will just match twice, once for each word, and
    #     matching `Z[a-z]+Z` against "ZooZooZoo" will just match once.
    #
    #   :overlap
    #     When performing :all searches, the normal behaviour is that matches
    #     which overlap an already-found match will not be returned.
    #     This switch changes that behaviour so that all matches which are not
    #     totally enclosed within another match are returned.
    #     For example, applying an :overlap search of the pattern `\w+`
    #     against "hello there" will just match twice (i.e.
    #     no different to just :all), but matching `Z[a-z]+Z` against
    #     "ZooZooZoo" will now match twice.
    #     An error will be thrown if this switch is used without :all.
    #
    #   :strictlimits
    #     When performing any search, the normal behaviour is that the start and
    #     stop limits are checked with respect to the start of the matching
    #     text. With the :strictlimits flag, the entire matching range must lie
    #     inside the start and stop limits specified for the match to be valid.
    #
    #   :elide
    #     Find elided (hidden) text as well.
    #     By default only displayed text is searched.
    #
    #   --
    #     This switch has no effect except to terminate the list of switches:
    #     the next argument will be treated as pattern even if it starts with -.
    #
    # The matching range may be within a single line of text, or run across
    # multiple lines (if parts of the pattern can match a new-line).
    # For regular expression matching one can use the various newline-matching
    # features such as $ to match the end of a line, "^" to match the beginning
    # of a line, and to control whether "." is allowed to match a new-line.
    # If stop_index is specified, the search stops at that index: for forward
    # searches, no match at or after stop_index will be considered; for backward
    # searches, no match earlier in the text than stop_index will be considered.
    # If stop_index is omitted, the entire text will be searched: when the
    # beginning or end of the text is reached, the search continues at the other
    # end until the starting location is reached again; if stop_index is
    # specified, no wrap-around will occur.
    # This means that, for example, if the search is :forwards but stop_index is
    # earlier in the text than start_index, nothing will ever be found.
    # See KNOWN BUGS in [Text] for a number of minor limitations of [search] method.
    #
    # pathName search ?switches? pattern index ?stopIndex?
    #
    # FUNNY: stdlib tk simply gets the text into the ruby side and performs
    #        matches using the core regexp methods, but doesn't give any way to
    #        call the tcl/tk search function, this is new land!
    def search(pattern, from, to = None, *switches)
      switches << :regexp if pattern.class < CoreExtensions::Regexp
      to = :end if None == to

      switches.map!{|switch| switch.to_s.to_tcl_option }
      switches.uniq!

      if switches.include?('-all') && switches.delete('-count')
        count_all = 'RubyFFI::Text_search_count'
        switches << '-count' << count_all
      elsif switches.delete('-count')
        count = 'RubyFFI::Text_search_count'
        switches << '-count' << count
      end

      sep = TclString.new('--')

      if count
        SEARCH_MUTEX.synchronize do
          list = execute(:search, *switches, sep, pattern, from, to).to_a
          return list if list.empty?
          count_value = Tk.execute('set', count)
          [*list, count_value]
        end
      elsif count_all
        SEARCH_MUTEX.synchronize do
          list = execute(:search, *switches, sep, pattern, from, to).to_a
          return list if list.empty?
          count_list = Tk.execute('set', count_all)
          list.zip(count_list)
        end
      else
        execute(:search, *switches, sep, pattern, from, to).to_a
      end
    end

    def rsearch(pattern, from, to, *switches)
      search(pattern, from, to, *switches, :backwards)
    end

    # Adjusts the view in the window so that the character given by +index+ is
    # completely visible.
    # If +index+ is already visible then the command does nothing.
    # If +index+ is a short distance out of view, the command adjusts the view
    # just enough to make +index+ visible at the edge of the window.
    # If +index+ is far out of view, then the command centers +index+ in the
    # window.
    def see(index)
      execute_only(:see, index)
    end

    # Associate the tag tagName with all of the characters starting with index1
    # and ending just before index2 (the character at index2 is not tagged).
    # A single command may contain any number of index1-index2 pairs.
    # If the last index2 is omitted then the single character at index1 is
    # tagged. If there are no characters in the specified range (e.g.
    # index1 is past the end of the file or index2 is less than or equal to
    # index1) then the command has no effect.
    def tag_add(tag_name, index1, index2 = None, *indices)
      execute_only(:tag, :add, tag_name, index1, index2, *indices)
    end

    # This command associates script with the tag given by tagName.
    # Whenever the event sequence given by sequence occurs for a character that
    # has been tagged with tagName, the script will be invoked.
    # This widget command is similar to the bind command except that it
    # operates on characters in a text rather than entire widgets.
    # See the bind manual entry for complete details on the syntax of sequence
    # and the substitutions performed on script before invoking it.
    # If all arguments are specified then a new binding is created, replacing
    # any existing binding for the same sequence and tagName (if the first
    # character of script is “+” then script augments an existing binding
    # rather than replacing it).
    # In this case the return value is an empty string.
    # If script is omitted then the command returns the script associated
    # with tagName and sequence (an error occurs if there is no such binding).
    # If both script and sequence are omitted then the command returns a list
    # of all the sequences for which bindings have been defined for tagName.
    # The only events for which bindings may be specified are those related to
    # the mouse and keyboard (such as Enter, Leave, ButtonPress, Motion, and
    # KeyPress) or virtual events.
    # Event bindings for a text widget use the current mark described under
    # MARKS above.
    # An Enter event triggers for a tag when the tag first becomes present on
    # the current character, and a Leave event triggers for a tag when it
    # ceases to be present on the current character.
    # Enter and Leave events can happen either because the current mark moved
    # or because the character at that position changed.
    # Note that these events are different than Enter and Leave events for
    # windows. Mouse and keyboard events are directed to the current character.
    # If a virtual event is used in a binding, that binding can trigger only if
    # the virtual event is defined by an underlying mouse-related or
    # keyboard-related event.
    # It is possible for the current character to have multiple tags, and for
    # each of them to have a binding for a particular event sequence.
    # When this occurs, one binding is invoked for each tag, in order from
    # lowest-priority to highest priority.
    # If there are multiple matching bindings for a single tag, then the most
    # specific binding is chosen (see the manual entry for the bind command
    # for details).
    # continue and break commands within binding scripts are processed in the
    # same way as for bindings created with the bind command.
    # If bindings are created for the widget as a whole using the bind command,
    # then those bindings will supplement the tag bindings.
    # The tag bindings will be invoked first, followed by bindings for the
    # window as a whole.
    def tag_bind(tag_name, sequence = None, &script)
      unless script
        if None == sequence
          return Tk.execute(:tag, :bind, tag_name)
        else
          return Tk.execute(:tag, :bind, tag_name, sequence)
        end
      end

      # create name for command
      name = "#{tk_pathname}_#{tag_name}".scan(/\w+/).join('_')
      @events ||= {}
      unregister_event(name)

      Event::Handler.register_custom(script) do |id|
        code = "%s tag bind %s %s { ::RubyFFI::event %d '' %s }"
        props = Event::Data::PROPERTIES.transpose[0].join(' ')
        tcl = code % [tk_pathname, tag_name, sequence, id, props]
        Tk.interp.eval(tcl)
        @events[name] = id
      end
    end

    def unregister_event(name, id = @events[name])
      return unless id
      @events.delete(id)
      Event::Handler.unregister(id)
    end

    # This command returns the current value of the option named option
    # associated with the tag given by tagName.
    # Option may have any of the values accepted by the pathName tag
    # configure widget command.
    def tag_cget(tag_name, option)
      execute(:tag, :cget, tag_name, option.to_tcl_option)
    end

    # This command is similar to the pathName configure widget command except
    # that it modifies options associated with the tag given by tagName instead
    # of modifying options for the overall text widget.
    # If no option is specified, the command returns a list describing all of
    # the available options for tagName (see Tk_ConfigureInfo for information
    # on the format of this list).
    # If option is specified with no value, then the command returns a list
    # describing the one named option (this list will be identical to the
    # corresponding sublist of the value returned if no option is specified).
    # If one or more option-value pairs are specified, then the command
    # modifies the given option(s) to have the given value(s) in tagName; in
    # this case the command returns an empty string.
    # See TAGS above for details on the options available for tags.
    def tag_configure(tag_name, options = None)
      common_configure([:tag, :configure, tag_name], options)
    end

    # Deletes all tag information for each of the tagName arguments.
    # The command removes the tags from all characters in the file and also
    # deletes any other information associated with the tags, such as
    # bindings and display information.
    # The command returns an empty string.
    def tag_delete(tag_name, *tag_names)
      execute_only(:tag, :delete, tag_name, *tag_names)
    end

    # Changes the priority of tag tagName so that it is just lower in priority
    # than the tag whose name is belowThis.
    # If belowThis is omitted, then tagName's priority is changed to make it
    # lowest priority of all tags.
    def tag_lower(tag_name, below = None)
      execute_only(:tag, :lower, tag_name, below)
    end

    # Returns a list whose elements are the names of all the tags that are
    # active at the character position given by index.
    # If index is omitted, then the return value will describe all of the tags
    # that exist for the text (this includes all tags that have been named in a
    # “pathName tag” widget command but have not been deleted by a “pathName
    # tag delete” widget command, even if no characters are currently marked
    # with the tag).
    # The list will be sorted in order from lowest priority to highest
    # priority.
    def tag_names(index = None)
      execute(:tag, :names, index).to_a
    end

    # This command searches the text for a range of characters tagged with
    # tagName where the first character of the range is no earlier than the
    # character at index1 and no later than the character just before index2 (a
    # range starting at index2 will not be considered).
    # If several matching ranges exist, the first one is chosen.
    # The command's return value is a list containing two elements, which are
    # the index of the first character of the range and the index of the
    # character just after the last one in the range.
    # If no matching range is found then the return value is an empty string.
    # If index2 is not given then it defaults to the end of the text.
    def tag_nextrange(tag_name, index1, index2 = None)
      execute(:tag, :nextrange, tag_name, index1, index2).to_a
    end

    # This command searches the text for a range of characters tagged with
    # tagName where the first character of the range is before the character at
    # index1 and no earlier than the character at index2 (a range starting at
    # index2 will be considered).
    # If several matching ranges exist, the one closest to index1 is chosen.
    # The command's return value is a list containing two elements, which are
    # the index of the first character of the range and the index of the
    # character just after the last one in the range.
    # If no matching range is found then the return value is an empty string.
    # If index2 is not given then it defaults to the beginning of the text.
    def tag_prevrange(tag_name, index1, index2 = None)
      execute(:tag, :prevrange, tag_name, index1, index2).to_a
    end

    # Changes the priority of tag tagName so that it is just higher in priority
    # than the tag whose name is aboveThis.
    # If aboveThis is omitted, then tagName's priority is changed to make it
    # highest priority of all tags.
    def tag_raise(tag_name, above = None)
      execute_only(:tag, :raise, tag_name, above)
    end

    # Returns a list describing all of the ranges of text that have been tagged
    # with tagName.
    # The first two elements of the list describe the first tagged range in the
    # text, the next two elements describe the second range, and so on.
    # The first element of each pair contains the index of the first character
    # of the range, and the second element of the pair contains the index of
    # the character just after the last one in the range.
    # If there are no characters tagged with tag then an empty string is
    # returned.
    def tag_ranges(tag_name)
      [*execute(:tag, :ranges, tag_name)].each_slice(2).to_a
    end

    # Remove the tag tagName from all of the characters starting at index1 and
    # ending just before index2 (the character at index2 is not affected).
    # A single command may contain any number of index1-index2 pairs.
    # If the last index2 is omitted then the tag is removed from the single
    # character at index1.
    # If there are no characters in the specified range (e.g.
    # index1 is past the end of the file or index2 is less than or equal to
    # index1) then the command has no effect.
    # This command returns an empty string.
    def tag_remove(tag_name, index1, index2 = None, *indices)
      execute_only(:tag, :remove, tag_name, index1, index2, *indices)
    end

    # Returns the value of a configuration option for an embedded window.
    # Index identifies the embedded window, and option specifies a particular
    # configuration option, which must be one of the ones listed in the section
    # EMBEDDED WINDOWS.
    def window_cget(index, option)
      execute(:window, :cget, index, option.to_tcl_option)
    end

    # Query or modify the configuration options for an embedded window.
    # If no option is specified, returns a list describing all of the available
    # options for the embedded window at index (see Tk_ConfigureInfo for
    # information on the format of this list).
    # If option is specified with no value, then the command returns a list
    # describing the one named option (this list will be identical to the
    # corresponding sublist of the value returned if no option is specified).
    # If one or more option-value pairs are specified, then the command
    # modifies the given option(s) to have the given value(s); in this case the
    # command returns an empty string.
    # See EMBEDDED WINDOWS for information on the options that are supported.
    def window_configure(index, options = None)
      common_configure([:window, :configure, index], options)
    end

    # This command creates a new window annotation, which will appear in the
    # text at the position given by index.
    # Any number of option-value pairs may be specified to configure the
    # annotation. See EMBEDDED WINDOWS for information on the options that are
    # supported. Returns an empty string.
    def window_create(index, options = None)
      if None == argument
        execute(:window, :create, index)
      else
        execute(:window, :create, index, options.to_tcl_options)
      end
    end

    # Returns a list whose elements are the names of all windows currently
    # embedded in window.
    def window_names
      execute(:window, :names).to_a
    end

    def copy
      Tk.execute(:tk_textCopy, self)
    end

    def cut
      Tk.execute(:tk_textCut, self)
    end

    def paste
      Tk.execute(:tk_textPaste, self)
    end
  end
end
