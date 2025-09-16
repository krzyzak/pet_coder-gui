# frozen_string_literal: true

class Game
  GRID_SIZE = 10

  attr_reader :player_type, :target_type, :treat_type

  def initialize
    @level_index = 0
    @state = State.new(treats: level.treats)
    @executing_state = @state.clone!
    @executing = false
    switch_player!
    switch_target!
    switch_treat!
  end

  def start!
    @executing = true
  end

  def player
    @player ||= Player.new(position: level.player.dup, grid_size: GRID_SIZE, walls: level.walls, treats: level.treats, holes: holes)
  end

  def target
    level.target
  end

  def points
    current_state.points
  end

  def lives
    current_state.lives
  end

  def treats
    current_state.treats
  end

  def holes
    level.holes
  end

  def grid_size
    GRID_SIZE
  end

  def restart!
    raise NotImplementedError
  end

  def consume_treat(treat)
    return unless treat

    treats.delete_if { it == treat }
    current_state.points += treat.points
  end

  def restart_level!
    @state.lives -= 1
    @executing_state = @state.clone
    @executing = false
    @player = nil
  end

  def level_up!
    @level_index += 1
    @level = nil
    @player = nil
    @executing_state.points += 100
    @executing_state.treats = level.treats
    @state = @executing_state
    @executing_state = @state.clone
    @executing = false
  end

  def scored?
    player.position == target
  end

  def level
    @level ||= Level.fetch(@level_index)
  end

  def switch_player!
    @player_type = Media.players.next
  end

  def switch_target!
    @target_type = Media.targets.next
  end

  def switch_treat!
    @treat_type = Media.treats.next
  end

  private

  def current_state
    @executing ? @executing_state : @state
  end
end
