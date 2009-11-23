module Tk
  module Tile
    # combobox combines a text field with a pop-down list of values.
    # the user may select the value of the text field from among the values in the list.
    class ComboBox < Tile::Entry
      def self.tk_command; 'ttk::combobox'; end
      include TileWidget
      # include Cget, Configure

      def postcommand(&block)
        configure(:postcommand => block) if block
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
        if None == newindex
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
