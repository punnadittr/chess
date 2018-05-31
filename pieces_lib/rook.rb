class Rook < Pieces

  CONDITION1 = lambda { |pos| pos >= 0 }
  CONDITION2 = lambda { |pos| pos <= 7 }
  CONDITIONS = [CONDITION1,CONDITION2,CONDITION1,CONDITION2]

  def display
    return "\u2656" if @color == "w"
    return "\u265C" if @color == "b"
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
end