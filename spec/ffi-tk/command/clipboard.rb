# frozen_string_literal: true

require_relative '../../helper'

Tk.init

describe Tk::Clipboard do
  C = Tk::Clipboard

  it 'should clear the clipboard' do
    C.clear
    -> { C.get }.should.raise.message
                .should =~ /^CLIPBOARD selection doesn't exist or form "STRING" not defined/
  end

  it 'should append to the clipboard' do
    C.append data: 'something'
    C.get.should == 'something'
  end

  it 'replaces the whole clipboard via Clipboard.set' do
    C.set('replaced')
    C.get.should == 'replaced'
  end

  # Widget includes Clipboard, so the instance delegators forward self as the
  # display-of window.
  describe 'Widget#clipboard_* delegators forward self' do
    it 'clears, sets, appends and reads through the widget' do
      w = Tk::Button.new('.', text: 'x')

      w.clipboard_set('via-widget')
      w.clipboard_get.should == 'via-widget'

      w.clipboard_clear
      w.clipboard_append(data: 'more')
      w.clipboard_get.should == 'more'
    end
  end
end
