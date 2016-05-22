require_relative 'tile'
require 'byebug'

class Board
  attr_reader :grid_size
  DIRECTIONS = [[0,1],[0,-1],[-1,0],[1,0],[-1,-1],[-1,1],[1,-1],[1,1]]

  def initialize(grid_size, num_bombs)
    @grid_size = grid_size
    @num_bombs = num_bombs
    @grid = Array.new(grid_size) { Array.new(grid_size) }
  end

  def plant_bombs
    @grid.each_index do |row_idx|
      @grid[row_idx].each_with_index do |tile, col_idx|
        @grid[row_idx][col_idx] = Tile.new(false)
      end
    end

    @num_bombs.times do
      plant_random_bomb
    end
  end

  def plant_random_bomb
    while true
      row, col = generate_random_coord
      tile = @grid[row][col]
      break if !tile.bomb
    end

    tile.plant_bomb
    neighs = neighbors([row, col])
    neighs.each do |neighbor|
      self[neighbor].increase_bomb_cnt
    end
  end

  def neighbors(pos)
    a, b = pos
    neighbors_pos = []
    DIRECTIONS.each do |(x, y)|
      new_pos = [a + x, b + y]
      neighbors_pos << new_pos if new_pos.all? { |coord| coord.between?(0, 8)}
    end
    neighbors_pos
  end

  def generate_random_coord
    row = rand(9)
    col = rand(9)
    [row, col]
  end

  def [](pos)
    row, col = pos
    @grid[row][col]
  end

  def []=(pos, value)
    row, col = pos
    @grid[row][col] = value
  end

  def reveal(tile, pos)
    tile.reveal(board, pos)
  end

  def flag(tile)
    tile.flag
  end

  def render
    display_board = Array.new(@grid_size) {Array.new(@grid_size)}
    @grid.each_index do |i|
      @grid[i].each_index do |j|
        tile = @grid[i][j]
        display_board[i][j] = tile.to_s
      end
    end
    display(display_board)
  end

  def display(display_board)
    puts "  " + "0 1 2 3 4 5 6 7 8"
    display_board.each_with_index do |row, i|
      puts "#{i} " + row.join(" ")
    end
  end

  def won?
    @grid.flatten.all? { |tile| tile.revealed || tile.bomb }
  end

  def lost?
    @grid.flatten.any? { |tile| tile.revealed && tile.bomb }
  end
end
