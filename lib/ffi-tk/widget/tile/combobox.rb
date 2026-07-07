# frozen_string_literal: true

module Tk
  module Tile
    # combobox combines a text field with a pop-down list of values.
    # the user may select the value of the text field from among the values in the list.
    class ComboBox < Widget
      def self.tk_command
        'ttk::combobox'
      end

      include TileWidget
      include Configure
      include Cget

      # Option schema (ttk::combobox WIDGET-SPECIFIC + shared entry options +
      # ttk::widget STANDARD). -values is the drop-down list (:list); -height is
      # the listbox row count (:integer); -state is normal/readonly/disabled
      # (:symbol). The entry-family options mirror ttk::entry.
      ttk_options
      widget_options(
        background: :color,
        exportselection: :boolean,
        font: :font,
        foreground: :color,
        height: :integer,
        invalidcommand: :command,
        justify: :symbol,
        postcommand: :command,
        show: :string,
        state: :symbol,
        textvariable: :variable,
        validate: :symbol,
        validatecommand: :command,
        values: :list,
        width: :integer
      )

      def initialize(parent = Tk.root, options = {})
        super
      end

      def postcommand(&block)
        configure(postcommand: block) if block
      end

      # Sets the value of the combobox to value.
      def set(value)
        execute_only(:set, value)
      end

      # Returns the current value of the combobox.
      def get
        execute(:get).to_s
      end

      # If newIndex is supplied, sets the combobox value to the element
      # at position newIndex in the list of -values. Otherwise, returns
      # the index of the current value in the list of -values or -1 if
      # the current value does not appear in the list.
      def current(newindex = None)
        if newindex == None
          execute(:current)
        else
          execute_only(:current, newindex)
        end
      end

      # VIRTUAL EVENTS
      # The combobox widget generates a <<ComboboxSelected>> virtual event
      # when the user selects an element from the list of values. If the
      # selection action unposts the listbox, this event is delivered after
      # the listbox is unposted.
    end
  end
end
