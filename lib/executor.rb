class Executor
  def initialize(game:, parser:)
    @game = game
    @parser = parser
    @index = 0
    @running = false
  end

  def call
    return clear! if execution_finished?


    case command
    when :left
      game.player.move_left
    when :right
      game.player.move_right
    when :up
      game.player.move_up
    when :down
      game.player.move_down
    end
    @index += 1

    true
  end

  def start!
    @running = true
  end

  def running?
    !!@running
  end

  def clear!
    @index = 0
    @running = false
    @parser.clear!

    false
  end

  private

  def commands
    parser.commands
  end

  def command
    commands[index]
  end

  def execution_finished?
    commands.length <= index
  end

  attr_reader :game, :parser, :index
end
