# frozen_string_literal: true

require_relative '../../helper'

describe Tk::After do
  it 'runs an idle callback on the next update' do
    ran = false
    Tk::After.idle { ran = true }
    Tk.execute('update')
    ran.should == true
  end

  it 'runs a delayed callback once the delay elapses' do
    ran = false
    Tk::After.ms(10) { ran = true }
    deadline = Time.now + 2
    Tk.interp.do_one_event(0) until ran || Time.now > deadline
    ran.should == true
  end

  it 'schedules a bare delay without a block' do
    Tk::After.ms(1).should == true
  end
end
