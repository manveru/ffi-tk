# frozen_string_literal: true

require_relative '../../helper'

describe Tk::Entry do
  entry = Tk::Entry.new

  # --- cget: set-then-get, exact (the new bar) -----------------------------
  # Every settable option is set to a concrete value and must read back as that
  # value coerced by its declared Option type. Set-then-get is deterministic and
  # platform-free, so the assertions are exact (no acceptable-set hedging).
  # State/validate lists end on the benign value (:normal/:none) so the widget
  # is left editable for the behaviour specs below.
  settable = {
    justify: %i[left right center],                 # :symbol
    relief: %i[sunken raised flat],                 # :symbol
    background: ['#ff0000', '#00ff00'],             # :color   -> String
    foreground: ['#0000ff', '#123456'],             # :color   -> String
    disabledbackground: ['#222222'],                # :color   -> String
    readonlybackground: ['#333333'],                # :color   -> String
    cursor: %w[xterm hand2],                        # :string
    borderwidth: %w[4 2],                           # :string  (screen distance)
    selectborderwidth: ['2'],                       # :string  (screen distance)
    highlightthickness: ['3'],                      # :string  (screen distance)
    insertwidth: ['3'],                             # :string  (screen distance)
    show: ['*', ''],                                # :string
    width: [10, 30],                                # :integer (character count)
    insertontime: [500, 250],                       # :integer (milliseconds)
    state: %i[disabled readonly normal],            # :symbol
    validate: %i[focus key none]                    # :symbol
  }

  describe 'reads each settable option back exactly (set-then-get)' do
    settable.each do |option, values|
      values.each do |value|
        it "#{option} = #{value.inspect}" do
          entry.configure(option => value)
          entry.cget(option).should == value
        end
      end
    end
  end

  it 'coerces :boolean options to true/false, never a string' do
    entry.configure(exportselection: true)
    entry.cget(:exportselection).should == true
    entry.configure(exportselection: false)
    entry.cget(:exportselection).should == false
  end

  it 'follows an alias to the canonical value (bg -> background)' do
    entry.configure(bg: '#0a0b0c')
    entry.cget(:background).should == '#0a0b0c'
    entry.cget(:bg).should == '#0a0b0c'
  end

  # --- cget: unset options follow the empty-value rule ---------------------
  # These run before the behaviour specs bind a validatecommand, so the command
  # options are genuinely empty here. nil means "no object bound"; it is never a
  # flattened empty string, and an empty :string option stays "".
  describe 'unset options follow the empty-value rule' do
    it 'textvariable with nothing bound is nil (:variable empty -> nil)' do
      entry.cget(:textvariable).should.be.nil
    end

    it 'validatecommand with no command is nil (:command empty -> nil)' do
      entry.cget(:validatecommand).should.be.nil
    end

    it 'invalidcommand with no command is nil' do
      entry.cget(:invalidcommand).should.be.nil
    end

    it 'xscrollcommand with no command is nil' do
      entry.cget(:xscrollcommand).should.be.nil
    end

    it 'takefocus is the empty string, not false (:string empty -> "")' do
      entry.cget(:takefocus).should == ''
    end
  end

  # --- configure: faithful Tk describe semantics ---------------------------
  it 'configure(option) returns that option\'s OptionDescription' do
    entry.configure(validate: :none)
    description = entry.configure(:validate)
    description.should.be.is_a? Tk::OptionDescription
    description.synonym?.should == false
    description.name.should == :validate
    description.db_name.should == 'validate'
    description.db_class.should == 'Validate'
    description.default.should == :none
    description.value.should == :none
  end

  it 'configure(alias) faithfully resolves to the canonical option description, as Tk does' do
    # Tk resolves a single-option query on a synonym to the canonical option's
    # full 5-field describe-tuple; the 2-field synonym form appears only in the
    # bulk listing (asserted below). So this is the -background description, not
    # a synonym marker -- faithful 1:1 (docs/adr/0001).
    description = entry.configure(:bg)
    description.should.be.is_a? Tk::OptionDescription
    description.synonym?.should == false
    description.name.should == :background
    description.db_name.should == 'background'
  end

  it 'configure (no argument) returns a description per option, synonyms included' do
    descriptions = entry.configure
    descriptions.should.be.is_a? Hash
    descriptions[:background].should.be.is_a? Tk::OptionDescription
    descriptions[:background].synonym?.should == false
    descriptions[:bg].synonym?.should == true
    descriptions[:bg].synonym_for.should == :background
    descriptions[:vcmd].synonym_for.should == :validatecommand
    descriptions[:state].value.should == :normal
  end

  it 'configures more options at once' do
    entry.configure(justify: :right, validate: :focus)
    entry.cget(:validate).should == :focus
    entry.cget(:justify).should == :right

    entry.configure(justify: :left, validate: :none)
    entry.cget(:validate).should == :none
    entry.cget(:justify).should == :left
  end

  # --- widget behaviour (unchanged by the option-typing work) --------------
  it "returns the entry's string" do
    entry.get.should == ''
  end

  it 'inserts text at index' do
    entry.insert(:end, 'Hello, World!')
    entry.get.should == 'Hello, World!'
  end

  it 'returns a list of four numbers describing the bounding box of the character given by index' do
    index_bbox = entry.bbox(0)
    index_bbox.should.be.is_a? Array
    index_bbox.size.should == 4
  end

  it 'deletes character at index' do
    entry.delete(5)
    entry.get.should == 'Hello World!'
  end

  it 'deletes character between indices' do
    entry.delete(5, 11)
    entry.get.should == 'Hello!'
  end

  it 'Puts the insertion cursor just before the character given by index' do
    entry.icursor(5)
    entry.insert(:insert, ', World')
    entry.get.should == 'Hello, World!'
  end

  it 'Returns the numerical index corresponding to index' do
    entry.index(:insert).should == 12
  end

  it 'Insert the string just before the character indicated by index' do
    entry.insert(0, 'OHAI ')
    entry.get.should == 'OHAI Hello, World!'
  end

  it 'uses the scan commands' do
    lambda do
      entry.scan_mark(0)
      entry.scan_dragto(10)
    end.should.not.raise
  end

  it 'Returns whether a selection is present' do
    entry.selection_present.should == false
  end

  it 'adjusts the selection' do
    entry.selection_adjust(0)
    entry.index('sel.first').should == 0
    entry.selection_adjust(5)
    entry.index('sel.last').should == 5
  end

  it 'Clears the selection' do
    entry.selection_present.should == true
    entry.selection_clear
    entry.selection_present.should == false
  end

  it 'Selects the characters at start ending with the one just before end' do
    entry.selection_range(1, 4)
    entry.index('sel.first').should == 1
    entry.index('sel.last').should == 4
  end

  it 'Adjusts selection with the from and to commands' do
    entry.selection_from(2)
    entry.selection_to(5)
    entry.index('sel.first').should == 2
    entry.index('sel.last').should == 5
  end

  it 'validates the entry without validation command' do
    entry.validate.should == true
  end

  it 'validates the entry with validation command' do
    entry.configure validatecommand: ->(*_args) { true }
    entry.validate.should == true

    entry.configure validatecommand: ->(*_args) { false }
    entry.validate.should == false
  end
end
