class Rook < Board

  attr_reader :legal_moves, :color, :capture_moves

  def initialize(x,y, color = 'w')
    @color = color
    @x = x
    @y = y
    @position = [x,y]
    @possible_moves = []
  end

  def display
    return "\u2656" if @color == 'w'
    return "\u265C" if @color == 'b'
  end

  def legal_moves
    @legal_moves = []
    x = @x + 1
    x1 = @x - 1
    y1 = @y - 1
    y = @y + 1
    until y > 7 || @@board[y][@x] != " "
      @legal_moves << [@x,y]
      y += 1
    end
    until x > 7 || @@board[@y][x] != " "
      @legal_moves << [x,@y]
      x += 1
    end
    until x1 < 0 || @@board[@y][x1] != " "
      @legal_moves << [x1, @y]
      x1 -= 1
    end
    until y1 < 0 || @@board[y1][@x] != " "
      @legal_moves << [@x, y1]
      y1 -= 1
    end
  end

  def get_capture(x,y)
    if @@board[y][x] != " " && @@board[y][x].color != self.color
      @capture_moves << [x,y]
      return true
    end
    false
  end

  def capture_moves
    @capture_moves = []
    x1 = x2 = @x
    y1 = y2 = @y
    lines = [x1,x2,y1,y2]
    condition1 = lambda { |pos| pos >= 0 }
    condition2 = lambda { |pos| pos <= 7 }
    conditions = [condition1, condition2, condition1, condition2]
    lines.each_with_index do |ord,i|
      while conditions[i].call(ord)
        if i < 2
          break if get_capture(ord,@y)
        else
          break if get_capture(@x,ord)
        end
        ord -= 1 if i.even?
        ord += 1 if i.odd?
      end
    end
  end
end