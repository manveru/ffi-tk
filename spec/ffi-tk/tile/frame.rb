require_relative '../../helper'

Tk.init

describe Tk::Tile::Frame do
  Style = Tk::Tile::Style
  Frame = Tk::Tile::Frame

  it 'creates a new frame with layout_style' do
    layout_style = [
      'Button.button', {:children=>[
        'Button.focus', {:children=>[
          'Button.padding', {:children=>[
            'Button.label', {:expand=>true, :sticky=>''}
          ]}
        ]}
      ]}
    ]

    frame = Frame.new(Tk.root)
    frame.style(layout_style).should == true

    frame2 = Frame.new(Tk.root, style: layout_style)

    #? @frame.cget(:style).should.to_s == ''
  end

  it 'sets borderwidth default 0' do
    frame = Frame.new(Tk.root)
    frame.cget(:borderwidth).should == 0

    frame = Frame.new(Tk.root, borderwidth: 10)
    frame.cget(:borderwidth).should == 10

    frame.configure borderwidth: 20
    frame.cget(:borderwidth).should == 20
  end

  # One of the standard Tk border styles:
  # flat, groove, raised, ridge, solid, or sunken. Defaults to flat.
  it 'sets relief default :flat' do
    frame = Frame.new(Tk.root)
    frame.cget(:relief).should == :flat

    frame = Frame.new(Tk.root, relief: 'groove')
    frame.cget(:relief).should == :groove
  end

  it 'sets cursor' do
    frame = Frame.new(Tk.root)
    frame.cget(:cursor).should == nil

    lambda {
      Frame.new(Tk.root, cursor: '.s.s.s.s')
    }.should.raise RuntimeError
  end

  it 'sets additional padding to include inside the border' do
    frame = Frame.new(Tk.root)
    frame.cget(:padding).should == []

    frame = Frame.new(Tk.root, padding: 10)
    frame.cget(:padding).should == [ '10' ]

    frame.configure padding: [10, 20]
    frame.cget(:padding).should == ['10', '20']
  end
end

