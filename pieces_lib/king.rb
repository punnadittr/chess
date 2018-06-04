class King < Pieces

  def display
    return "\u2654" if @color == 'w'
    return "\u265A" if @color == 'b'
  end

  def get_all_moves(mode = "legal", pawn_call = false)
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
          get_legal_moves(x,y)
        else
          get_capture_moves(x,y)
        end
      end
    end
  end

  def legal_moves(mode = "before")
    @legal_moves = []
    get_all_moves("legal")
    if mode == "before"
      @legal_moves
    else
      unless @legal_moves.empty?
        return @legal_moves -= remove_check_pos
      end
      return @legal_moves
    end
  end
  
  def capture_moves(mode = "before")
    @capture_moves = []
    get_all_moves("capture")
    if mode == "before"
      @capture_moves
    else
      unless @capture_moves.empty?
        return @capture_moves -= remove_check_pos
      end
      return @capture_moves
    end
  end

  def remove_check_pos
    illegal_moves = []
    @@board.each do |row|
      row.each do |piece|
        if piece != " " && piece.color != @color
          piece_moves = piece.check_move
          illegal_moves << piece_moves if !piece_moves.nil? && !piece_moves.empty?
        end
      end
    end
    illegal_moves.flatten(1)
  end
end