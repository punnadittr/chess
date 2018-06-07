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

  def left_castling
    castling?(-4, -1, 3)
  end

  def right_castling
    castling?(3, 1, 2)
  end

  def castling?(i, k ,j)
    piece = @@board[y][x+i]
    space_counter = 0
    all_capture_moves
    if @moved || piece.class != Rook || piece.moved || 
      @@all_capture_moves.include?(@position)
      return false
    end
    x = @x + k
    j.times do
      return false if @@all_legal_moves.include?([x,y])
      space_counter += 1 if @@board[y][x] == " "
      x = x + k
    end
    if space_counter == j
      true
    else
      false
    end
  end

  def get_castling_moves
    @castling_moves = []
    @right_castling_move = []
    @left_castling_move = []
    if right_castling
      @legal_moves << [@x+2,@y] 
      @right_castling_move << [@x+2,@y] 
    end
    if left_castling
      @legal_moves << [@x-2,@y]
      @left_castling_move << [@x-2,@y]
    end
  end

  def king_legal_moves
    find_all_legal_moves
    legal_moves
    get_castling_moves
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

  def move_rook_castling(x_before, x_after)
    rook = @@board[@y][x_before]
    @@board[@y][x_before] = " "
    @@board[@y][x_after] = rook
    new_rook = @@board[@y][x_after]
    new_rook.x = x_after
    new_rook.position = [x_after, @y]
    new_rook.moved = true
  end

  def move(position)
    possible_moves
    x, y = convert_move(position)
    if @left_castling_move.include?([x,y])
      move_rook_castling(0,3)
      @left_castling_move = []
    elsif @right_castling_move.include?([x,y])
      move_rook_castling(7,5)
      @right_castling_move = []
    end
    if @possible_moves.include? [x,y]
      @@board[@y][@x] = " "
      @@board[y][x] = self
      @x = x
      @y = y
      @position = [x,y]
      @possible_moves = []
      @@selected = nil
      @moved = true
      print_board
    else
      return "INVALID MOVE(MV)"
    end
  end
end