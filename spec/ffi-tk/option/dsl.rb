# frozen_string_literal: true

require_relative '../../helper'

# Pure specs for the class-level option DSL: explicit composition of a standard
# set with widget-specific options and aliases, memoization, and the inheritance
# rule that a schema belongs to the Tk command (inherited only when tk_command
# is inherited unchanged). Uses synthetic classes; no interpreter needed.
describe Tk::Option::DSL do
  # A class that opts into the classic standard set and adds its own options.
  def classic_widget
    Class.new do
      extend Tk::Option::DSL

      def self.tk_command = 'entry'
      classic_options
      widget_options show: :string, state: :symbol
      option_aliases vcmd: :validatecommand
      widget_options validatecommand: :command
    end
  end

  it 'composes a standard set with widget-specific options and aliases' do
    schema = classic_widget.option_schema
    schema.type_for(:background).should == :color   # from CLASSIC
    schema.type_for(:show).should == :string        # widget-specific
    schema.type_for(:state).should == :symbol       # widget-specific
    schema.type_for(:vcmd).should == :command       # alias -> validatecommand
    schema.type_for(:bg).should == :color           # CLASSIC alias
  end

  it 'lets widget-specific options override a standard type on collision' do
    klass = Class.new do
      extend Tk::Option::DSL

      def self.tk_command = 'spinbox'
      classic_options
      widget_options wrap: :boolean # classic has no -wrap; declared here as boolean
    end
    klass.option_schema.type_for(:wrap).should == :boolean
  end

  it 'ttk_options opts into the themed standard set (no classic colours)' do
    klass = Class.new do
      extend Tk::Option::DSL

      def self.tk_command = 'ttk::entry'
      ttk_options
      widget_options show: :string
    end
    klass.option_schema.type_for(:style).should == :string
    klass.option_schema.type_for(:show).should == :string
    -> { klass.option_schema.type_for(:background) }.should.raise(Tk::UnknownOptionType)
  end

  it 'memoizes the composed schema' do
    klass = classic_widget
    klass.option_schema.should.equal klass.option_schema
  end

  # --- inheritance rule ----------------------------------------------------

  it 'a subclass inherits the schema when it inherits tk_command unchanged' do
    parent = classic_widget
    child = Class.new(parent) # declares nothing, inherits tk_command 'entry'
    child.option_schema.should == parent.option_schema
  end

  it 'a subclass that overrides tk_command and declares nothing inherits no schema' do
    parent = classic_widget
    child = Class.new(parent) do
      def self.tk_command = 'ttk::entry'
    end
    child.option_schema.should.be.nil
  end

  it 'a subclass that overrides tk_command and declares its own gets its own' do
    parent = classic_widget
    child = Class.new(parent) do
      def self.tk_command = 'ttk::entry'
      ttk_options
    end
    child.option_schema.type_for(:style).should == :string
    -> { child.option_schema.type_for(:background) }.should.raise(Tk::UnknownOptionType)
  end

  it 'a class with no declarations and no tk_command has no schema' do
    klass = Class.new { extend Tk::Option::DSL }
    klass.option_schema.should.be.nil
  end
end
