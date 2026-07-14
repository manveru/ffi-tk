# frozen_string_literal: true

require_relative '../../helper'

Tk.init

describe Tk::TkCmd do
  root = Tk.root

  describe 'TkCmd.caret' do
    it 'sets and reads the caret as a coerced flat hash of integers' do
      root.tk_caret(x: 3, y: 4, height: 12)

      caret = root.tk_caret
      caret.should == { height: 12, x: 3, y: 4 }
      caret.values.all? { |v| v.is_a?(Integer) }.should == true
    end

    it 'reflects updated caret coordinates' do
      root.tk_caret(x: 7, y: 9, height: 15)

      root.tk_caret.should == { height: 15, x: 7, y: 9 }
    end
  end

  describe 'TkCmd.useinputmethods' do
    it 'queries the current state without forcing it on' do
      Tk::TkCmd.useinputmethods(false)
      Tk::TkCmd.useinputmethods.should == false
      Tk::TkCmd.useinputmethods(true)
      Tk::TkCmd.useinputmethods.should == true
    end
  end
end
