class Sudoku

  def initialize(problem=nil)
    @problem = problem
  end

  def []=(x, y, i)
    @problem[y][x] = i
  end

  def clone
    Sudoku.new Marshal.load(Marshal.dump(@problem))
  end

  def import_problem(file_name)
    @problem = File.open(file_name).readlines.map do |row|
      row.chomp.split('').map { |cell| cell.to_i }
    end
  end

  def print_problem
    puts @problem.map { |row| row.join ' ' }
  end

  def solve!
    x, y = unknown = next_unknown
    return self unless unknown
    successors(x, y).each do |i|
      successor = clone
      successor[x, y] = i
      solution = successor.solve!
      return solution if solution
    end
    false
  end

  private

  def next_unknown
    @problem.each_with_index do |row, y|
      row.each_with_index do |cell, x|
        return [x, y] if cell == 0
      end
    end
    nil
  end

  def successors(x, y)
    possible_values - col_members(x) - row_members(y) - group_members(x, y)
  end

  def possible_values
    (1..problem_size).to_a
  end

  def col_members(x)
    @problem.map { |row| row[x] }
  end

  def row_members(y)
    @problem[y]
  end

  def group_members(x, y)
    @problem[group_range(y)].map { |row| row[group_range(x)] }.flatten
  end

  def group_range(n)
    low  = n / group_size * group_size
    high = low + group_size - 1
    low..high
  end

  def group_size
    @group_size ||= Math.sqrt(problem_size).floor
  end

  def problem_size
    @problem.size
  end

end
