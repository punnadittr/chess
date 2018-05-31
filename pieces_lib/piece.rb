class Pieces < Board
  
  CONDITION = lambda { |pos| pos >= 0 && pos <= 7 }
  attr_reader :color, :legal_moves, :capture_moves, :x, :y, :possible_moves, :position

  def initialize(x,y, color = 'w')
    @color = color
    @x = x
    @y = y
    @position = [x,y]
    @possible_moves = []
    @legal_moves = []
    @capture_moves
  end

  def get_moves(mode, x, y)
    if mode == "legal"
      if @@board[y][x] == " "
        @legal_moves << [x,y]
        return false
      end
      return true
    elsif mode == "capture"
      if @@board[y][x] != " "
        # Add the position to capture move if color is different
        if @@board[y][x].color != self.color
          @capture_moves << [x,y]
          return true
        # If the position has the piece with same color
        else
          return true
        end
      end
      return false
    end
  end

  def capture_moves
    @capture_moves = []
    legal_moves("capture")
    @capture_moves
  end

  def move(x, y)
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