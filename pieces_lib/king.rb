class King < Pieces

  def display
    return "\u2654" if @color == 'w'
    return "\u265A" if @color == 'b'
  end

  def legal_moves(mode = "legal", pawn_call = false)
    @legal_moves = [] if mode == "legal"
    x = @x
    y = @y
    x1 = @x + 1
    y1 = @y + 1
    x2 = @x - 1
    y2 = @y - 1
    lines = [[x,y1],[x,y2],[x1,y1],[x1,y2],[x1,y],[x2,y1],[x2,y2],[x2,y]]
    lines.each do |ord|
      x = ord[0]
      y = ord[1]
      if CONDITION.call(x) && CONDITION.call(y)
        get_moves(mode, x, y)
      end
    end
    return @legal_moves if pawn_call == true
    remove_checked_pos if pawn_call == false
  end

  def remove_checked_pos
    combined = []
    @@board.each do |row|
      row.each do |piece|
        next if piece.class == King
        if piece.class == Pawn && piece.color != @color
          combined << piece.check_move
        elsif piece != " " && piece.class != Pawn
          capture = (piece.legal_moves + piece.check_move) if piece.color != @color
          unless capture.nil? || capture.empty?
            combined << capture
          end
        end
      end
    end
    @legal_moves -= combined.flatten(1)
  end
end