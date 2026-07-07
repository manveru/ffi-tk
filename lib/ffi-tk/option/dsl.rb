# frozen_string_literal: true

module Tk
  module Option
    # Class-level DSL, extended into Tk::Widget, for declaring a widget's Option
    # schema. Composition is explicit: a widget opts into a standard set and adds
    # its own widget-specific options and aliases.
    #
    # The schema belongs to the *Tk command*, not the Ruby class. A subclass
    # inherits its parent's schema only when it inherits `tk_command` unchanged
    # (e.g. Tile::YScrollbar < Tile::Scrollbar, Root < Toplevel). A class that
    # overrides `tk_command` without declaring its own schema inherits nothing —
    # this is why Tile::Entry (ttk::entry) can never reuse Tk::Entry (entry).
    module DSL
      # Opt into the classic STANDARD OPTIONS set.
      def classic_options
        option_schema_parts << Standard::CLASSIC
      end

      # Opt into the themed (ttk) STANDARD OPTIONS set.
      def ttk_options
        option_schema_parts << Standard::TTK
      end

      # Declare this widget's widget-specific option types, e.g.
      #   widget_options wrap: :symbol, state: :symbol
      def widget_options(mapping)
        option_schema_parts << Schema.new(types: mapping)
      end

      # Declare this widget's option aliases (synonyms), e.g.
      #   option_aliases vcmd: :validatecommand
      def option_aliases(mapping)
        option_schema_parts << Schema.new(aliases: mapping)
      end

      # This class's composed, frozen, memoized Option schema. When the class
      # declares nothing of its own it inherits its parent's schema iff the Tk
      # command is unchanged; otherwise there is no schema (nil).
      def option_schema
        if option_schema_parts.empty?
          inherited_option_schema
        else
          @option_schema ||= option_schema_parts.reduce(Schema::EMPTY, :merge)
        end
      end

      # The declared building blocks, in declaration order (per class).
      def option_schema_parts
        @option_schema_parts ||= []
      end

      private

      def inherited_option_schema
        parent = superclass
        return nil unless parent.respond_to?(:option_schema)
        return nil unless same_tk_command_as?(parent)

        parent.option_schema
      end

      def same_tk_command_as?(parent)
        own = tk_command_of(self)
        !own.nil? && own == tk_command_of(parent)
      end

      def tk_command_of(klass)
        klass.tk_command if klass.respond_to?(:tk_command)
      rescue NotImplementedError
        nil
      end
    end
  end

  # Wire the DSL into every widget class. Tk::Widget is defined later (in
  # widget.rb); reopening it here creates the class ahead of that require, which
  # then merely reopens it again to add its behaviour.
  class Widget
    extend Option::DSL
  end
end
