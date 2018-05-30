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
    row = 1
    color = 'w'
    2.times do
      @@board[row].each_index do |i|
        @@board[row][i] = Pawn.new(i, row, color)
      end
      row = 6
      color = 'b'
    end
  end

  def setup
    put_pawns
    row = 0
    color = 'w'
    2.times do
      @@board[row].each_index do |i|
        if i == 0 || i == 7
          @@board[row][i] = Rook.new(i, row, color)
        elsif i == 1 || i == 6
          @@board[row][i] = Knight.new(i, row, color)
        elsif i == 2 || i == 5
          @@board[row][i] = Bishop.new(i, row, color)
        elsif i == 3
          @@board[row][i] = Queen.new(i, row, color)
        else
          @@board[row][i] = King.new(i, row, color)
        end
      end
      row = 7
      color = 'b'
    end
  end

  # input > ex. 'a5'
  def select(position)
    x = position[0]
    y = (position[1].to_i) - 1
    input_codes = {'a'=>0,'b'=>1,'c'=>2,'d'=>3,'e'=>4,'f'=>5,'g'=>6,'h'=>7}
    if input_codes.include? x
      @selected = @@board[y][input_codes[x]]
      if @selected == ' '
        @selected = nil
        return "Invalid Selection"
      else
        print "Legal Moves: #{@selected.legal_moves}\n"
        print "Capture Moves: #{@selected.capture_moves}\n"
        #print "En Passant Moves: #{@selected.en_passant?}\n"
        return "Selected " + position
      end
    else
      return "Invalid Selection"
    end
  end

  def print_board
    converts = {7=>0,6=>1,5=>2,4=>3,3=>4,2=>5,1=>6,0=>7}
    @@board.reverse.each_with_index do |row, i|
      row.each_with_index do |piece, index|
        if (i.even? && index.even?) || (i.odd? && index.odd?)
          if (!(@selected.nil?)) && (@selected.legal_moves.include? [index, converts[i]])
            colorme(piece, :yellow) 
          else
            colorme(piece, :cyan) if piece == " "
          end
          colorme(piece.display, :cyan) if piece != " " && piece != @selected
          colorme(piece.display, :yellow) if piece == @selected
        else
          if (!(@selected.nil?)) && (@selected.legal_moves.include? [index, converts[i]])
            colorme(piece, :light_yellow) 
          else
            colorme(piece, :white) if piece == " "
          end
          colorme(piece.display, :white) if piece != " " && piece != @selected
          colorme(piece.display, :light_yellow) if piece == @selected
        end
      end
      puts
    end
    return
  end

  def colorme(object, bg_color)
    print (" " + object + " ").colorize(:color => :black, :background => bg_color )
  end
end

require_relative "pieces_lib/pawn"
require_relative "pieces_lib/rook"
require_relative "pieces_lib/bishop"
require_relative "pieces_lib/queen"
require_relative "pieces_lib/knight"
require_relative "pieces_lib/king"

myboard = Board.new
myboard.board[4][4] = Knight.new 4,4
myboard.select "e5"
myboard.board[3][3] = Rook.new 3,3
myboard.board[7][3] = Pawn.new 3,7,'b'
myboard.board[0][3] = Pawn.new 3,0,'b'
myboard.board[3][0] = Pawn.new 0,3,'b'
myboard.board[3][7] = Pawn.new 7,3,'b'
myboard.select "d4"
myboard.selected.legal_moves
myboard.selected.move 0,3
myboard.selected.legal_moves
myboard.selected.move 0,4
myboard.select 'b7'
myboard.selected.legal_moves
myboard.selected.move 1,4
myboard.select 'a5'
myboard.selected.en_passant?
myboard.selected.move 1,5

myboard.select 'c7'
myboard.selected.legal_moves
myboard.selected.move 2,4
myboard.selected.legal_moves
myboard.selected.move 2,3
myboard.select 'b2'
myboard.selected.legal_moves
myboard.selected.move 1,3
myboard.select 'c4'
myboard.selected.en_passant?
myboard.selected.move 1,2

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