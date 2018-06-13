# defines game logic / determines game over / get user_input
class Game < Board

  def initialize(turn = "w")
    @turn = turn
  end

  def selected
    @@selected
  end

  def turn
    @turn
  end

  def turn=(newturn)
    @turn = newturn
  end

  def enemy_in_check?
    if checking_piece.nil?
      false
    else
      true
    end
  end

  def in_check?
    if enemy_checking_piece.nil?
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
    puts "BLACK WINS" if turn == "b"
    puts "WHITE WINS" if turn == "w"
  end

  def track_input
    puts "#{turn}'s turn, Please select a piece"
    user_input = gets.chomp
    if user_input == "deselect"
      deselect
      puts "Deselected, please select a new piece"
    elsif user_input == "save"
      save
    elsif user_input == "load"
      load
      print_board
    elsif @@selected.nil?
      select(user_input)
      print_board
    elsif !@@selected.nil?
      if @@selected.move(user_input) && !game_over?
        switch_turn
      end
    else
      puts "INVALID INPUT"
    end
  end

  def save
    saved_turn = turn.to_json
    saved_board = @@board.to_json
    File.open("save_game.json", "w") { |file| file.write(saved_board) }
    File.open("turn.json", "w") { |file| file.write(saved_turn) }
    puts "Game Saved!"
  end

  def load
    board_save = File.open("save_game.json", "r").read
    turn_save = File.open("turn.json", "r").read
    @@board = JSON.load(board_save)
    @turn = JSON.load(turn_save)
    puts "Game Loaded!"
  end

  def deselect
    @@selected = nil
    print_board
  end

  def set_alter_king
    return @@b_king if @turn == "w"
    return @@w_king if @turn == "b"
  end

  def set_king
    return @@w_king if @turn == "w"
    return @@b_king if @turn == "b"
  end

  def no_blocking_moves?
    (enemy_legal_moves & blocking_moves("mate")).empty?
  end

  def no_defending_moves?
    !enemy_capture_moves.include?(checking_piece.position)
  end

  def no_legal_moves?(king)
    king.king_legal_moves.empty?
  end

  def checkmate?
    king = set_alter_king
    if !enemy_in_check?
      false
    else
      if no_blocking_moves? && no_defending_moves? && no_legal_moves?(king)
        true
      else
        false
      end
    end
  end

  def stalemate?
    if enemy_legal_moves.empty? && all_capture_moves.empty?
      true
    else
      false
    end
  end

  def non_blockable_check?
    enemy_checking_piece.class == Knight || enemy_checking_piece.class == Pawn
  end

  def find_min_max(num1, num2)
    min = [num1, num2].min
    max = [num1, num2].max
    return min, max
  end

  def blocking_moves_vert_hor(king, check)
    check.legal_moves.each do |position|
      x_ord = position[0]
      y_ord = position[1]
      x1, x2 = find_min_max(king.x, check.x)
      y1, y2 = find_min_max(king.y, check.y)
      if (x_ord.between?(x1,x2)) && (y_ord.between?(y1,y2))
        @blocking_moves << [x_ord,y_ord]
      end
    end
    @blocking_moves
  end

  def blocking_moves_diagonal(king, check_piece, x_diff, y_diff)
    conditions = [
      [x_diff.negative?, y_diff.positive?],[x_diff.negative?, y_diff.negative?],
      [x_diff.positive?, y_diff.positive?],[x_diff.positive?, y_diff.negative?]
    ]
    conditions.each_with_index do |condition, i|
      x = check_piece.x + 1 if i > 1
      x = check_piece.x - 1 if i < 2
      y = check_piece.y + 1 if i.even?
      y = check_piece.y - 1 if i.odd?
      if condition[0] && condition[1]
        until x == king.x || y == king.y
          @blocking_moves << [x, y]
          x += 1 if i > 1
          x -= 1 if i < 2
          y += 1 if i.even?
          y -= 1 if i.odd?
        end
      end
    end
    @blocking_moves
  end

  def blocking_moves(mode = "self")
    @blocking_moves = []
    check = enemy_checking_piece if mode == "self"
    check = checking_piece if mode == "mate"
    return [] if non_blockable_check? || check.nil?
    king = set_king if mode == "self"
    king = set_alter_king if mode == "mate"
    x_diff = king.x - check.x
    y_diff = king.y - check.y
    if x_diff.zero? || y_diff.zero?
      blocking_moves_vert_hor(king, check)
    else
      blocking_moves_diagonal(king, check, x_diff, y_diff)
    end
  end

  def enemy_checking_piece
    king = set_king
    get_checking_piece(king) { |x| x != turn }
  end

  # Returns the piece that is checking the king
  def checking_piece
    king = set_alter_king
    get_checking_piece(king) { |x| x == turn }
  end

  def get_checking_piece(king, &block)
    checking = nil
    for_each_piece do |piece|
      if piece != " " && block.call(piece.color)
        piece.legal_moves
        if piece.capture_moves.include?(king.position)
          checking = piece
        end
      end
    end
    checking
  end

  def for_each_piece
    @@board.each do |row|
      row.each do |element|
        yield element
      end
    end
  end

  def all_moves(mode, &block)
    keep = []
    for_each_piece do |piece|
      if piece.class == King && block.call(piece.color)
        keep << piece.king_legal_moves if mode == "legal"
        keep << piece.king_capture_moves if mode == "capture"
      elsif piece != " " && block.call(piece.color)
        keep << piece.legal_moves if mode == "legal"
        keep << piece.capture_moves if mode == "capture"
      end
    end
    return keep if keep.empty?
    keep.flatten!(1)
  end

  def enemy_legal_moves
    all_moves("legal") { |x| x != turn }
  end

  # Legal moves for current player
  def all_legal_moves
    all_moves("legal") { |x| x == turn }
  end

  # All capture moves of enemy
  def enemy_capture_moves
   all_moves("capture") { |x| x != turn }
  end

  # All capture moves of current player
  def all_capture_moves
    all_moves("capture") { |x| x == turn }
  end

  # Always called upon a King piece
  def enemy_possible_check_moves
    keep = []
    for_each_piece do |piece|
      unless piece == " " || piece.color == self.color
        if piece.class == Pawn
          keep << piece.possible_capture_moves
        else
          piece.capture_moves
          keep << piece.legal_moves << piece.check_move
        end
      end
    end
    return keep if keep.empty?
    keep.flatten!(1)
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

  def any_blocking_moves?
    !(@@selected.legal_moves & blocking_moves).empty?
  end

  def any_capture_moves?
    !(@@selected.capture_moves.flatten & enemy_checking_piece.position).empty?
  end

  def assign_new_moves(moves_1, moves_2)
    @@selected.assign_legal_moves = moves_1
    @@selected.assign_capture_moves = moves_2
    @@selected.possible_moves
  end

  def get_moves(type)
    if type == "king"
      @@selected.king_legal_moves
      @@selected.king_capture_moves
    else
      @@selected.legal_moves
      @@selected.capture_moves
      @@selected.possible_moves
      @@selected.en_passant? if @@selected.class == Pawn
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
        if any_blocking_moves?
          assign_new_moves(@@selected.legal_moves & blocking_moves, [])
        elsif any_capture_moves?
          assign_new_moves([],[enemy_checking_piece.position])
        else
          @@selected = nil
          return false
        end
      else
        @@selected.class == King ? get_moves("king") : get_moves("other")
      end
      return true
    end
  end
end