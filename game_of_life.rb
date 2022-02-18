# frozen_string_literal: true

# Game class
class Game
  def initialize(rows, cols)
    @grid = Grid.new(rows, cols)
    @dots_grid = DotsGrid.new(rows, cols)
    @generation = Generation.new
  end

  def loop
    @dots_grid.score(@grid)
    fresh = @generation.next(@grid, @dots_grid)
    @grid.set(fresh)
    puts "<3 Generation: #{@generation.num} <3"
    @grid.print_cells
    loop if gets.chomp.empty?
  end
end

# Dots_Grid class
class DotsGrid
  def initialize(rows, cols)
    @rows = rows
    @cols = cols
    @grid = []
    fill
  end

  attr_reader :grid

  def fill
    @rows.times do
      @grid.push(Array.new(@cols, 0))
    end
  end

  def print_dots_grid
    @grid.each do |row|
      puts row.join('')
    end
  end

  def score(grid)
    @rows.times do |r|
      @cols.times do |c|
        score_neighbors(r, c) if grid.alive?(r, c)
      end
    end
  end

  def score_neighbors(row, col)
    (row - 1..row + 1).each do |x|
      (col - 1..col + 1).each do |y|
        add_one(x, y) if inside?(x, y) && !((row == x) && (col == y))
      end
    end
  end

  def inside?(row, col)
    row >= 0 and row < @rows and col >= 0 and col < @cols
  end

  def add_one(row, col)
    @grid[row][col] += 1
  end

  def reset
    @grid = []
    fill
  end
end

# Grid class
class Grid
  def initialize(rows, cols)
    @rows = rows
    @cols = cols
    @grid = []
    fill
  end

  attr_reader :rows, :cols, :grid

  def fill
    @rows.times do
      row = []
      @cols.times do
        row.push(rand(2) == 1 ? '♥ ' : '♡ ')
      end
      @grid.push(row)
    end
  end

  def alive?(row, col)
    @grid[row][col] == '♥ '
  end

  def print_cells
    @grid.each do |row|
      puts row.join('')
    end
  end

  def set(fresh)
    @grid = fresh
  end
end

# Generation class
class Generation
  def initialize
    @num = 0
  end

  attr_reader :num

  def next(grid, dots_grid, new_grid = [])
    @num += 1
    grid.rows.times do |r|
      new_grid.push([])
      grid.cols.times do |c|
        neighbors = dots_grid.grid[r][c]
        new_grid[r][c] = (neighbors == 2 && grid.alive?(r, c)) || neighbors == 3 ? '♥ ' : '♡ '
      end
    end
    dots_grid.reset
    new_grid
  end
end

print 'ingresa el numero de ALTO del tablero: '
alto = gets.to_i
print 'ingresa el numero de ANCHO del tablero: '
ancho = gets.to_i

game = Game.new(alto, ancho)
puts '-- <3 Presione enter para ver la próxima generación'
puts '--Escriba cualquier otra tecla para salir <3 '
game.loop
