require "colorize"
# Create a chessboard and function to assign item to the board
class Board
  attr_accessor :board, :selected

  def board
    @@board
  end

  def initialize
    @@board = [
      [" "," "," "," "," "," "," "," "],
      [" "," "," "," "," "," "," "," "],
      [" "," "," "," "," "," "," "," "],
      [" "," "," "," "," "," "," "," "],
      [" "," "," "," "," "," "," "," "],
      [" "," "," "," "," "," "," "," "],
      [" "," "," "," "," "," "," "," "],
      [" "," "," "," "," "," "," "," "]
    ]
  end

  # Put black & white pawns (16 pieces) on the board
  def put_pawns
    x = 0
    y1 = 1
    y2 = 6
    white_pawns = {}
    black_pawns = {}
    i = 1
    8.times do
      white_pawns["w_p_#{i}"] = Pawn.new(x,y1)
      black_pawns["b_p_#{i}"] = Pawn.new(x,y2,'b')
      @@board[y1][x] = white_pawns["w_p_#{i}"]
      @@board[y2][x] = black_pawns["b_p_#{i}"]
      i += 1
      x += 1
    end
  end

  def setup
    
  end

  # input > ex. 'a5'
  def select(position)
    #'a5' > ['a','5']
    split_input = position.chars
    x = split_input[0]
    y = (split_input[1].to_i) - 1
    input_codes = {'a'=>0,'b'=>1,'c'=>2,'d'=>3,'e'=>4,'f'=>5,'g'=>6,'h'=>7}
    if input_codes.include? x
      @selected = @@board[y][input_codes[x]]
      if @selected == ' '
        return "Invalid Selection"
      else
        return "Selected " + position
      end
    else
      return "Invalid Selection"
    end
  end

  def print_board
    @@board.reverse.each_with_index do |row, i|
      row.each_with_index do |piece, index|
        if (i.even? && index.even?) || (i.odd? && index.odd?)
          colorme(piece, :black, :cyan) if piece == " "
          colorme(piece.display, :black, :cyan) if piece != " "
        else
          colorme(piece, :black, :white) if piece == " "
          colorme(piece.display, :black, :white) if piece != " "
        end
      end
      puts
    end
    return
  end

  def colorme(object, main_color, bg_color)
    print
    print (" " + object + " ").colorize(:color => main_color, :background => bg_color )
  end
end

require_relative "chess_piece"

myboard = Board.new
myboard.put_pawns

=begin
    @@board = [
      ["\u2656","\u2658","\u2657","\u2655","\u265A","\u2657","\u2658","\u2656"],
      ["\u2659","\u2659","\u2659","\u2659","\u2659","\u2659","\u2659","\u2659"],
      [" "," "," "," "," "," "," "," "],
      [" "," "," "," "," "," "," "," "],
      [" "," "," "," "," "," "," "," "],
      [" "," "," "," "," "," "," "," "],
      ["\u2659","\u2659","\u2659","\u2659","\u2659","\u2659","\u2659","\u2659"],
      ["\u2656","\u2658","\u2657","\u2655","\u265A","\u2657","\u2658","\u2656"]
    ]
=end