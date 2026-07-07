# frozen_string_literal: true

require_relative '../../helper'

describe Tk::Spinbox do
  before { reset_root! }

  it 'initializes' do
    instance = Tk::Spinbox.new
    instance.class.should == Tk::Spinbox
    instance.tk_parent.should == Tk.root
  end

  it 'coerces its numeric and keyword options by declared type' do
    sb = Tk::Spinbox.new
    sb.configure(from: 1.5, to: 9.5, increment: 0.5, width: 8, buttonuprelief: :flat)

    sb.cget(:from).should == 1.5
    sb.cget(:to).should == 9.5
    sb.cget(:increment).should == 0.5
    # -width is a character count (:integer), not a screen distance.
    sb.cget(:width).should == 8
    sb.cget(:buttonuprelief).should == :flat
    sb.cget(:state).should == :normal
  end

  it 'reports -wrap as a genuine boolean, not a keyword symbol' do
    sb = Tk::Spinbox.new(wrap: true)
    sb.cget(:wrap).should == true
    sb.configure(wrap: false)
    sb.cget(:wrap).should == false
  end

  it 'reads -values back as a list of strings' do
    sb = Tk::Spinbox.new(values: %w[red green blue])
    sb.cget(:values).should == %w[red green blue]
    # empty by default -> the empty instance of :list, never nil.
    Tk::Spinbox.new.cget(:values).should == []
  end

  it 'follows the vcmd/invcmd aliases to their canonical commands (empty -> nil)' do
    sb = Tk::Spinbox.new
    sb.cget(:validatecommand).should.be.nil
    sb.cget(:vcmd).should.be.nil
    sb.cget(:invalidcommand).should.be.nil
    sb.cget(:invcmd).should.be.nil
  end

  it 'round-trips a value through set/get and steps with the spin buttons' do
    sb = Tk::Spinbox.new(from: 1, to: 10, increment: 1)

    sb.set(5)
    sb.get.should == '5'
    sb.set.should == '5' # no-arg set is a getter

    # invoke fires no -command callback here, so the plain execute path is safe.
    sb.invoke(:buttonup)
    sb.get.should == '6'
    sb.invoke(:buttondown)
    sb.get.should == '5'

    # value clamps at the configured bounds
    sb.set(10)
    sb.invoke(:buttonup)
    sb.get.should == '10'
    sb.set(1)
    sb.invoke(:buttondown)
    sb.get.should == '1'
  end

  it 'edits text with delete/insert/get and tracks the cursor via index' do
    sb = Tk::Spinbox.new(from: 0, to: 100)

    sb.delete(0, :end)
    sb.insert(0, 'hello')
    sb.get.should == 'hello'
    sb.index(:end).should == 5

    sb.icursor(2)
    sb.index(:insert).should == 2

    sb.delete(0, 2)
    sb.get.should == 'llo'
  end

  it 'manages the character selection' do
    sb = Tk::Spinbox.new(from: 0, to: 100)
    sb.delete(0, :end)
    sb.insert(0, 'abcdefghij')

    sb.selection_present.should == false
    sb.selection_range(0, 3)
    sb.selection_present.should == true
    sb.selection_clear
    sb.selection_present.should == false

    # anchor-relative selection also registers characters
    sb.selection_from(2)
    sb.selection_to(5)
    sb.selection_present.should == true
  end

  it 'validates and reports the visible span' do
    sb = Tk::Spinbox.new(from: 1, to: 10, increment: 1)
    sb.set(5)

    sb.validate.should == true

    first, last = sb.xview
    first.should == 0.0
    last.should == 1.0
  end

  it 'reports geometry and the element under a point when mapped' do
    sb = Tk::Spinbox.new(from: 1, to: 10, increment: 1)
    sb.place(x: 0, y: 0, width: 120, height: 30)
    next unless skip_unless_mapped(sb)

    box = sb.bbox(0)
    box.size.should == 4
    box.all? { |n| n.is_a?(Integer) }.should == true
    box[2].should > 0 # character width
    box[3].should > 0 # character height

    width = sb.winfo_width
    height = sb.winfo_height
    sb.identify(5, height / 2).should == :entry
    sb.identify(width - 3, 3).should == :buttonup
    sb.identify(width + 500, height + 500).should.nil? # no element outside
  end
end
