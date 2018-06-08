require "colorize"
# Create a chessboard and function to assign item to the board
class Board

  attr_reader :all_legal_moves, :w_king, :b_king

  def checking_piece
    @@checking_piece
  end

  def all_capture_moves
    @@all_capture_moves
  end

  def all_legal_moves
    @@all_legal_moves
  end

  def selected
    @@selected
  end

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
    color = 'w'
    2.times do
      @@board[row].each_index do |i|
        @@board[row][i] = Pawn.new(i, row, color)
      end
      row = 6
      color = 'b'
    end
  end

  def put_piece(piece, x, y, color)
    @@board[y][x] = piece.new(x, y, color)
  end

  def setup
    put_pawns
    row = 0
    color = 'w'
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
    @b_king = @@board[7][4]
  end

  # input > ex. 'a5'
  def select(position)
    x = position[0]
    y = (position[1].to_i) - 1
    input_codes = {'a'=>0,'b'=>1,'c'=>2,'d'=>3,'e'=>4,'f'=>5,'g'=>6,'h'=>7}
    if input_codes.include? x
      @@selected = @@board[y][input_codes[x]]
      if @@selected == ' '
        @@selected = nil
        return "Invalid Selection"
      else
        if @@selected.class == King
          print "Legal Moves: #{@@selected.king_legal_moves}\n"
          print "Capture Moves: #{@@selected.king_capture_moves}\n"
        else
          print "Legal Moves: #{@@selected.legal_moves}\n"
          print "Capture Moves: #{@@selected.capture_moves}\n"
          print "Possible Moves: #{@@selected.possible_moves}\n"
          print "En Passant Moves: #{@@selected.en_passant?}\n" if @@selected.class == Pawn
        end
        return "Selected " + position
      end
    else
      return "Invalid Selection"
    end
  end

  def blocking_moves
    non_blockable_pieces = [Knight, Pawn]
    return if non_blockable_pieces.include?(@@checking_piece.class)
    @blocking_moves = []
    if @@checking_piece.color == 'b'
      king = @w_king 
    else
      king = @b_king
    end
    check_x = @@checking_piece.x
    check_y = @@checking_piece.y
    @@checking_piece.legal_moves.each do |position|
      x_ord = position[0]
      y_ord = position[1]
      first_x = king.x < check_x ? king.x : check_x
      second_x = king.x >= check_x ? king.x : check_x
      first_y = king.y < check_y ? king.y : check_y
      second_y = king.y >= check_y ? king.y : check_y
      if (x_ord.between?(first_x, second_x)) && (y_ord.between?(first_y, second_y))
        @blocking_moves << [x_ord,y_ord]
      end
    end
    @blocking_moves
  end

  def checking_piece
    @w_king = @@board[3][2]
    king = @w_king
    @@checking_piece = nil
    @@board.each do |row|
      row.each do |piece|
        next if piece == " " || piece.color == king.color
        if piece.capture_moves.include?(king.position)
          @@checking_piece = piece
        end
      end
    end
    @@checking_piece
  end

  def find_possible_check_moves
    @@all_legal_moves = []
    @@board.each do |row|
      row.each do |piece|
        next if piece == " " || piece.color == self.color
        if piece.class == Pawn
          @@all_legal_moves << piece.possible_capture_moves
        else
          piece.capture_moves
          @@all_legal_moves << piece.legal_moves << piece.check_move
        end
      end
    end
    @@all_legal_moves.flatten!(1)
  end

  def all_capture_moves
    @@all_capture_moves = []
    @@board.each do |row|
      row.each do |piece|
        next if piece == " " || piece.color == self.color
        @@all_capture_moves << piece.capture_moves
      end
    end
    @@all_capture_moves.flatten!(1)
  end

  def colorize_spaces(piece, highlight, regular, capture, x, y)
    # Reversing y when printing
    converts = {7=>0,6=>1,5=>2,4=>3,3=>4,2=>5,1=>6,0=>7}
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

require_relative "piece"
require_relative "pawn"
require_relative "rook"
require_relative "bishop"
require_relative "queen"
require_relative "knight"
require_relative "king"
require_relative "chess_game"
myboard = Board.new
myboard.board[3][2] = King.new(2,3)
myboard.board[7][6] = Bishop.new(6,7,'b')
myboard.checking_piece
myboard.blocking_moves