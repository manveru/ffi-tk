# frozen_string_literal: true

require_relative '../../helper'

Tk.init

describe Tk::WM do
  root = Tk.root

  # FIXME: following methods have no specs yet because image commands are missing.
  #  * WM.forget
  #  * WM.iconbitmap_default
  #  * WM.iconphoto / WM.iconphoto_default
  #  * WM.iconwindow
  #  * WM.manage

  describe 'WM.aspect' do
    should 'list current attributes' do
      root.wm_aspect.should.nil?
    end

    should 'set aspect ratio' do
      root.wm_aspect = [1, 1, 1, 1]
      root.wm_aspect.should == [1, 1, 1, 1]
    end

    should 'remove aspect ratio' do
      root.wm_aspect = nil
      root.wm_aspect.should.nil?
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

      # TODO: somehow fullscreen doesn't change back, on tk side.
      # Tk.interp.do_events_until do
      #  root.wm_attributes(:fullscreen) == false
      # end

      # root.wm_attributes(:fullscreen).should == false
    end
  end

  describe 'WM.client' do
    it 'has empty WM_CLIENT_MACHINE property' do
      root.wm_client.should.nil?
    end

    it 'sets WM_CLIENT_MACHINE property' do
      root.wm_client = 'foo'
      root.wm_client.should == 'foo'
      root.wm_client = nil
      root.wm_client.should.nil?
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
      root.wm_command.should.nil?
    end

    it 'sets queries the WM_COMMAND property' do
      root.wm_command = %w[foo bar]
      root.wm_command.should == %w[foo bar]
      root.wm_command = nil
      root.wm_command.should.nil?
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
      geometry.should.not.be.nil
      geometry.width.should.respond_to :to_int
      geometry.height.should.respond_to :to_int
      geometry.x.should.respond_to :to_int
      geometry.y.should.respond_to :to_int
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
      root.wm_grid.should.nil?
    end

    it 'sets a grid' do
      root.wm_grid = [1, 1, 1, 1]
      root.wm_grid.should == [1, 1, 1, 1]
    end
  end

  describe 'WM.group' do
    it 'queries group pathname' do
      root.wm_group.should.nil?
    end

    it 'sets group pathname' do
      root.wm_group = '.'
      root.wm_group.should == '.'
    end
  end

  describe 'WM.iconbitmap' do
    it 'queries iconbitmap' do
      root.wm_iconbitmap.should.nil?
    end

    it 'sets iconbitmap' do
      -> { root.wm_iconbitmap = 'some.gif' }
        .should.raise.message.should =~ /^bitmap "some.gif" not defined/
    end
  end

  describe 'WM.iconify and WM.deiconify' do
    it 'iconifies the window' do
      root.wm_iconify.should == true
      root.wm_deiconify.should == true
    end
  end

  describe 'WM.maxsize' do
    it 'queries the maximum size as [width, height]' do
      top = Tk::Toplevel.new
      max = top.wm_maxsize
      max.class.should == Array
      max.size.should == 2
      max.all? { |n| n.to_i > 0 }.should == true
      top.destroy
    end

    it 'sets and reads back the maximum size' do
      top = Tk::Toplevel.new
      top.wm_maxsize(800, 600)
      top.wm_maxsize.should == [800, 600]
      top.destroy
    end
  end

  describe 'WM.minsize' do
    it 'defaults to [1, 1]' do
      top = Tk::Toplevel.new
      top.wm_minsize.should == [1, 1]
      top.destroy
    end

    it 'sets and reads back the minimum size' do
      top = Tk::Toplevel.new
      top.wm_minsize(120, 80)
      top.wm_minsize.should == [120, 80]
      top.destroy
    end
  end

  describe 'WM.resizable' do
    it 'is resizable in both dimensions by default' do
      top = Tk::Toplevel.new
      top.wm_resizable.should == [1, 1]
      top.destroy
    end

    it 'sets and reads back resizability per dimension' do
      top = Tk::Toplevel.new
      Tk::WM.resizable(top, true, false)
      top.wm_resizable.should == [1, 0]
      Tk::WM.resizable(top, false, true)
      top.wm_resizable.should == [0, 1]
      top.destroy
    end
  end

  describe 'WM.overrideredirect' do
    it 'defaults to false' do
      top = Tk::Toplevel.new
      top.wm_overrideredirect.should == false
      top.destroy
    end

    it 'sets and reads back the flag' do
      top = Tk::Toplevel.new
      top.wm_overrideredirect = true
      top.wm_overrideredirect.should == true
      top.wm_overrideredirect = false
      top.wm_overrideredirect.should == false
      top.destroy
    end
  end

  describe 'WM.positionfrom' do
    it 'has no source by default' do
      top = Tk::Toplevel.new
      top.wm_positionfrom.should.nil?
      top.destroy
    end

    it 'sets and reads back the position source' do
      top = Tk::Toplevel.new
      top.wm_positionfrom = :user
      top.wm_positionfrom.should == 'user'
      top.wm_positionfrom = :program
      top.wm_positionfrom.should == 'program'
      top.destroy
    end
  end

  describe 'WM.sizefrom' do
    it 'has no source by default' do
      top = Tk::Toplevel.new
      top.wm_sizefrom.should.nil?
      top.destroy
    end

    it 'sets and reads back the size source' do
      top = Tk::Toplevel.new
      top.wm_sizefrom = :user
      top.wm_sizefrom.should == 'user'
      top.wm_sizefrom = :program
      top.wm_sizefrom.should == 'program'
      top.destroy
    end
  end

  describe 'WM.state' do
    it 'reports the root window as normal' do
      root.wm_state.should == 'normal'
    end

    it 'reflects withdraw and deiconify transitions' do
      top = Tk::Toplevel.new
      Tk.execute('update')
      top.wm_withdraw
      top.wm_state.should == 'withdrawn'
      top.wm_deiconify
      Tk.execute('update')
      top.wm_state.should == 'normal'
      top.destroy
    end
  end

  describe 'WM.title' do
    it 'sets and reads back the window title' do
      top = Tk::Toplevel.new
      top.wm_title = 'a fine title'
      top.wm_title.should == 'a fine title'
      top.destroy
    end
  end

  describe 'WM.transient' do
    it 'has no master by default' do
      top = Tk::Toplevel.new
      top.wm_transient.should.nil?
      top.destroy
    end

    it 'sets and clears the transient master' do
      master = Tk::Toplevel.new
      top = Tk::Toplevel.new
      top.wm_transient = master
      top.wm_transient.should == master.tk_pathname
      top.wm_transient = ''
      top.wm_transient.should.nil?
      top.destroy
      master.destroy
    end

    it 'refuses to make a window transient of itself' do
      top = Tk::Toplevel.new
      -> { top.wm_transient = top }.should.raise(RuntimeError)
      top.destroy
    end
  end

  describe 'WM.stackorder' do
    it 'returns the mapped toplevels including the queried window' do
      top = Tk::Toplevel.new
      next unless skip_unless_mapped(top)

      order = Tk::WM.stackorder(top)
      order.class.should == Array
      order.should.include top.tk_pathname
      top.destroy
    end

    it 'reports relative stacking with isabove/isbelow as complementary booleans' do
      low = Tk::Toplevel.new
      high = Tk::Toplevel.new
      next unless skip_unless_mapped(low)
      next unless skip_unless_mapped(high)

      above = Tk::WM.stackorder(low, :isabove, high)
      below = Tk::WM.stackorder(low, :isbelow, high)
      [above, below].should == [above, below].map { |v| v == true || v == false ? v : :not_boolean }
      above.should == !below
      low.destroy
      high.destroy
    end
  end

  describe 'WM.protocol' do
    it 'registers, queries, lists and deletes a protocol handler' do
      top = Tk::Toplevel.new
      top.wm_protocol('WM_DELETE_WINDOW') { :handled }
      top.wm_protocol.should.include 'WM_DELETE_WINDOW'
      top.wm_protocol('WM_DELETE_WINDOW').should.not.be.empty
      top.wm_protocol('WM_DELETE_WINDOW', nil)
      top.wm_protocol.should == []
      top.destroy
    end
  end

  describe 'WM.iconname' do
    it 'has no icon name by default' do
      top = Tk::Toplevel.new
      top.wm_iconname.should.nil?
      top.destroy
    end

    it 'sets and reads back the icon name' do
      top = Tk::Toplevel.new
      top.wm_iconname = 'shortname'
      top.wm_iconname.should == 'shortname'
      top.destroy
    end
  end

  describe 'WM.iconmask' do
    it 'has no icon mask by default' do
      top = Tk::Toplevel.new
      top.wm_iconmask.should.nil?
      top.destroy
    end
  end

  describe 'WM.iconposition' do
    it 'has no icon position hint by default' do
      top = Tk::Toplevel.new
      top.wm_iconposition.should.nil?
      top.destroy
    end

    it 'sets and reads back the icon position hint' do
      top = Tk::Toplevel.new
      top.wm_iconposition = [15, 25]
      top.wm_iconposition.should == [15, 25]
      top.destroy
    end
  end
end
