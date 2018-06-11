class Pieces < Game
  # Condition used for determining legal moves and capture moves
  CONDITION = lambda { |x,y| x.between?(0,7) && y.between?(0,7) }

  attr_reader :color
  attr_accessor :check_move, :x, :y, :position, :moved

  def initialize(x,y, color = 'w')
    @color = color
    @x = x
    @y = y
    @position = [x,y]
    @possible_moves = []
    @legal_moves = []
    @capture_moves = []
    @check_move = []
    @king_step = false
    @moved = false
  end

  def show_legal_moves
    @legal_moves
  end

  def assign_legal_moves=(moves)
    @legal_moves = moves
  end

  def assign_capture_moves=(moves)
    @capture_moves = moves
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
    if @king_step == true
      @check_move << [x,y]
      @king_step = false
      return true
    elsif @@board[y][x] != " "
      if @@board[y][x].color != self.color
        if @@board[y][x].class == King
          @capture_moves << [x,y]
          @king_step = true
          return false
        else
          @capture_moves << [x,y]
          return true
        end
      else
        return true
      end
    else
      return false
    end
  end

  def possible_moves
    @possible_moves = []
    @possible_moves = @legal_moves + @capture_moves
  end

  def legal_moves
    @legal_moves = []
    get_all_moves("legal")
    @legal_moves
  end

  def capture_moves
    @check_move = []
    @capture_moves = []
    get_all_moves("capture")
    @capture_moves
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
      @moved = true
      print_board
      return true
    else
      return false
    end
  end
end