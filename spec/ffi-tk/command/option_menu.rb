# frozen_string_literal: true

require_relative '../../helper'

Tk.init

describe 'Tk.option_menu' do
  before { reset_root! }

  it 'gives each option menu an independent variable' do
    v1 = Tk.option_menu('.om1', 'a', 'b')
    v2 = Tk.option_menu('.om2', 'x', 'y')

    v1.set('a')
    v2.set('x')

    # Setting v2 must not clobber v1 (they must be distinct Tcl variables).
    v1.get.should == 'a'
    v2.get.should == 'x'
  end
end
