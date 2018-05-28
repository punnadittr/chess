class Knight < Board

  def initialize(x,y, color = 'w')
    @color = color
    @x = x
    @y = y
    @position = [x,y]
    @possible_moves = []
  end

  def display
    return "\u2658" if @color == 'w'
    return "\u265E" if @color == 'b'
  end

end