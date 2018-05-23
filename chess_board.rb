require "colorize"
# create a chessboard and function to assign item to the board
class Board
  attr_accessor :board

  def board
    @@board
  end

  def initialize
    @@board = [
      [" "," "," "," "," "," "," "," "],
      [" "," "," "," "," "," "," "," "],
      [' ',' ',' ',' ',' ',' ',' ',' '],
      [' ',' ',' ',' ',' ',' ',' ',' '],
      [' ',' ',' ',' ',' ',' ',' ',' '],
      [' ',' ',' ',' ',' ',' ',' ',' '],
      [" "," "," "," "," "," "," "," "],
      [" "," "," "," "," "," "," "," "]
    ]
  end

  def put_piece

  end

  def setup
    
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
  end

  def colorme(object, main_color, bg_color)
    print 
    print (' ' + object + ' ').colorize(:color => main_color, :background => bg_color )
  end
end

require_relative "chess_piece"

myboard = Board.new
pawn1 = Pawn.new 2,4
pawn2 = Pawn.new 3,5,'b'
pawn3 = Pawn.new 1,5,'b'
myboard.board[4][2] = pawn1
myboard.board[5][3] = pawn2
myboard.board[5][1] = pawn3
myboard.print_board
pawn1.legal_moves
pawn1.capture_moves
myboard.print_board


=begin
    @@board = [
      ["\u2656","\u2658","\u2657","\u2655","\u265A","\u2657","\u2658","\u2656"],
      ["\u2659","\u2659","\u2659","\u2659","\u2659","\u2659","\u2659","\u2659"],
      [' ',' ',' ',' ',' ',' ',' ',' '],
      [' ',' ',' ',' ',' ',' ',' ',' '],
      [' ',' ',' ',' ',' ',' ',' ',' '],
      [' ',' ',' ',' ',' ',' ',' ',' '],
      ["\u2659","\u2659","\u2659","\u2659","\u2659","\u2659","\u2659","\u2659"],
      ["\u2656","\u2658","\u2657","\u2655","\u265A","\u2657","\u2658","\u2656"]
    ]
=end