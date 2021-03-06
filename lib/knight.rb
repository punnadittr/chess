class Knight < Pieces

  def display
    return "\u2658" if @color == 'w'
    return "\u265E" if @color == 'b'
  end

  # Get one legal move of current position
  def get_legal_move(a,b)
    x = @x+a
    y = @y+b
    x2 = @x+b
    y2 = @y+a
    2.times do
      if CONDITION.call(x,y)
        @check_move << [x,y]
        if @@board[y][x] == " "
          @legal_moves << [x,y]
        elsif @@board[y][x].color != self.color
          @capture_moves << [x,y]
        end
      end
      x = x2
      y = y2
    end
  end

  # Get all legal_moves of current position
  def legal_moves
    @check_move = []
    @capture_moves = []
    @legal_moves = []
    get_legal_move(-1, -2)
    get_legal_move(-1, 2)
    get_legal_move(1, -2)
    get_legal_move(1, 2)
    @legal_moves
  end

  def capture_moves
    @capture_moves
  end
end