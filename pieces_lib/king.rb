class King < Pieces

  def display
    return "\u2654" if @color == 'w'
    return "\u265A" if @color == 'b'
  end

  def get_all_moves(mode = "legal")
    x1 = @x + 1
    y1 = @y + 1
    x2 = @x - 1
    y2 = @y - 1
    lines = [[@x,y1],[@x,y2],[x1,y1],[x1,y2],[x1,@y],[x2,y1],[x2,y2],[x2,@y]]
    lines.each do |ords|
      x = ords[0]
      y = ords[1]
      if CONDITION.call(x,y)
        if mode == "legal"
          get_legal_moves(x, y)
        else
          get_capture_moves(x, y)
        end
      end
    end
  end

  def king_legal_moves
    find_all_legal_moves
    legal_moves
    @legal_moves -= @@all_legal_moves
  end
  
  def king_capture_moves
    find_all_legal_moves
    capture_moves
    @capture_moves -= @@all_legal_moves
  end

  def possible_moves
    @possible_moves = []
    @possible_moves = king_legal_moves + king_capture_moves
  end
end