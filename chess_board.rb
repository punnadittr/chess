require "colorize"
# create a chessboard and function to assign item to the board
class Board

  def put_piece

  end

  def create_board
    board = [
      ["\u2656","\u2658","\u2657","\u2655","\u265A","\u2657","\u2658","\u2656"],
      ["\u2659","\u2659","\u2659","\u2659","\u2659","\u2659","\u2659","\u2659"],
      [' ',' ',' ',' ',' ',' ',' ',' '],
      [' ',' ',' ',' ',' ',' ',' ',' '],
      [' ',' ',' ',' ',' ',' ',' ',' '],
      [' ',' ',' ',' ',' ',' ',' ',' '],
      ["\u2659","\u2659","\u2659","\u2659","\u2659","\u2659","\u2659","\u2659"],
      ["\u2656","\u2658","\u2657","\u2655","\u265A","\u2657","\u2658","\u2656"]
    ]
  end

  def print_board
    board.each_with_index do |row, i|
      row.each_with_index do |piece, index|
        if i.even?
          if index.even?
            colorme(piece, :black, :cyan)
          else
            colorme(piece, :black, :white)
          end
        else
          if index.even?
            colorme(piece, :black, :white)
          else
            colorme(piece, :black, :cyan)
          end
        end
      end
      puts
    end
  end

  def colorme(object, main_color, bg_color)
    print 
    print (' ' + object + ' ').colorize(:color => main_color, :background => bg_color )
  end

end






