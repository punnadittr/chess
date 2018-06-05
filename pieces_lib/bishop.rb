class Bishop < Pieces

  def display
    return "\u2657" if @color == 'w'
    return "\u265D" if @color == 'b'
  end

  def get_all_moves(mode = "legal")
    x1 = @x + 1
    y1 = @y + 1
    x2 = @x - 1
    y2 = @y - 1
    lines = [[x1,y1],[x1,y2],[x2,y1],[x2,y2]]
    lines.each_with_index do |ords, i|
      x = ords[0]
      y = ords[1]
      while CONDITION.call(x,y)
        if mode == "legal"
          break if get_legal_moves(x,y)
        else
          break if get_capture_moves(x,y)
        end
        x += 1 if i < 2
        x -= 1 if i >= 2
        y += 1 if i.even?
        y -= 1 if i.odd?
      end
    end
  end
end