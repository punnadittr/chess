class Rook < Pieces

  def display
    return "\u2656" if @color == "w"
    return "\u265C" if @color == "b"
  end

  def get_all_moves(mode = "legal")
    x1 = @x - 1
    x2 = @x + 1
    y1 = @y - 1
    y2 = @y + 1
    lines = [[x1,@y],[x2,@y],[@x,y1],[@x,y2]]
    lines.each_with_index do |ords, i|
      x = ords[0]
      y = ords[1]
      while CONDITION.call(x,y)
        if mode == "legal"
          break if get_legal_moves(x, y)
        else
          break if get_capture_moves(x,y)
        end
        x -= 1 if i == 0
        x += 1 if i == 1
        y -= 1 if i == 2
        y += 1 if i == 3
      end
    end
  end
end