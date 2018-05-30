class Knight < Board

  attr_reader :color
  CONDITION = lambda { |pos| pos <= 7 && pos >= 0 }

  def initialize(x,y, color = 'w')
    @color = color
    @x = x
    @y = y
    @position = [x,y]
    @possible_moves = []
    @legal_moves = []
    @capture_moves = []
  end

  def display
    return "\u2658" if @color == 'w'
    return "\u265E" if @color == 'b'
  end

  def get_legal_move(a,b)
    x = @x+a
    y = @y+b
    x2 = @x+b
    y2 = @y+a
    2.times do
      if CONDITION.call(x) && CONDITION.call(y)
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

  def legal_moves
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

  def move(x,y)
    @possible_moves = @legal_moves + @capture_moves
    if @possible_moves.include? [x,y]
      @@board[@y][@x] = " "
      @@board[y][x] = self
      @x = x
      @y = y
      @position = [x,y]
      @possible_moves = []
      print_board
    else
      return "INVALID MOVE"
    end
  end
end