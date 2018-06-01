class Queen < Pieces

  def display
    return "\u2655" if @color == 'w'
    return "\u265B" if @color == 'b'
  end

  def legal_moves(mode = "legal")
    @check_move = [] if mode == "legal"
    @legal_moves = [] if mode == "legal"
    x = @x
    y = @y
    x1 = @x + 1
    y1 = @y + 1
    x2 = @x - 1
    y2 = @y - 1
    lines = [[x,y1],[x,y2],[x1,y1],[x1,y2],[x1,y],[x2,y1],[x2,y2],[x2,y]]
    lines.each_with_index do |ords, i|
      x = ords[0]
      y = ords[1]
      while CONDITION.call(x) && CONDITION.call(y)
        break if get_moves(mode, x, y)
        if i < 2
          y += 1 if i == 0
          y -= 1 if i == 1
        elsif i >= 2 && i < 5
          x += 1
          y += 1 if i == 2
          y -= 1 if i == 3
        else
          x -= 1
          y += 1 if i == 5
          y -= 1 if i == 6
        end
      end
    end
    @legal_moves
  end
end