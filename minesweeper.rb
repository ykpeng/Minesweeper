require_relative "board"
require_relative "tile"

class Minesweeper
  LAYOUTS = {
    :small => { :grid_size => 9, :num_bombs => 10 },
    :medium => { :grid_size => 16, :num_bombs => 40 },
    :large => { :grid_size => 32, :num_bombs => 160 } # whoa.
  }

  def initialize(size)
    layout = LAYOUTS[size]
    @board = Board.new(layout[:grid_size], layout[:num_bombs])
  end

  def setup
    @board.plant_bombs
  end

  def play
    puts "Welcome to Minesweeper!"
    setup
    until over?
      # system("clear")
      @board.render
      play_turn
    end
    @board.render
    if @board.lost?
      puts "BOMB! Game over."
    end
    if @board.won?
      puts "You win!"
    end
  end

  def play_turn
    pos = get_pos
    action = get_action
    if action == "r"
      @board[pos].reveal(@board, pos)
    else
      @board[pos].flag
    end
    pos
  end

  def over?
    @board.won? || @board.lost?
  end

  def get_pos
    puts "Choose a position and an action:"
    begin
      puts "Enter a set of coordinates as x, y"
      parse_pos(gets.chomp)
    rescue
      puts "Invalid coordinates. Please try again."
      retry
    end
  end

  def get_action
    begin
      puts "Enter an action to perform on this position: r for reveal, f for flag"
      parse_action(gets.chomp)
    rescue
      puts "Invalid action. Please try again."
      retry
    end
  end

  def parse_pos(coords_str)
    pos = coords_str.split(",").map  { |char| char.to_i }
    raise unless pos.length == 2
    raise unless pos.all? { |coord| coord.between?(0, @board.grid_size - 1)}
    pos
  end

  def parse_action(action_str)
    raise if action_str != "r" && action_str != "f"
    action_str
  end
end

if __FILE__ == $PROGRAM_NAME
  Minesweeper.new(:small).play
end
