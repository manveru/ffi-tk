require_relative '../../helper'

Tk.init

describe Tk::WM do
  root = Tk.root

  # FIXME: following methods have no specs yet because image commands are missing.
  #  * WM.forget
  #  * WM.iconbitmap
  #  * WM.iconmask
  #  * WM.iconname
  #  * WM.iconphoto
  #  * WM.iconposition
  #  * WM.iconwindow

  describe "WM.aspect" do
    should 'list current attributes' do
      root.wm_aspect.should == nil
    end

    should 'set aspect ratio' do
      root.wm_aspect = [1, 1, 1, 1]
      root.wm_aspect.should == [1, 1, 1, 1]
    end

    should 'remove aspect ratio' do
      root.wm_aspect = nil
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
      root.wm_attributes(fullscreen: true)

      Tk.interp.do_events_until do
        root.wm_attributes(:fullscreen)
      end

      root.wm_attributes(:fullscreen).should == true
      root.wm_attributes(fullscreen: false)

      Tk.interp.do_events_until do
        root.wm_attributes(:fullscreen) == false
      end

      root.wm_attributes(:fullscreen).should == false
    end
  end

  describe 'WM.client' do
    it 'has empty WM_CLIENT_MACHINE property' do
      root.wm_client.should == nil
    end

    it 'sets WM_CLIENT_MACHINE property' do
      root.wm_client = 'foo'
      root.wm_client.should == 'foo'
      root.wm_client = nil
      root.wm_client.should == nil
    end
  end

  describe 'WM.colormapwindows' do
    it 'queries the WM_COLORMAP_WINDOWS property' do
      root.wm_colormapwindows.should == []
    end

    it 'sets WM_COLORMAP_WINDOWS property' do
      root.wm_colormapwindows = root
      root.wm_colormapwindows.should == ['.']
    end
  end

  describe 'WM.command' do
    it 'queries the WM_COMMAND property' do
      root.wm_command.should == []
    end

    it 'sets queries the WM_COMMAND property' do
      root.wm_command = ['foo', 'bar']
      root.wm_command.should == ['foo', 'bar']
      root.wm_command = []
      root.wm_command.should == []
    end
  end

  describe 'WM.focusmodel' do
    it 'queries the current focusmdoel' do
      root.wm_focusmodel.should == :passive
    end

    it 'sets the focusmodel' do
      root.wm_focusmodel = :active
      root.wm_focusmodel.should == :active
      root.wm_focusmodel = :passive
      root.wm_focusmodel.should == :passive
    end
  end

  describe 'WM.frame' do
    it 'queries the frame info' do
      root.wm_frame.should.not.be.empty
    end
  end

  describe 'WM.geometry' do
    it 'queries geometry' do
      geometry = root.wm_geometry
      geometry.size.should == 4
      geometry.all?{|value| Integer === value }.should.be.true
    end

    it 'sets geometry' do
      geometry = root.wm_geometry
      root.wm_geometry = '640x480+0+0'

      Tk.interp.do_events_until do
        root.wm_geometry != geometry
      end

      root.wm_geometry.should.not == geometry
    end
  end

  describe 'WM.grid' do
    it 'queries grid info when no grid is set' do
      root.wm_grid.should == nil
    end

    it 'sets a grid' do
      root.wm_grid = [1,1,1,1]
      root.wm_grid.should == [1,1,1,1]
    end
  end

  describe 'WM.group' do
    it 'queries group pathname' do
      root.wm_group.should == nil
    end

    it 'sets group pathname' do
      root.wm_group = '.'
      root.wm_group.should == '.'
    end
  end

  describe 'WM.iconbitmap' do
    it 'queries iconbitmap' do
      root.wm_iconbitmap.should == nil
    end

    it 'sets iconbitmap' do
      lambda{ root.wm_iconbitmap = 'some.gif' }.
        should.raise.message.should =~ /^bitmap "some.gif" not defined/
    end
  end

  describe 'WM.iconify and WM.deiconify' do
    it 'iconifies the window' do
      root.wm_iconify.should == true
      root.wm_deiconify.should == true
    end
  end
end