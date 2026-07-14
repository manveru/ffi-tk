# frozen_string_literal: true

require_relative '../../helper'

Tk.init

describe Tk::Selection do
  @entry = Tk::Entry.new('.')
  @entry.insert :end, 'abc def ghi jkl mno pqr stu vwx yz'
  @entry.selection_range(0, 3)

  it 'gets selection' do
    Tk::Selection.get.should == 'abc'
  end

  it 'transfers ownership of the selection to a widget' do
    owner = Tk::Entry.new('.')
    owner.insert(:end, 'owned text')

    Tk::Selection.own(owner)
    Tk::Selection.own.should == owner.tk_pathname
  end

  it 'reports no owner after the selection is cleared' do
    owner = Tk::Entry.new('.')
    Tk::Selection.own(owner)
    Tk::Selection.own.should == owner.tk_pathname

    Tk::Selection.clear
    Tk::Selection.own.should.be.nil
  end

  it 'round-trips a handled selection value within the process' do
    owner = Tk::Entry.new('.')
    Tk::Selection.own(owner)

    fired = false
    Tk::Selection.handle(owner, {}) do |_offset, _max|
      fired = true
      'HANDLED-BY-RUBY'
    end

    Tk::Selection.get.should == 'HANDLED-BY-RUBY'
    fired.should == true
  end

  # Widget now includes Selection, so a widget can drive the X-selection through
  # instance delegators that forward self as the window. A Label is used because
  # it does not override selection_clear with widget-selection semantics.
  describe 'Widget#selection_* delegators forward self' do
    it 'claims, handles, reads and clears the selection through the widget' do
      label = Tk::Label.new('.', text: 'holder')

      label.selection_own({})
      Tk::Selection.own.should == label.tk_pathname

      label.selection_handle({}) { |_offset, _max| 'FROM-LABEL' }
      label.selection_get.should == 'FROM-LABEL'

      label.selection_clear
      Tk::Selection.own.should.be.nil
    end
  end
end
