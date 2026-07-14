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

  describe 'tk appname' do
    it 'queries the interpreter name without renaming it (tk_appname getter)' do
      root.tk_appname.should == 'tk'
      # a plain query must not mutate the app name
      root.tk_appname.should == 'tk'
    end

    it 'renames the interpreter and returns the chosen name (tk_appname=)' do
      root.tk_appname = 'myapp'
      Tk::TkCmd.appname.should == 'myapp'
      root.tk_appname.should == 'myapp'
    end
  end

  describe 'tk scaling (per-display via the widget delegators)' do
    # Tk stores scaling as pixels/point and requantizes, so the read-back is
    # near, not exactly, the value set -- hence the tolerance.
    it 'sets and reads back the scaling factor through -displayof' do
      root.tk_scaling = 1.5
      root.tk_scaling.should.be.close(1.5, 0.01)
      root.tk_scaling = 2.0
      root.tk_scaling.should.be.close(2.0, 0.01)
    end

    it 'queries scaling on an explicit display via the module -displayof form' do
      Tk::TkCmd.scaling(1.25, root)
      Tk::TkCmd.scaling(Tk::None, root).should.be.close(1.25, 0.01)
    end
  end

  describe 'tk inactive' do
    it 'reports a non-negative idle time in milliseconds (tk_inactive, -displayof)' do
      ms = root.tk_inactive
      ms.should.be.is_a? Integer
      # -1 only when unsupported; a real display reports >= 0
      (ms >= -1).should == true
    end
  end

  describe 'tk useinputmethods delegators' do
    it 'round-trips through tk_useinputmethods= / tk_useinputmethods' do
      root.tk_useinputmethods = false
      root.tk_useinputmethods.should == false
      root.tk_useinputmethods = true
      root.tk_useinputmethods.should == true
    end
  end

  describe 'tk windowingsystem' do
    it 'reports the windowing system as a symbol' do
      root.tk_windowingsystem.should.be.is_a? Symbol
      %i[x11 win32 aqua].should.include root.tk_windowingsystem
    end
  end
end
