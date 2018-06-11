# defines game logic / determines game over / get user_input
class Game < Board

  def initialize
    @checked = false
    @game_over = false
    @turn = "w"
  end

  def possible_check_moves
    @@possible_check_moves
  end

  def selected
    @@selected
  end

  def checking_piece
    @@checking_piece
  end

  def alter(color)
    return "w" if color == "b"
    return "b" if color == "w"
  end

  def in_check?
    if checking_piece.nil?
      @checked = false
    else
      @checked = true
    end
  end

  def start_game
    board = Board.new
    board.setup
    print_board
    puts "Welcome to Ruby Chess"
    puts "White player always starts first"
    while true
      puts "#{@turn}'s turn"
      user_selection = gets.chomp
      until select(user_selection)
        puts "INVALID SELECTION"
        user_selection = gets.chomp
      end
      print_board
      puts "Where would you like to move?"
      user_move = gets.chomp
      until(@@selected.move(user_move))
        puts "INVALID MOVE"
        user_move = gets.chomp
      end
      switch_turn
    end
  end

  def deselect
    
  end

  def checkmate?
    king = @w_king if @turn == "w"
    king = @b_king if @turn == "b"
    if !in_check?
      return false
    else
      unless all_legal_moves.include?(blocking_moves) || 
        all_capture_moves(alter(@turn)).include?(@@checking_piece.position) ||
        king.king_legal_moves.empty? == true
        return true
      end
    end
  end

  def stalemate?

  end

  def blocking_moves
    non_blockable_pieces = [Knight, Pawn]
    return if non_blockable_pieces.include?(@@checking_piece.class)
    @blocking_moves = []
    king = @w_king if @turn == "w"
    king = @b_king if @turn == "b"
    check_x = @@checking_piece.x
    check_y = @@checking_piece.y
    @@checking_piece.legal_moves.each do |position|
      x_ord = position[0]
      y_ord = position[1]
      x1 = king.x < check_x ? king.x : check_x
      x2 = king.x >= check_x ? king.x : check_x
      y1 = king.y < check_y ? king.y : check_y
      y2 = king.y >= check_y ? king.y : check_y
      if x_ord.between?(x1,x2) && y_ord.between?(y1,y2)
        @blocking_moves << [x_ord,y_ord]
      end
    end
    @blocking_moves
  end

  # Returns the piece that is checking the king
  def checking_piece
    king = @w_king  if @turn == "w"
    king = @b_king if @turn == "b"
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

  # Legal moves for current player
  def all_legal_moves
    @@all_legal_moves = []
    @@board.each do |row|
      row.each do |piece|
        next if piece == " " || piece.color != @turn
        @@all_legal_moves << piece.legal_moves
      end
    end
    @@all_legal_moves.flatten!(1)
  end

  def find_possible_check_moves
    @@possible_check_moves = []
    @@board.each do |row|
      row.each do |piece|
        next if piece == " " || piece.color == self.color
        if piece.class == Pawn
          @@possible_check_moves << piece.possible_capture_moves
        else
          piece.capture_moves
          @@possible_check_moves << piece.legal_moves << piece.check_move
        end
      end
    end
    @@possible_check_moves.flatten!(1)
  end

  def all_capture_moves(color = self.color)
    @@all_capture_moves = []
    @@board.each do |row|
      row.each do |piece|
        next if piece == " " || piece.color == color
        @@all_capture_moves << piece.capture_moves
      end
    end
    @@all_capture_moves.flatten!(1)
  end

  def switch_turn
    return @turn = "b" if @turn == "w"
    return @turn = "w" if @turn == "b"
  end

  def convert_move(position)
    return "INVALID INPUT(CV)" if position.length != 2
    input_codes = {"a"=>0, "b"=>1, "c"=>2, "d"=>3, "e"=>4, "f"=>5, "g"=>6, "h"=>7}
    x = position[0]
    y = (position[1].to_i) - 1
    if input_codes.include? x
      return input_codes[x], y
    else
      "INVALID INPUT(CV)"
    end
  end

  # input > ex. 'a5'
  def select(position)
    x, y = convert_move(position)
    @@selected = @@board[y][x]
    if @@selected == " " || @@selected.color != @turn
      @@selected = nil
      return false
    else
      if @@selected.class == King
        @@selected.king_legal_moves
        @@selected.king_capture_moves
      else
        @@selected.legal_moves
        @@selected.capture_moves
        @@selected.possible_moves
        @@selected.en_passant? if @@selected.class == Pawn
      end
      return true
    end
  end
end