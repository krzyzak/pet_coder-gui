class Game
  GRID_SIZE = 10

  def initialize
    @level_index = 0
  end

  def player
    @player ||= Player.new(position: level.player.dup, grid_size: GRID_SIZE, walls: level.walls, treats: level.treats)
  end

  def target
    level.target
  end

  def grid_size
    GRID_SIZE
  end

  def restart!
    raise NotImplementedError
  end

  def restart_level!
    @player = nil
  end

  def level_up!
    @level_index += 1
    @level = nil
    @player = nil
  end

  def scored?
    player.position == target
  end

  def level
    @level ||= Level.fetch(@level_index)
  end

  private
end
