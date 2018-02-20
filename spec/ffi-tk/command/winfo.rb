# frozen_string_literal: true
require_relative '../../helper'

Tk.init

describe Tk::Winfo do
  root = Tk.root
  entry = Tk::Entry.new(root)

  it 'gives info about an atom' do
    root.winfo_atom('STRING').should == 31
  end

  it 'gives name of an atom' do
    root.winfo_atomname(31).should == 'STRING'
  end

  it 'gives info about cells' do
    root.winfo_cells.should >= 2
    root.winfo_cells.should.be.even?
  end

  it 'gives info about children' do
    root.winfo_children.should.include?(entry.tk_pathname)
    entry.winfo_children.should.be.empty
  end

  it 'gives class name of window' do
    root.winfo_class.should == 'Tk'
    entry.winfo_class.should == 'Entry'
  end

  it 'tell us whether colormap is full' do
    root.winfo_colormapfull.should == false
  end

  should 'not contain any coordinates yet' do
    root.winfo_containing(0, 0).should.nil?
  end

  it 'tells us the depth of the window' do
    root.winfo_depth.should >= 8
    root.winfo_depth.should.even?
  end

  it 'tells us whether the window exists' do
    root.winfo_exists.should == true
  end

  it 'gives us the amount of pixels for a given distance' do
    @fpixels = root.winfo_fpixels('1c')
    @fpixels.class.should == Float
    @fpixels.should > 0
  end

  it 'knows distance in pixels' do
    root.winfo_pixels('1c').should == @fpixels.round
  end

  it 'gives us the window geometry' do
    @geometry = root.winfo_geometry
    @geometry.width.should == 1
    @geometry.height.should == 1
    @geometry.x.should == 0
    @geometry.y.should == 0
  end

  it 'gives us the window height' do
    root.winfo_height.should == @geometry.height
  end

  it 'gives us the window id' do
    root.winfo_id.should.not.be.empty?
  end

  it 'lists interps' do
    root.winfo_interps.should.include?('tk')
  end

  it "knows whether it's mapped" do
    root.winfo_ismapped.should == false
  end

  it 'knows the manager' do
    root.winfo_manager.should == 'wm'
  end

  it 'knows its name' do
    root.winfo_name.should =~ /^tk/
  end

  it 'knows its parent' do
    root.winfo_parent.should.nil?
    entry.winfo_parent.should == root.tk_pathname
  end

  it 'knows pathname of given id' do
    root.winfo_pathname(entry.winfo_id).should == entry.tk_pathname
  end

  it 'knows location of pointer x coordinate' do
    root.winfo_pointerx.class.should == Integer
  end

  it 'knows location of pointer y coordinate' do
    root.winfo_pointery.class.should == Integer
  end

  # NOTE: hold still while the specs are running ;)
  it 'lists location of pointer x/y coordinates' do
    root.winfo_pointerxy.should == [root.winfo_pointerx, root.winfo_pointery]
  end

  it 'shows requested height of window' do
    root.winfo_reqheight.should == 200
  end

  it 'shows requested width of window' do
    root.winfo_reqwidth.should == 200
  end

  it 'gives r,g,b values of a color' do
    root.winfo_rgb('red').should   == [65_535, 0, 0]
    root.winfo_rgb('green').should == [0, 32_911, 0]
    root.winfo_rgb('blue').should  == [0, 0, 65_535]
  end

  it 'knows x coordinate of root window' do
    entry.winfo_rootx.should == 0
  end

  it 'knows y coordinate of root window' do
    entry.winfo_rooty.should == 0
  end

  it 'knows which screen it is on' do
    root.winfo_screen.should.match(/\:(.+)\.\d/) # :0.0
  end

  it 'knows the number of cells in the default color map' do
    root.winfo_screencells.should >= 2
    root.winfo_screencells.should.be.even?
  end

  it 'knows the depth of the screen' do
    root.winfo_screendepth.should >= 2
    root.winfo_screendepth.should.be.even?
  end

  it 'knows the height of the screen' do
    root.winfo_screenheight.should >= 200
    root.winfo_screenheight.should.be.even?
  end

  it 'knows the width of the screen' do
    root.winfo_screenwidth.should >= 320
    root.winfo_screenwidth.should.be.even?
  end

  it 'knows the height of the screen in millimeter' do
    root.winfo_screenmmheight.should >= 2
  end

  it 'knows the width of the screen in millimeter' do
    root.winfo_screenmmwidth.should >= 2
  end

  it 'shows the default visual class for the screen' do
    root.winfo_screenvisual.should == :truecolor
  end

  it 'knows its server' do
    root.winfo_server.should.not.be.empty?
  end

  it 'knows its toplevel window' do
    root.winfo_toplevel.should == '.'
    entry.winfo_toplevel.should == '.'
  end

  it "knows whether it's viwable" do
    root.winfo_viewable.should == false
  end

  it 'knows the visual class of the window' do
    root.winfo_visual.should == :truecolor
  end

  it 'knows the visualid of the window' do
    root.winfo_visualid.should.not.be.empty
  end

  it 'knows some stuff about visualavailable' do
    root.winfo_visualsavailable.should.not.be.empty
    root.winfo_visualsavailable(:directcolor).should.not.be.empty
  end

  it 'knows the height of the virtual root window' do
    root.winfo_vrootheight.should >= 200
  end

  it 'knows the width of the virtual root window' do
    root.winfo_vrootwidth.should >= 320
  end

  it 'knows the x coordinate of the virtual root window' do
    root.winfo_vrootx.should == 0
  end

  it 'knows the y coordinate of the virtual root window' do
    root.winfo_vrooty.should == 0
  end

  it 'knows the height of the window' do
    root.winfo_width.should == 1
  end

  it 'knows the x coordinate of the window' do
    root.winfo_x.should == 0
  end

  it 'knows the y coordinate of the window' do
    root.winfo_y.should == 0
  end

  # TODO: check real screen values? (xrandr only)
  # For now it checks for a minimum of 320 x 200
  #
  # matcher = /Screen (.+?)\: (.+), current (.+) x (.+), /
  # %x{xrandr -q}.scan(matcher).collect{|i|
  #   {name: i[0], width: i[2].to_i, height: i[3].to_i}
  # }.first
end
