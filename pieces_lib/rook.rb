class Rook < Board

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
    
  end

end