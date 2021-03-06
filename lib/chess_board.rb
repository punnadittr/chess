require "colorize"
require "json"
# Create a chessboard and function to assign item to the board
class Board

  attr_reader :w_king, :b_king

  def board
    @@board
  end

  def initialize
    @@selected = nil
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
    color = "w"
    2.times do
      @@board[row].each_index do |i|
        @@board[row][i] = Pawn.new(i, row, color)
      end
      row = 6
      color = "b"
    end
  end

  def put_piece(piece, x, y, color)
    @@board[y][x] = piece.new(x, y, color)
  end

  def setup
    put_pawns
    row = 0
    color = "w"
    2.times do
      @@board[row].each_index do |i|
        put_piece(Rook, i, row, color) if i == 0 || i == 7
        put_piece(Knight, i, row, color) if i == 1 || i == 6
        put_piece(Bishop, i, row, color) if i == 2 || i == 5
        put_piece(Queen, i, row, color) if i == 3
        put_piece(King, i, row, color) if i == 4
      end
      row = 7
      color = 'b'
    end
    @@w_king = @@board[0][4]
    @@b_king = @@board[7][4]
  end

  def colorize_spaces(piece, highlight, regular, capture, x, y)
    # Reversing y when printing
    converts = {7=>0, 6=>1, 5=>2, 4=>3, 3=>4, 2=>5, 1=>6, 0=>7}
    # Empty space case
    if piece == " "
      # If the space belongs to legal moves of the selected piece, highlight yellow
      if !@@selected.nil? && (@@selected.show_legal_moves.include? [x, converts[y]])
        print_and_colorize(piece, highlight)
      # If not then print regular color
      else
        print_and_colorize(piece, regular)
      end
    # Not empty case (piece exists)
    else 
      if !@@selected.nil? && (@@selected.show_capture_moves.include? piece.position)
        print_and_colorize(piece.display, capture)
      elsif piece == @@selected
        print_and_colorize(piece.display, highlight)
      else
        print_and_colorize(piece.display, regular)
      end
    end
  end

  def print_board
    i = 8
    @@board.reverse.each_with_index do |row, y|
      print " #{i} "
      row.each_with_index do |piece, x|
        if (y.even? && x.even?) || (y.odd? && x.odd?)
          colorize_spaces(piece, :yellow, :cyan, :light_red, x, y)
        else
          colorize_spaces(piece, :light_yellow, :white, :light_red, x, y)
        end
      end
      puts
      i -= 1
    end
    puts "    a  b  c  d  e  f  g  h"
    return
  end

  def print_and_colorize(object, bg_color)
    print (" " + object + " ").colorize(:color => :black, :background => bg_color )
  end
end

require_relative "chess_game"
require_relative "piece"
require_relative "pawn"
require_relative "rook"
require_relative "bishop"
require_relative "queen"
require_relative "knight"
require_relative "king"

game = Game.new
myboard = Board.new
game.start_game