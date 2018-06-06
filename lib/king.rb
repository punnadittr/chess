class King < Pieces

  def display
    return "\u2654" if @color == 'w'
    return "\u265A" if @color == 'b'
  end

  def get_all_moves(mode = "legal")
    x1 = @x + 1
    y1 = @y + 1
    x2 = @x - 1
    y2 = @y - 1
    lines = [[@x,y1],[@x,y2],[x1,y1],[x1,y2],[x1,@y],[x2,y1],[x2,y2],[x2,@y]]
    lines.each do |ords|
      x = ords[0]
      y = ords[1]
      if CONDITION.call(x,y)
        if mode == "legal"
          get_legal_moves(x, y)
        else
          get_capture_moves(x, y)
        end
      end
    end
  end

  def castling_move
    @castling_moves = []
    return false if @moved
    right_spaces = []
    left_spaces = []
    x1 = @x + 1
    x2 = @x - 1
    y = @y
    right_rook = @@board[y][x+3]
    left_rook = @@board[y][x-4]
    for i in 1..5 do
      if i < 3
        right_spaces << [true] if @@board[y][x1] == " "
        x1 += 1
      elsif i >= 3
        left_spaces << [true] if @@board[y][x2] == " "
        x2 -= 1
      end
      if right_spaces.size == 2 && right_rook.class == Rook && right_rook.moved == false
        @legal_moves << [@x+2,@y] 
        @castling_moves << [@x+2,@y] 
      end
      if left_spaces.size == 3 && left_rook.class == Rook && left_rook.moved == false
        @legal_moves << [@x-3,@y] 
        @castling_moves << [@x-3,@y] 
      end
      return true if !@castling_moves.empty?
    end
  end

  def king_legal_moves
    find_all_legal_moves
    legal_moves
    @legal_moves -= @@all_legal_moves
  end
  
  def king_capture_moves
    find_all_legal_moves
    capture_moves
    @capture_moves -= @@all_legal_moves
  end

  def possible_moves
    @possible_moves = []
    @possible_moves = king_legal_moves + king_capture_moves
  end
end