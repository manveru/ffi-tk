# frozen_string_literal: true
require_relative '../../helper'

describe Tk::Scrollbar do
  it 'initializes' do
    instance = Tk::Scrollbar.new
    instance.class.should == Tk::Scrollbar
    instance.tk_parent.should == Tk.root
  end

  it 'needs more specs' do
  end
end
