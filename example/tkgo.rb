# Copyright (c) 2009 Michael Fellinger <m.fellinger@gmail.com>
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
# IN NO EVENT SHALL THE AUTHORS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

# tkgo.rb is an extended implementation of the goco frontend for GNU Go.
# goco can be found at http://stud4.tuwien.ac.at/~e0225855/
#
# TkGo contains many bugfixes and is written in Ruby.
# It shows some basics of Tk::Canvas usage.

require 'ffi-tk'
require 'optparse'
require 'open3'

class TkGo
  attr_accessor(:linedist, :frame, :goban, :passb, :scoreb, :undob, :boardsize,
                :sin, :sout, :serr, :status)

  def initialize(options)
    index = options.index('--boardsize')
    @boardsize = index ? options[index + 1] : 9
    @linedist = 28
    @black_history = []
    @white_history = []

    cmd = "gnugo --mode gtp #{options.join(' ')}"

    Open3.popen3 cmd do |sin, sout, serr|
      @sin, @sout, @serr = sin, sout, serr
      setup_widgets
      Tk.mainloop
    end
  end

  def setup_widgets
    Tk::Tile.set_theme 'clam'

    @frame  = Tk::Tile::Frame.new
    @passb  = Tk::Tile::Button.new(frame, text: 'Pass'){ clicked_field('pass') }
    @scoreb = Tk::Tile::Button.new(frame, text: 'Score'){ score }
    @undob  = Tk::Tile::Button.new(frame, text: 'Undo'){
      2.times{
        sin.puts("undo")
        read_pipe
      }
      @white_history.pop
      @black_history.pop
      draw_pieces
    }
    @status = Tk::Tile::Label.new
    passb.pack(padx: 5, pady: 5, side: :left)
    scoreb.pack(padx: 5, pady: 5, side: :left)
    undob.pack(padx: 5, pady: 5, side: :left)
    status.pack(side: :bottom, expand: true, fill: :both)

    Tk.root.wm_title = 'GO considered'
    Tk.root.bind('<Destroy>'){
      sin.puts("exit")
      exit
    }

    gobansize = linedist * (boardsize + 1)
    @goban = Tk::Canvas.new(
      Tk.root,
      height: gobansize,
      width: gobansize,
      background: '#eebb77')
    goban.pack(expand: true)
    frame.pack(expand: true)
    draw_board(goban)
  end

  # NOTE: there is no I
  def x_to_letter(x)
    %w[A B C D E F G H J K L M N O P Q R S T][x]
  end

  def read_pipe
    reply = sout.gets.strip.split
    ignore = sout.gets
    reply
  end

  def draw_pieces
    sin.puts("list_stones black")
    blacks = read_pipe
    blacks.shift

    sin.puts("list_stones white")
    whites = read_pipe
    whites.shift

    goban.delete(:piece, :marker)

    blacks.each{|name| draw_piece(name, :black) }
    whites.each{|name| draw_piece(name, :white) }

    draw_markers(blacks.any?, whites.any?)
  end

  def draw_piece(name, color)
    cs = goban.coords(name)
    return if cs.empty?

    goban.create_oval(*cs, tags: [:piece], fill: color)
    outline = color == :white ? :black : :white
  end

  def draw_markers(blacks, whites)
    last_white = @white_history.reject{|name| name =~ /pass/i }.last
    draw_marker(last_white, :black) if whites && last_white

    last_black = @black_history.reject{|name| name =~ /pass/i }.last
    draw_marker(last_black, :white) if blacks && last_black
  end

  def draw_marker(name, color)
    p draw_marker: [name, color]
    x1, y1, x2, y2 = goban.coords(name)
    margin = linedist / 4
    cs = (x1 + margin), (y1 + margin), (x2 - margin), (y2 - margin)
    goban.create_rectangle(*cs, tags: [:marker], outline: color)
  end

  def clicked_field(name)
    @black_history << name
    sin.puts("play black #{name}")
    reply = read_pipe

    return if reply[0] == '?'

    sin.puts("genmove white")
    pos = read_pipe.last
    @white_history << pos
    status.value = "White: #{pos}"

    draw_pieces
  rescue => ex
    puts "#{ex.class}: #{ex}", *ex.backtrace
    nil
  end

  def score
    sin.puts("final_score")
    reply = read_pipe.last
    status.value = reply
  end

  def draw_board(board)
    max = boardsize * linedist

    1.upto(boardsize) do |i|
      start = linedist * i
      board.create_line(linedist, start, max, start)
      board.create_line(start, linedist, start, max)
    end

    (0...boardsize).each do |i|
      (0...boardsize).each do |j|
        x1 = ((linedist * i) + (linedist / 2)) - 2
        y1 = ((linedist * j) + (linedist / 2)) - 2
        x2 = (x1 + linedist) - 2
        y2 = (y1 + linedist) - 2

        fieldname = [x_to_letter(i), j + 1].join
        # color = '#' << Array.new(3){ rand(255).to_s(16).rjust(2, '0') }.join
        color = nil
        board.create_rectangle(
          x1, y1, x2, y2, tags: [fieldname], outline: nil, fill: color)
        board.bind(fieldname, '<1>'){ clicked_field(fieldname) }
      end
    end
  end
