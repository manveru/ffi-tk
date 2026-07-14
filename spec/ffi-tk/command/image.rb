# frozen_string_literal: true

require_relative '../../helper'

Tk.init

describe Tk::Image do
  Image = Tk::Image

  extra_images = %w[
    ::tk::icons::information
    ::tk::icons::error
    ::tk::icons::warning
    ::tk::icons::question
  ]

  it 'creates photo image and return path' do
    Image.names.size.should == extra_images.size
    Image.create('photo').to_s.should == 'image1'
    Image.create('photo').to_s.should == 'image2'
    Image.names.sort.should == (extra_images + %w[image1 image2]).sort

    Image.delete('image1', 'image2')
    Image.names.size.should == extra_images.size
  end

  it 'creates bitmap image and return path' do
    Image.create('bitmap').to_s.should == 'image3'
    Image.names.sort.should == (extra_images + %w[image3]).sort
  end

  it 'raise RuntimeError if wrong type' do
    -> { Image.create('unkown-') }.should.raise RuntimeError
  end

  it 'creates an auto-named image with options' do
    name = Image.create('photo', width: 20, height: 20)
    name.to_s.should =~ /\Aimage\d+\z/
    Image.width(name).should == 20
    Image.delete(name)
  end

  it 'creates a named image with options' do
    Image.create('photo', '::img::sized', width: 40, height: 30).to_s.should == '::img::sized'
    Image.names.should.include('::img::sized')
    Image.delete('::img::sized')
  end

  it 'reports the width and height of an image in pixels' do
    Image.create('photo', '::img::sized', width: 40, height: 30)
    Image.width('::img::sized').should == 40
    Image.height('::img::sized').should == 30
    Image.delete('::img::sized')
  end
end
