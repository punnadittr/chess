class Pieces < Board
  
  CONDITION = lambda { |pos| pos >= 0 && pos <= 7 }
  attr_reader :color, :capture_moves, :x, :y, :possible_moves, :position
  attr_accessor :legal_moves, :check_move

  def initialize(x,y, color = 'w')
    @color = color
    @x = x
    @y = y
    @position = [x,y]
    @possible_moves = []
    @legal_moves = []
    @capture_moves = []
    @check_move = []
    @check_step = false
  end

  def get_moves(mode, x, y)
    if mode == "legal"
      if @@board[y][x] == " "
        if @check_step == false
          @legal_moves << [x,y] 
          return false
        elsif @check_step == true
          @check_move << [x,y]
          @check_step = false
          return true
        end
      elsif @@board[y][x].class == King
        @check_step = true
        return false
      end
      return true
    elsif mode == "capture"
      if @@board[y][x] != " "
        # Add the position to capture move if color is different
        if @@board[y][x].color != self.color
          @capture_moves << [x,y]
          return true
        # If the position has the piece with same color
        else
          return true
        end
      end
      return false
    end
  end

  def capture_moves
    @capture_moves = []
    legal_moves("capture")
    @capture_moves
  end

  def convert_move(position)
    return "INVALID MOVE(CV)" if position.length > 2
    x = position[0]
    y = (position[1].to_i) - 1
    input_codes = {'a'=>0,'b'=>1,'c'=>2,'d'=>3,'e'=>4,'f'=>5,'g'=>6,'h'=>7}
    if input_codes.include? x
      return input_codes[x], y
    else
      "INVALID MOVE(CV)"
    end
  end

  def move(position)
    x, y = convert_move(position)
    @possible_moves = @legal_moves + @capture_moves
    if @possible_moves.include? [x,y]
      @@board[@y][@x] = " "
      @@board[y][x] = self
      @x = x
      @y = y
      @position = [x,y]
      @possible_moves = []
      print_board
    else
      return "INVALID MOVE(MV)"
    end
  end
end