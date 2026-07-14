# frozen_string_literal: true

module Tk
  module Tile
    # The ttk::treeview widget displays a hierarchical collection of items.
    # Each item has a textual label, an optional image, and an optional list of
    # data values.
    # The data values are displayed in successive columns after the tree label.
    # The order in which data values are displayed may be controlled by setting
    # the -displaycolumns widget option.
    # The tree widget can also display column headings.
    # Columns may be accessed by number or by symbolic names listed in the
    # -columns widget option; see COLUMN IDENTIFIERS.
    # Each item is identified by a unique name.
    # The widget will generate item IDs if they are not supplied by the caller.
    # There is a distinguished root item, named {}.
    # The root item itself is not displayed; its children appear at the top
    # level of the hierarchy.
    # Each item also has a list of tags, which can be used to associate event
    # bindings with individual items and control the appearance of the item.
    # Treeview widgets support horizontal and vertical scrolling with the
    # standard -[xy]scrollcommand options and [xy]view widget commands.
    class Treeview < Tk::Widget
      include Configure
      include Cget
      include Scrollable
      include Tk::Tile::TileWidget

      def self.tk_command
        'ttk::treeview'
      end

      # Option schema (ttk::treeview WIDGET-SPECIFIC + ttk::widget STANDARD).
      # -columns/-displaycolumns/-show are lists of identifiers (:list);
      # -selectmode is extended/browse/none (:symbol); -height is a row count
      # (:integer); -padding is a screen-distance list (:list). Column, item,
      # heading and tag options are queried through their own subcommands, not
      # widget cget/configure, so they are not part of this schema.
      ttk_options
      widget_options(
        columns: :list,
        displaycolumns: :list,
        height: :integer,
        padding: :list,
        selectmode: :symbol,
        show: :list
      )

      # Per-surface Option schemas for the column/heading/item/tag subcommands
      # (ttk_treeview(3tk)). These are queried through their own subcommands, not
      # widget cget/configure, so they are separate from the widget schema above.
      # Treeview column -width/-minwidth report pixel counts (:integer), unlike
      # the classic screen-distance options. The heading subcommand also reports
      # a dash-less `state {}` (a ttk state spec, hence :list) that the man page
      # omits. Empty :color/:command/:symbol/:font values coerce to nil.
      COLUMN_SCHEMA = Option::Schema.new(
        types: {
          id: :string, anchor: :symbol, minwidth: :integer,
          stretch: :boolean, width: :integer
        }
      )
      HEADING_SCHEMA = Option::Schema.new(
        types: {
          text: :string, image: :string, anchor: :symbol,
          command: :command, state: :list
        }
      )
      ITEM_SCHEMA = Option::Schema.new(
        types: {
          text: :string, image: :string, values: :list,
          open: :boolean, tags: :list
        }
      )
      TAG_SCHEMA = Option::Schema.new(
        types: {
          text: :string, image: :string, anchor: :symbol,
          background: :color, foreground: :color, font: :font
        }
      )

      # Delete all items
      def clear
        delete(*children(nil))
      end

      # Returns the bounding box (relative to the treeview widget's window) of
      # the specified item in the form x y width height.
      # If column is specified, returns the bounding box of that cell.
      # If the item is not visible (i.e., if it is a descendant of a closed item
      # or is scrolled offscreen), returns the empty list.
      def bbox(item, column = None)
        execute(:bbox, item, column)
      end

      # If newchildren is not specified, returns the list of children belonging
      # to item.
      # If newchildren is specified, replaces item's child list with newchildren.
      # Items in the old child list not present in the new child list are
      # detached from the tree.
      # None of the items in newchildren may be an ancestor of item.
      def children(item, *new_children)
        if new_children.empty?
          execute(:children, item).to_a.map { |child| Item.new(self, child) }
        else
          # `treeview children item ?newchildren?` takes the new children as a
          # single Tcl list, not as separate trailing arguments -- splatting
          # them raises "wrong # args".
          execute(:children, item, new_children.flatten)
        end
      end

      # Query or modify the options for the specified column.
      #
      # If no +options+ is specified, returns an Hash of option/value pairs.
      #
      # If +options+ is a Symbol/String, returns the value of that option.
      #
      # Otherwise, the options are updated with the specified values.
      #
      # The following options may be set on each column:
      #   id: name
      #     The column name. This is a read-only option. For example
      #     `list.column('#n')` returns the data column associated with display
      #     column `#n`.
      #
      #   anchor: name
      #     Specifies how the text in this column should be aligned with respect
      #     to the cell.
      #     One of n, ne, e, se, s, sw, w, nw, or center.
      #
      #   minwidth: width
      #     The minimum width of the column in pixels.
      #     The treeview widget will not make the column any smaller than
      #     minwidth when the widget is resized or the user drags a column
      #     separator.
      #
      #   stretch: boolean
      #     Specifies whether or not the column's width should be adjusted when
      #     the widget is resized.
      #
      #   width: w
      #     The width of the column in pixels.
      #     Default is something reasonable, probably 200 or so.
      #
      # Use +column+ '#0' to configure the tree column.
      def column(column, options = None)
        Configure.flat(self, [:column, column], COLUMN_SCHEMA, options)
      end

      # Deletes each of the items in +items+ and all of their descendants.
      # The root item may not be deleted.
      #
      # @see detach
      def delete(*items)
        items = items.flatten
        execute_only(:delete, items) if items.any?
      end

      # Unlinks all of the specified items in +items+ from the tree.
      # The items and all of their descendants are still present and may be
      # reinserted at another point in the tree but will not be displayed.
      # The root item may not be detached.
      #
      # @see delete
      def detach(*items)
        execute(:detach, *items.flatten)
      end

      # Returns true if the specified item is present in the tree, false
      # otherwise.
      def exists(item)
        execute(:exists, item).to_boolean
      end
      alias exist? exists

      # If item is specified, sets the focus item to item.
      # Otherwise, returns the current focus item, or {} if there is none.
      def focus_item(item = None)
        result = execute(:focus, item)
        Item.new(self, result) if result
      end

      # Query or modify the heading options for the specified column.
      # Valid options are: -text text The text to display in the column heading.
      # -image imageName Specifies an image to display to the right of the column
      # heading. -anchor anchor Specifies how the heading text should be aligned.
      # One of the standard Tk anchor values.
      # -command script A script to evaluate when the heading label is pressed.
      # Use pathname heading #0 to configure the tree column heading.
      def heading(column, options = None)
        Configure.flat(self, [:heading, column], HEADING_SCHEMA, options)
      end

      # Returns a description of the specified component under the point given by
      # x and y, or the empty string if no such component is present at that
      # position. The following subcommands are supported:
      def identify_component(x, y)
        execute(:identify, :component, x, y)
      end

      # Returns the item ID of the item at position y.
      def identify_row(x, y)
        execute(:identify, :row, x, y)
      end

      # Returns the data column identifier of the cell at position x.
      # The tree column has ID #0.
      def identify_column(x, y)
        execute(:identify, :column, x, y)
      end

      # Returns the integer index of item within its parent's list of children.
      def index(item)
        execute(:index, item)
      end

      # Creates a new item.
      # parent is the item ID of the parent item, or the empty string {} to
      # create a new top-level item.
      # index is an integer, or the value end, specifying where in the list of
      # parent's children to insert the new item.
      # If index is less than or equal to zero, the new node is inserted at the
      # beginning; if index is greater than or equal to the current number of
      # children, it is inserted at the end.
      # If -id is specified, it is used as the item identifier; id must not
      # already exist in the tree.
      # Otherwise, a new unique identifier is generated.
      #
      # Returns the item identifier of the newly created item.
      def insert(parent, index, options = {})
        id = execute(:insert, parent, index, options.to_tcl_options)
        Item.new(self, id)
      end

      Item = Struct.new(:tk_parent, :id)
      # A single row in a Treeview, with its column values and attributes.
      class Item
        def initialize(tk_parent, id)
          self.tk_parent = tk_parent
          self.id = id.to_s
        end

        def insert(index, options = {})
          tk_parent.insert(id, index, options)
        end

        def index
          tk_parent.index(id)
        end

        def options(options = None)
          tk_parent.item(id, options)
        end

        def bbox(column = None)
          tk_parent.bbox(id, column).to_a
        end

        def move(parent, index)
          tk_parent.move(id, parent, index)
        end

        def delete
          tk_parent.delete(id)
        end

        def detach
          tk_parent.detach(id)
        end

        def exists
          tk_parent.exists(id)
        end
        alias exist? exists

        def children(*new_children)
          tk_parent.children(id, *new_children)
        end

        def selection_set
          tk_parent.selection_set(id)
        end

        def selection_add
          tk_parent.selection_add(id)
        end
        alias select selection_add

        def selection_remove
          tk_parent.selection_remove(id)
        end
        alias deselect selection_remove

        def selection_toggle
          tk_parent.selection_toggle(id)
        end
        alias toggle selection_toggle

        def set(column = None, value = None)
          tk_parent.set(id, column, value)
        end

        def prev
          tk_parent.prev(id)
        end

        def next
          tk_parent.next(id)
        end

        def parent
          tk_parent.parent(id)
        end

        def focus
          tk_parent.focus_item(id)
        end

        def see
          tk_parent.see(id)
        end

        def to_tcl
          id
        end

        def inspect
          format('#<Tk::Treeview::Item @tk_parent=%p @id=%p>', tk_parent.tk_pathname, id)
        end

        private :id=
      end

      # Test the widget state, execute passed block if state matches statespec.
      def instate(statespec)
        result = execute(:instate, statespec).to_boolean
        yield if result && block_given?
        result
      end

      # Query or modify the options for the specified item.
      # If no -option is specified, returns a dictionary of option/value pairs.
      # If a single -option is specified, returns the value of that option.
      # Otherwise, the item's options are updated with the specified values.
      # See ITEM OPTIONS for the list of available options.
      def item(item, options = None)
        Configure.flat(self, [:item, item], ITEM_SCHEMA, options)
      end

      # Moves item to position index in parent's list of children.
      # It is illegal to move an item under one of its descendants.
      # If index is less than or equal to zero, item is moved to the beginning;
      # if greater than or equal to the number of children, it is moved to the
      # end.
      def move(item, parent, index)
        execute(:move, item, parent, index)
      end

      # Returns the item's next sibling, or nil if item is the last child of its
      # parent.
      def next(item)
        id = execute(:next, item)
        Item.new(self, id) if id
      end

      # Returns the parent of item, or nil if item is at the top level of the
      # hierarchy.
      def parent(item)
        id = execute(:parent, item)
        Item.new(self, id) if id
      end

      # Returns the item's previous sibling, or nil if item is the first child
      # of its parent.
      def prev(item)
        id = execute(:prev, item)
        Item.new(self, id) if id
      end

      # Ensure that item is visible: sets all of item's ancestors to -open true,
      # and scrolls the widget if necessary so that item is within the visible
      # portion of the tree.
      def see(item)
        execute(:see, item)
      end

      # Returns the list of selected items.
      def selection
        execute(:selection).to_a.map { |id| Item.new(self, id) }
      end

      # +items+ becomes the new selection.
      def selection_set(*items)
        execute(:selection, :set, items.flatten)
      end

      # Add +items+ to the selection
      def selection_add(*items)
        execute(:selection, :add, items.flatten)
      end

      # Remove +items+ from the selection
      def selection_remove(*items)
        execute(:selection, :remove, items.flatten)
      end

      # Toggle the selection state of each item in +items+.
      def selection_toggle(*items)
        execute(:selection, :toggle, items.flatten)
      end

      # With one argument, returns a dictionary of column/value pairs for the
      # specified item.
      # With two arguments, returns the current value of the specified column.
      # With three arguments, sets the value of column column in item item to
      # the specified value.
      # See also COLUMN IDENTIFIERS.
      def set(item, column = None, value = None)
        if column == None
          execute(:set, item)
        elsif value == None
          execute(:set, item, column).to_s
        else
          execute_only(:set, item, column, value)
        end
      end

      # Modify or query the widget state; see ttk::widget(n).
      def state(state_spec = None)
        execute(:state, state_spec)
      end

      # Add a Tk binding script for the event sequence sequence to the tag
      # tagName. When an X event is delivered to an item, binding scripts for
      # each of the item's -tags are evaluated in order as per bindtags(n).
      # <KeyPress>, <KeyRelease>, and virtual events are sent to the focus item.
      # <ButtonPress>, <ButtonRelease>, and <Motion> events are sent to the
      # item under the mouse pointer.
      # No other event types are supported.
      # The binding script undergoes %-substitutions before evaluation; see
      # bind(n) for details.
      def tag_bind(tag_name, sequence = None, &script)
        unless script
          return execute(:tag, :bind, tag_name) if sequence == None

          return execute(:tag, :bind, tag_name, sequence)
        end

        name = "#{tk_pathname}_#{tag_name}".scan(/\w+/).join('_')
        @events ||= {}

        Event::Handler.register_custom(script) do |id|
          code = "%s tag bind %s %s { ::RubyFFI::event %d '' %s }"
          props = Event::Data::PROPERTIES.transpose[0].join(' ')
          tcl = format(code, tk_pathname, tag_name, sequence, id, props)
          Tk.interp.eval(tcl)
          @events[name] = id
        end
      end

      # Query or modify the options for the specified tagName.
      # If one or more option/value pairs are specified, sets the value of those
      # options for the specified tag.
      # If a single option is specified, returns the value of that option (or the
      # empty string if the option has not been specified for tagName).
      # With no additional arguments, returns a dictionary of the option
      # settings for tagName.
      # See TAG OPTIONS for the list of available options.
      def tag_configure(tag_name, options = None)
        Configure.flat(self, [:tag, :configure, tag_name], TAG_SCHEMA, options)
      end

      # Horizontal (xview/xview_moveto/xview_scroll) and vertical
      # (yview/yview_moveto/yview_scroll) scrolling are provided by the
      # Scrollable mixin, which queries the visible fractions with no argument
      # and adjusts the view when given one.
    end
  end
end
