class Pawn < Pieces
  attr_reader :two_steps

  def initialize(x,y, color = "w")
    @color = color
    @x = x
    @y = y
    @position = [x,y]
    @two_steps = false
    @first_move = true
    @possible_moves = []
    @en_passant = []
  end

  # Promote the pawn when reaching top (white) or bottom (black)
  def promote(color)
    color = @color
    puts "Please choose a new piece to replace (Q,B,R,N)"
    piece = gets.chomp
    @@board[@y][@x] = Queen.new(@x, @y, color) if piece == "Q"
    @@board[@y][@x] = Bishop.new(@x, @y, color) if piece == "B"
    @@board[@y][@x] = Rook.new(@x, @y, color) if piece == "R"
    @@board[@y][@x] = Knight.new(@x, @y, color) if piece == "N"
    @selected = @@board[@y][@x]
  end

  def display
    return "\u2659" if @color == "w"
    return "\u265F" if @color == "b"
  end

  # Mocking moves for determining king's legal moves
  def possible_capture_moves
    check_move = []
    x = @x - 1
    y = @y + 1 if @color == "w"
    y = @y - 1 if @color == "b"
    2.times do
      if CONDITION.call(x,y)
        check_move << [x,y]
        x += 2
      end
    end
    check_move
  end

  # Combine all possible moves of a pawn piece
  def possible_moves
    @possible_moves = []
    @possible_moves = @legal_moves + @capture_moves + en_passant?
  end

  # Regular move (going forward one or two squares)
  def legal_moves
    @legal_moves = []
    # Different Y coordinates for black and white pieces (moving up and down)
    if self.color == "w"
      y = @y + 1
      y2 = @y + 2
    elsif self.color == "b"
      y = @y - 1
      y2 = @y - 2
    end
    # The move is available if the space is empty
    if @@board[y][@x] == " "
      @legal_moves << [@x, y]
    end
    # For first move of a pawn, 2 moves forward is allowed
    if @first_move && @@board[y2][@x] == " " && @@board[y][@x] == " "
      @legal_moves << [@x, y2] 
    end
    @legal_moves
  end

  # Special capture move when an enemy pawn moves two steps forward
  def en_passant?
    @en_passant = []
    x = @x + 1
    y = @y + 1 if self.color == "w"
    y = @y - 1 if self.color == "b"
    side_space = @@board[@y][x]
    2.times do
      if side_space.class == Pawn && side_space.two_steps && side_space.color != self.color
        @en_passant << [x,y]
      end
      x -= 2
      side_space = @@board[@y][x]
    end
    @en_passant
  end

  # Regular capture moves for pawns (diagonal capture)
  def capture_moves
    @capture_moves = []
    x = @x - 1
    y = @y + 1 if self.color == "w"
    y = @y - 1 if self.color == "b"
    2.times do
      if @@board[y][x] != nil && @@board[y][x] != " " && @@board[y][x].color != self.color
        @capture_moves << [x, y]
      end
      x += 2
    end
    @capture_moves
  end

  # Removing enemy piece via en_passant move
  def en_passant_removal
    en_moves = @en_passant.flatten
    current_x = @x
    current_y = @y
    destination_x = en_moves[0]
    destination_y = en_moves[1] - 1 if self.color == "w"
    destination_y = en_moves[1] + 1 if self.color == "b"
    2.times do
      if destination_x - 1 == @x && destination_y == @y
        @@board[current_y][current_x + 1] = " "
        puts "Removed #{current_x+1}, #{current_y} from the board"
      end
      destination_x += 2
      current_x -= 2
    end
  end

  # Used in combination with en_passant to determine if current pawn moves two steps
  def two_steps?(y)
    if @y - y == 2 || y - @y == 2
      @two_steps = true
    else
      @two_steps = false
    end
  end

  # Move the piece to the selected position, 
  # can be legal moves, capture moves or en passant moves
  def move(position)
    x, y = convert_move(position)
    current_y = @y
    if @possible_moves.include? [x, y]
      @@board[@y][@x] = " "
      if @en_passant.include? [x, y]
        en_passant_removal
      end
      @@board[y][x] = self
      @x = x
      @y = y
      @position = [@x, @y]
      two_steps?(current_y)
      @first_move = false
      @@selected = nil
      print_board
      promote("w") if @color == "w" && y == 7
      promote("b") if @color == "b" && y == 0
      true
    else
      false
    end
  end
end