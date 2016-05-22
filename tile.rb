class Tile
  attr_reader :bomb, :revealed
  attr_accessor :flagged, :surrounding_bombs
  def initialize(bomb)
    @bomb = bomb
    @flagged = false
    @revealed = false
    @surrounding_bombs = 0
  end

  def to_s
    if @revealed
      if @bomb
        "B"
      elsif @surrounding_bombs > 0
        "#{surrounding_bombs}"
      else
        "_"
      end
    else
      if @flagged
        "F"
      else
        "*"
      end
    end
  end

  def plant_bomb
    @bomb = true
  end

  def increase_bomb_cnt
    @surrounding_bombs += 1
  end

  def reveal(board, pos)
    return self if @flagged
    return self if @revealed
    @revealed = true
    if !@bomb && @surrounding_bombs == 0
      board.neighbors(pos).each do |neighbor_pos|
        board[neighbor_pos].reveal(board, neighbor_pos)
      end
    end

    self
  end

  def flag
    @flagged = !@flagged unless @revealed
  end
end
