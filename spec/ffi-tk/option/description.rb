# frozen_string_literal: true

require_relative '../../helper'

# Pure specs for the Option description value object: the normal describe-tuple
# form and the 2-element synonym form, and the synonym? predicate that tells
# them apart.
describe Tk::OptionDescription do
  it 'carries the full describe-tuple in normal form' do
    desc = Tk::OptionDescription.new(:background, 'background', 'Background', 'white', 'black', nil)
    desc.name.should == :background
    desc.db_name.should == 'background'
    desc.db_class.should == 'Background'
    desc.default.should == 'white'
    desc.value.should == 'black'
    desc.synonym_for.should.be.nil
    desc.synonym?.should == false
  end

  it 'carries only name and synonym_for in synonym form' do
    desc = Tk::OptionDescription.new(:bg, nil, nil, nil, nil, :background)
    desc.name.should == :bg
    desc.synonym_for.should == :background
    desc.synonym?.should == true
    desc.value.should.be.nil
    desc.default.should.be.nil
  end
end
