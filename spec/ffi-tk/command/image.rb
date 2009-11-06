require_relative '../../helper'

Tk.init

describe Tk::Image do
  Image = Tk::Image

  it 'creates photo image and return path' do
    Image.names.size.should == 0
    Image.create('photo').to_s.should == 'image1'
    Image.create('photo').to_s.should == 'image2'
    Image.names.should == ['image1', 'image2']

    Image.delete('image1', 'image2')
    Image.names.size.should == 0
  end

  it 'creates bitmap image and return path' do
    Image.create('bitmap').to_s.should == 'image3'
    Image.names.should == ['image3']
  end

  it 'raise RuntimeError if wrong type' do
    lambda { Image.create('unkown-') }.should.raise RuntimeError
  end
end
