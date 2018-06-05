class Pieces < Board
  
  CONDITION = lambda { |x,y| x.between?(0,7) && y.between?(0,7) }
  attr_reader :color, :x, :y, :position
  attr_accessor :check_move

  def initialize(x,y, color = 'w')
    @color = color
    @x = x
    @y = y
    @position = [x,y]
    @possible_moves = []
    @legal_moves = []
    @capture_moves = []
    @check_move = []
  end

  def show_legal_moves
    @legal_moves
  end

  def show_capture_moves
    @capture_moves
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
    if @@board[y][x] != " "
      if @@board[y][x].color != self.color
        @capture_moves << [x,y]
        return true
      else
        return true
      end
    else
      return false
    end
  end

  def possible_moves
    @possible_moves = []
    @possible_moves = legal_moves + capture_moves
  end

  def legal_moves
    @legal_moves = []
    get_all_moves("legal")
    @legal_moves
  end

  def capture_moves
    @capture_moves = []
    get_all_moves("capture")
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
    possible_moves
    x, y = convert_move(position)
    if @possible_moves.include? [x,y]
      @@board[@y][@x] = " "
      @@board[y][x] = self
      @x = x
      @y = y
      @position = [x,y]
      @possible_moves = []
      @@selected = nil
      print_board
    else
      return "INVALID MOVE(MV)"
    end
  end
end