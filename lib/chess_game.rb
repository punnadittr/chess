# defines game logic / determines game over / get user_input

class Game

  def select(position)
    split_input = position.chars
    x = split_input[0]
    y = (split_input[1].to_i) - 1
    input_codes = {'a'=>0,'b'=>1,'c'=>2,'d'=>3,'e'=>4,'f'=>5,'g'=>6,'h'=>7}
    if input_codes.include? x
      @@selected = @@board[y][x]
      if @@selected == ' '
        return "Invalid Selection"
      else
        return "Selected #{position}"
      end
    end
  end

  def start_game

  end

  def game_over

  end

  def translate_input

  end
end