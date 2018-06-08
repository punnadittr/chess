# defines game logic / determines game over / get user_input
class Game < Board

  def initialize
    @checked = false
    @game_over = false
    @turn = "w"
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

  def switch_turn
    return @turn = "b" if @turn == "w"
    return @turn = "w" if @turn == "b"
  end

  def convert_move(position)
    return "INVALID INPUT(CV)" if position.length != 2
    input_codes = {'a'=>0,'b'=>1,'c'=>2,'d'=>3,'e'=>4,'f'=>5,'g'=>6,'h'=>7}
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