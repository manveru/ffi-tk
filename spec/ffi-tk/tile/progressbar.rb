require_relative '../../helper'

describe Tk::Tile::Progressbar do
  it 'initializes' do
    instance = Tk::Tile::Progressbar.new
    instance.class.should == Tk::Tile::Progressbar
    instance.parent.should == Tk.root
  end

  it 'start progress step with interval' do
    pbar = Tk::Tile::Progressbar.new
    pbar.start.should == true
    pbar.start(12).should == true
  end

  it 'stop progress stepping' do
    pbar = Tk::Tile::Progressbar.new
    pbar.stop.should == true
  end

  it '#step increments value' do
    var = Tk::Variable.new('somevar')
    var.set 0.0
    pbar = Tk::Tile::Progressbar.new(Tk.root, variable: var)

    3.times { pbar.step.should == true }
    var.to_f.should == 3.0

    pbar.step(10).should == true
    var.to_f.should == 13.0
  end

  it 'get progress value' do
    pbar = Tk::Tile::Progressbar.new(Tk.root)
    pbar.step
    pbar.value.should == 1.0
    pbar.step(98)
    pbar.value.should == 99.0
    pbar.step(1)
    pbar.value.should == 0.0
  end

  it 'sets mode' do
    pbar = Tk::Tile::Progressbar.new(Tk.root)
    pbar.cget(:mode).should == :determinate

    pbar = Tk::Tile::Progressbar.new(Tk.root, mode: :indeterminate)
    pbar.cget(:mode).should == :indeterminate
  end

  it 'sets length' do
    pbar = Tk::Tile::Progressbar.new(Tk.root)
    pbar.cget(:length).should == 100

    pbar = Tk::Tile::Progressbar.new(Tk.root, length: 200)
    pbar.cget(:length).should == 200
  end

  it 'sets maximum' do
    pbar = Tk::Tile::Progressbar.new(Tk.root)
    pbar.cget(:maximum).should == 100

    pbar = Tk::Tile::Progressbar.new(Tk.root, maximum: 90)
    pbar.cget(:maximum).should == 90
  end

  it 'gets phase value' do
    Tk::Tile::Progressbar.new(Tk.root).phase.should == 0
  end

  it 'sets orientation' do
    pbar = Tk::Tile::Progressbar.new
    pbar.orient.should == :horizontal
    pbar.orient :vertical
    pbar.orient.should == :vertical
  end
end

