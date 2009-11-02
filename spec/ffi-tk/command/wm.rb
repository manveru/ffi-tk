require_relative '../../helper'

Tk.init

describe Tk::WM do
  root = Tk.root

  describe "WM.aspect" do
    should 'list current attributes' do
      root.wm_aspect.should == nil
    end

    should 'set aspect ratio' do
      root.wm_aspect(1, 1, 1, 1)
      root.wm_aspect.should == [1, 1, 1, 1]
    end

    should 'remove aspect ratio' do
      root.wm_aspect(nil)
      root.wm_aspect.should == nil
    end
  end

  describe 'WM.attributes' do
    it 'lists current attributes' do
      attrs = root.wm_attributes
      attrs[:alpha].should == 1.0
      attrs[:topmost].should == false
      attrs[:zoomed].should == false
      attrs[:fullscreen].should == false
    end

    it 'queries one attribute' do
      root.wm_attributes(:alpha).should == 1.0
      root.wm_attributes(:topmost).should == false
      root.wm_attributes(:zoomed).should == false
      root.wm_attributes(:fullscreen).should == false
    end

    it 'sets attributes' do
      root.wm_attributes(alpha: 0.5, topmost: true, zoomed: true, fullscreen: true)
      attrs = root.wm_attributes
      attrs[:alpha].should == 1.0
      attrs[:topmost].should == false
      attrs[:zoomed].should == false
      attrs[:fullscreen].should == false
    end
  end
end

# The aspect ratio of window (width/length) will be constrained to lie between minNumer/minDenom and maxNumer/maxDenom.
# If minNumer etc. are all specified as empty strings, then any existing aspect ratio restrictions are removed.
# If minNumer etc. are specified, then the command returns an empty string.
# Otherwise, it returns a Tcl list containing four elements, which are the current values of minNumer, minDenom, maxNumer, and maxDenom (if no aspect restrictions are in effect, then an empty string is returned).