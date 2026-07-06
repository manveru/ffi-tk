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
end
