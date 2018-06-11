# defines game logic / determines game over / get user_input
class Game < Board

  def initialize
    @checked = false
    @game_over = false
    @turn = "w"
  end

  def selected
    @@selected
  end

  def alter(color)
    return "w" if color == "b"
    return "b" if color == "w"
  end

  def turn
    @turn
  end

  def in_check?
    if checking_piece.nil?
      false
    else
      true
    end
  end

  def start_game
    board = Board.new
    board.setup
    print_board
    play_game
  end

  def game_over?
    if checkmate? || stalemate?
      true
    else 
      false
    end
  end

  def play_game
    while !game_over?
      track_input
    end
  end

  def track_input
    puts "#{@turn}'s turn, Please select a piece"
    user_input = gets.chomp
    if user_input == "deselect"
      deselect
      puts "Deselected, please select a new piece"
    elsif @@selected.nil?
      select(user_input)
      print_board
    elsif !@@selected.nil?
      @@selected.move(user_input)
      switch_turn
    elsif user_input == "save"
      save
    elsif user_input == "load"
      load
    else
      puts "INVALID INPUT"
    end
  end

  def deselect
    @@selected = nil
    print_board
  end

  def checkmate?
    king = @@w_king if @turn == "w"
    king = @@b_king if @turn == "b"
    if !in_check?
      return false
    else
      if (all_legal_moves & blocking_moves).empty? &&
        !all_capture_moves(alter(@turn)).include?(@@checking_piece.position) &&
        king.king_legal_moves.empty?
        return true
      end
    end
    false
  end

  def stalemate?
    return true if (all_legal_moves.empty?) && (all_capture_moves(alter(@turn)).empty?)
    false
  end

  def blocking_moves_diagonal(king, check_piece, x_result, y_result)
    x = check_piece.x
    y = check_piece.y
    if x_result.positive?
      if y_result.negative?
        until x+1 == king.x || y-1 == king.y
          @blocking_moves << [x+1, y-1]
          x += 1
          y -= 1
        end
      else
        until x+1 == king.x || y+1 == king.y
          @blocking_moves << [x+1,y+1]
          x += 1
          y += 1
        end
      end
    elsif x_result.negative?
      if y_result.negative?
        until x-1 == king.x || y-1 == king.y
          @blocking_moves << [x-1, y-1]
          x -= 1
          y -= 1
        end
      else
        until x-1 == king.x || y+1 == king.y
          @blocking_moves << [x-1,y+1]
          x -= 1
          y += 1
        end
      end
    end
    @blocking_moves
  end

  def blocking_moves
    @blocking_moves = []
    non_blockable_pieces = [Knight, Pawn]
    return @blocking_moves if non_blockable_pieces.include?(@@checking_piece.class)
    king = @@w_king if @turn == "w"
    king = @@b_king if @turn == "b"
    check = @@checking_piece
    x_result = king.x - check.x
    y_result = king.y - check.y
    if x_result.zero? || y_result.zero?
      @@checking_piece.legal_moves.each do |position|
        x_ord = position[0]
        y_ord = position[1]
        x1 = king.x < check.x ? king.x : check.x
        x2 = king.x >= check.x ? king.x : check.x
        y1 = king.y < check.y ? king.y : check.y
        y2 = king.y >= check.y ? king.y : check.y
        if (x_ord.between?(x1,x2)) && (y_ord.between?(y1,y2))
          @blocking_moves << [x_ord,y_ord]
        end
      end
      @blocking_moves
    else
      blocking_moves_diagonal(king, check, x_result, y_result)
    end
  end

  # Returns the piece that is checking the king
  def checking_piece
    king = @@w_king if @turn == "w"
    king = @@b_king if @turn == "b"
    @@checking_piece = nil
    @@board.each do |row|
      row.each do |piece|
        next if piece == " " || piece.color == king.color
        piece.legal_moves
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
        if piece.class == King
          @@all_legal_moves << piece.king_legal_moves
        else
          @@all_legal_moves << piece.legal_moves
        end
      end
    end
    @@all_legal_moves.flatten!(1)
  end

  def find_possible_check_moves
    @@possible_check_moves = []
    @@board.each do |row|
      row.each do |piece|
        if @@selected != nil
          if piece.class == Pawn && piece.color != @@selected.color
            @@possible_check_moves << piece.possible_capture_moves
          elsif piece != " " && piece.color != @@selected.color
            piece.capture_moves
            @@possible_check_moves << piece.legal_moves << piece.check_move
          end
        end
      end
    end
    if @@possible_check_moves.empty?
      []
    else
      @@possible_check_moves.flatten!(1)
    end
  end

  def all_capture_moves(color = self.color)
    @@all_capture_moves = []
    @@board.each do |row|
      row.each do |piece|
        next if piece == " " || piece.color == color
        if piece.class == King
          @@all_capture_moves << piece.king_capture_moves
        else
          @@all_capture_moves << piece.capture_moves
        end
      end
    end
    if @@all_capture_moves.empty?
      []
    else
      @@all_capture_moves.flatten!(1)
    end
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
      if (in_check? && @@selected.class != King)
        if !(@@selected.legal_moves & blocking_moves).empty?
          @@selected.assign_legal_moves = (@@selected.legal_moves & blocking_moves)
          @@selected.assign_capture_moves = []
          @@selected.possible_moves
        elsif !(@@selected.capture_moves.flatten & @@checking_piece.position).empty?
          @@selected.assign_capture_moves = [@@checking_piece.position]
          @@selected.assign_legal_moves = []
          @@selected.possible_moves
        else
          @@selected = nil
          return false
        end
      elsif @@selected.class == King
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