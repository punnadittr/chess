class Rook < Board

  CONDITION1 = lambda { |pos| pos >= 0 }
  CONDITION2 = lambda { |pos| pos <= 7 }
  CONDITIONS = [CONDITION1,CONDITION2,CONDITION1,CONDITION2]
  attr_reader :color, :capture_moves

  def initialize(x,y, color = "w")
    @color = color
    @x = x
    @y = y
    @position = [x,y]
    @possible_moves = []
  end

  def display
    return "\u2656" if @color == "w"
    return "\u265C" if @color == "b"
  end

  def get_moves(mode,x,y)
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

  def legal_moves(mode = "legal")
    @possible_moves = []
    @legal_moves = [] if mode == "legal"
    x1 = @x - 1
    x2 = @x + 1
    y1 = @y - 1
    y2 = @y + 1
    lines = [x1,x2,y1,y2]
    lines.each_with_index do |ord, i|
      while CONDITIONS[i].call(ord)
        if i < 2
          break if get_moves(mode,ord, @y)
        else
          break if get_moves(mode,@x, ord)
        end
        ord -= 1 if i.even?
        ord += 1 if i.odd?
      end
    end
    @legal_moves
  end

  def capture_moves
    @capture_moves = []
    legal_moves("capture")
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