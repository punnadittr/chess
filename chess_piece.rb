class Pawn < Board
  attr_reader :possible_moves, :color

  def initialize(x,y, color = 'w')
    @color = color
    @x = x
    @y = y
    @position = [x,y]
    @first_move = true
    @possible_moves = []
    @legal_moves = []
    @capture_moves = []
  end

  def display
    return "\u2659" if @color == 'w'
    return "\u265F" if @color == 'b'
  end

  def legal_moves
    if @@board[@y+1][@x] == " "
      @legal_moves << [@x, @y+1]
    end
    if @first_move && @@board[@y+2][@x] == " " && (@@board[@y+1][@x] == " ")
      @legal_moves << [@x, @y+2] 
    end
    @possible_moves << @legal_moves
  end

  def capture_moves
    x = @x - 1
    y = @y + 1
    2.times do
      if @@board[y][x] != nil && @@board[y][x] != " " && @@board[y][x].color != self.color
        @capture_moves << [x, y]
      end
      x += 2
    end
    @possible_moves << @capture_moves
    @capture_moves
  end

  def move(x_co, y_co)
    current_x = @x
    current_y = @y
    if @possible_moves.include? [x_co, y_co]
      @@board[current_y][current_x] = ' '
      @@board[y_co][x_co] = self
      @x = x_co
      @y = y_co
      @position = [@x, @y]
      @first_move = false
      @possible_moves = []
    else
      "INVALID MOVE"
    end
  end
end