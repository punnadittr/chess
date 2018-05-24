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

  def promote

  end

  def display
    return "\u2659" if @color == 'w'
    return "\u265F" if @color == 'b'
  end

  def legal_moves
    @possible_moves = []
    @legal_moves = []
    # Different Y coordinates for black and white pieces (moving up and down)
    if self.color == 'w'
      y = @y + 1
      y2 = @y + 2
    elsif self.color == 'b'
      y = @y - 1
      y2 = @y - 2
    end
    # The move is available if the space is empty
    if @@board[y][@x] == " "
      @legal_moves << [@x, y]
      @possible_moves << [@x, y]
    end
    # For first move of a pawn, 2 moves forward is allowed
    if @first_move && @@board[y2][@x] == " " && (@@board[y][@x] == " ")
      @legal_moves << [@x, y2] 
      @possible_moves << [@x, y2]
    end
    @possible_moves
  end

  def capture_moves
    x = @x - 1
    y = @y + 1 if self.color == 'w'
    y = @y - 1 if self.color == 'b'
    2.times do
      if @@board[y][x] != nil && @@board[y][x] != " " && @@board[y][x].color != self.color
        @capture_moves << [x, y]
        @possible_moves << [x, y]
      end
      x += 2
    end
    @capture_moves
  end

  def move(x_co, y_co)
    current_x = @x
    current_y = @y
    if @possible_moves.include? [x_co, y_co]
      # Replace the old space with ' '
      @@board[current_y][current_x] = ' ' 
      # Replace ' ' with current pawn piece
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