end

options = []

op = OptionParser.new{|o|
  o.separator "\nMain Options:"
  o.on('--level <amount>', Integer, 'strength (default 10)'){|amount|
    options << '--level' << amount }
  o.on('--never-resign', 'Forbid GNU Go to resign'){
    options << '--never-resign' }
  o.on('--resign-allowed', 'Allow resignation (default)'){
    options << '--resign-allowed' }
  o.on('-l', '--infile <file>', 'Load name sgf file'){|file|
    options << '--infile' << file }
  o.on('-L', '--until <move>',      'Stop loading just before move is played. <move>
                                     can be the move number or location (eg L10).'){|move|
    options << '--until' << move }
  o.on('-o', '--outfile <file>', 'Write sgf output to file'){|file|
    options << '--outfile' << file }
  o.on('--printsgf <file>', 'Write position as a diagram to file (use with -l)'){|file|
    options << '--printsgf' << file }

  o.separator "\nGame Options:"
  o.on('--boardsize <num>', Integer, 'Set the board size to use (1--19)'){|num|
    options << '--boardsize' << num }
  o.on('--color <color>', "Choose your color ('black' or 'white')"){|color|
    options << '--color' << color }
  o.on('--handicap <num>', Integer, 'Set the number of handicap stones (0--9)'){|num|
    options << '--handicap' << num }
  o.on('--komi <num>', Integer, 'Set the komi'){|num|
    options << '--komi' << num }
  o.on('--clock <sec>', 'Initialize the timer.'){|sec|
    options << '--clock' << sec }
  o.on('--byo-time <sec>', 'Initialize the byo-yomi timer.'){|sec|
    options << '--byo-time' << sec }
  o.on('--byo-period <stones>', 'Initialize the byo-yomi period.'){|stones|
    options << '--byo-period' << stones }

  o.on('--japanese-rules', '(default)'){
    options << '---japanese-rules' }
  o.on('--chinese-rules'){
    options << '--chinese-rules' }
  o.on('--forbid-suicide', 'Forbid suicide. (default)'){
    options << '--forbid-suicide' }
  o.on('--allow-suicide', 'Allow suicide except single-stone suicide.'){
    options << '--allow-suicide' }
  o.on('--allow-all-suicide', 'Allow all suicide moves.'){
    options << '--allow-all-suicide' }
  o.on('--simple-ko', 'Forbid simple ko recapture. (default)'){
    options << '--simple-ko' }
  o.on('--no-ko', 'Allow any ko recapture.'){
    options << '--no-ko' }
  o.on('--positional-superko', 'Positional superko restrictions.'){
    options << '--positional-superko' }
  o.on('--situational-superko', 'Situational superko restrictions.'){
    options << '--situational-superko' }

  o.on('--play-out-aftermath'){
    options << '--play-out-aftermath' }
  o.on('--capture-all-dead'){
    options << '--capture-all-dead' }

  o.on('--min-level <amount>', 'minimum level for adjustment schemes'){|amount|
    options << '--min-level' << amount }
  o.on('--max-level <amount>', 'maximum level for adjustment schemes'){|amount|
    options << '--max-level' << amount }
  o.on('--autolevel', 'adapt gnugo level during game to respect
                       the time specified by --clock <sec>.'){
   options << '--autolevel' }


  o.on('-h', '--help'){
    puts o
    exit
  }
}

op.parse!

TkGo.new(options)
