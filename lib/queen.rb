class Queen < Pieces

  def display
    return "\u2655" if @color == 'w'
    return "\u265B" if @color == 'b'
  end

  def get_all_moves(mode = "legal")
    x1 = @x + 1
    y1 = @y + 1
    x2 = @x - 1
    y2 = @y - 1
    lines = [[@x,y1],[@x,y2],[x1,y1],[x1,y2],[x1,@y],[x2,y1],[x2,y2],[x2,@y]]
    lines.each_with_index do |ords, i|
      x = ords[0]
      y = ords[1]
      while CONDITION.call(x,y)
        if mode == "legal"
          break if get_legal_moves(x,y)
        else
          break if get_capture_moves(x,y)
        end
        x += 1 if i.between?(2,4)
        x -= 1 if i.between?(5,7)
        y += 1 if [0,2,5].include? i
        y -= 1 if [1,3,6].include? i
      end
    end
  end
end