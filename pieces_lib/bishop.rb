class Bishop < Board

  CONDITION = lambda { |pos| pos >= 0 && pos <= 7 }
  attr_reader :color

  def initialize(x,y, color = 'w')
    @color = color
    @x = x
    @y = y
    @position = [x,y]
    @possible_moves = []
    @legal_moves = []
  end

  def display
    return "\u2657" if @color == 'w'
    return "\u265D" if @color == 'b'
  end

  def legal_moves
    @legal_moves = []
    x1 = @x + 1
    y1 = @y + 1
    x2 = @x - 1
    y2 = @y - 1
    lines = [[x1,y1],[x1,y2],[x2,y1],[x2,y2]]
    lines.each_with_index do |ords, i|
      x = ords[0]
      y = ords[1]
      while CONDITION.call(x) && CONDITION.call(y)
        if @@board[y][x] == " "
          @legal_moves << [x,y]
        end
        x += 1 if i < 2
        x -= 1 if i >= 2
        y += 1 if i.even?
        y -= 1 if i.odd?
      end
    end
    @legal_moves
  end

  def capture_moves
    nil
  end

end