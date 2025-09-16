class GameObject

  attr_reader :position, :grid_size, :treats

  def initialize(position:, grid_size:, walls: [], treats: [])
    @position = position
    @grid_size = grid_size
    @walls = walls
    @treats = treats
  end

  def move_up
    new_y = position.y - 1
    if new_y >= 0 && !wall_at?(position.x, new_y)
      position.y = new_y
    end
  end

  def move_down
    new_y = position.y + 1
    if new_y < grid_size && !wall_at?(position.x, new_y)
      position.y = new_y
    end
  end

  def move_left
    new_x = position.x - 1
    if new_x >= 0 && !wall_at?(new_x, position.y)
      position.x = new_x
    end
  end

  def move_right
    new_x = position.x + 1
    if new_x < grid_size && !wall_at?(new_x, position.y)
      position.x = new_x
    end
  end

  def x
    position.x
  end

  def y
    position.y
  end

  def on_treat?
    treats.any? { |treat| treat == position }
  end

  private

  def wall_at?(x, y)
    @walls.any? { |wall| wall.x == x && wall.y == y }
  end
end
