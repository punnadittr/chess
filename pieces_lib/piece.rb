class Pieces < Board
  
  CONDITION = lambda { |pos| pos.between?(0, 7) }
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

  def get_legal_moves(x, y)
    if @@board[y][x] == " "
      @legal_moves << [x,y]
      return false
    else
      return true
    end
  end

  def get_capture_moves(x, y)
    if @@board[y][x] != " " && @@board[y][x].color != self.color
      @capture_moves << [x,y]
      return true
    else
      return false
    end
  end

  def get_check_move(x, y)

  end

  def capture_moves
    @capture_moves = []
    legal_moves("capture")
    @capture_moves
  end

  def convert_move(position)
    return "INVALID MOVE(CV)" if position.length > 2
    input_codes = {'a'=>0,'b'=>1,'c'=>2,'d'=>3,'e'=>4,'f'=>5,'g'=>6,'h'=>7}
    x = position[0]
    y = (position[1].to_i) - 1
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