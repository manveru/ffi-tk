# frozen_string_literal: true
require_relative '../../helper'

describe Tk::Label do
  it 'initializes' do
    instance = Tk::Label.new
    instance.class.should == Tk::Label
    instance.tk_parent.should == Tk.root
  end

  it 'needs more specs' do
    label = Tk::Label.new
    label.value.should.nil?
    label.value = 'Hello, World!'
    label.value.should == 'Hello, World!'
  end
end
