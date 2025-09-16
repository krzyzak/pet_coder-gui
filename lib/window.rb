class Window < Gosu::Window
  SIZE = {
    width: 1600,
    height: 1200
  }
  CELL_SIZE = 100
  GAME_CODE_RATIO = 0.75  # 75% game area, 25% code area

  attr_reader :game

  def initialize
    super(*SIZE.values)
    self.caption = "Pet coder"
    @game = Game.new
    @editor = Editor.new
    @parser = Parser.new
    @executor = Executor.new(game: game, parser: parser)

    @font = Gosu::Font.new(30)
    @button_font = Gosu::Font.new(24)
    @score_font = Gosu::Font.new(28)

    @animation_timer = 0
  end

  def update
    if executor.running? && Gosu.milliseconds - @animation_timer > 500
      if executor.call
        game.consume_treat(game.player.treat)

        @animation_timer = Gosu.milliseconds
      else
        end_execution
      end
    end
  end

  def end_execution
    executor.clear!

    if game.scored?
      editor.clear!
      game.level_up!
    else
      @game.restart_level!
    end
  end

  def draw
    draw_game_area
    draw_code_area
    draw_sprites
    draw_button
    draw_score
    draw_directions
  end

  def draw_game_area
    # Calculate game area dimensions (75% of window width)
    game_width = SIZE[:width] * GAME_CODE_RATIO
    game_height = SIZE[:height]

    # Draw background image scaled to fit the game area
    Media::BACKGROUND.draw(0, 0, 0, game_width.to_f / Media::BACKGROUND.width, game_height.to_f / Media::BACKGROUND.height)
    draw_grid
  end

  def draw_grid
    # Calculate grid area within the game area
    game_width = SIZE[:width] * GAME_CODE_RATIO
    game_height = SIZE[:height]

    # Center the grid within the game area
    grid_size_pixels = game.grid_size * CELL_SIZE
    grid_start_x = (game_width - grid_size_pixels) / 2
    grid_start_y = (game_height - grid_size_pixels) / 2

    (0..game.grid_size).each do |i|
      x = i * CELL_SIZE + grid_start_x
      Gosu.draw_rect(x, grid_start_y, 1, grid_size_pixels, Gosu::Color::BLACK)

      y = i * CELL_SIZE + grid_start_y
      Gosu.draw_rect(grid_start_x, y, grid_size_pixels, 1, Gosu::Color::BLACK)
    end
  end

  def draw_code_area
    # Calculate code area dimensions (25% of window width)
    code_area_x = SIZE[:width] * GAME_CODE_RATIO
    code_area_width = SIZE[:width] * (1 - GAME_CODE_RATIO)
    code_area_height = SIZE[:height]

    Gosu.draw_rect(code_area_x, 0, code_area_width, code_area_height, Gosu::Color::GRAY)
    Gosu.draw_rect(code_area_x + 2, 2, code_area_width - 4, code_area_height - 54, Gosu::Color::WHITE)

    # Position text relative to code area
    text_x = code_area_x + 10

    @font.draw_text("Ruby Code Editor:", text_x, 10, 1, 1, 1, Gosu::Color::BLACK)
    @font.draw_text("Examples: left, right, up, down", text_x, 30, 1, 1, 1, Gosu::Color::BLACK)
    @font.draw_text("5.times { right }, 3.times { up }", text_x, 50, 1, 1, 1, Gosu::Color::BLACK)

    editor.lines.each.with_index do |line, index|
      @font.draw_text(line, text_x, 90 + index * 25, 1, 1, 1, Gosu::Color::BLACK)
    end
  end

  def draw_button
    # Position buttons at bottom of code area
    code_area_x = SIZE[:width] * GAME_CODE_RATIO
    button_y = SIZE[:height] - 60
    button_width = 120
    button_height = 50

    run_button_x = code_area_x + 20
    Gosu.draw_rect(run_button_x, button_y, button_width, button_height, Gosu::Color::BLUE)
    @button_font.draw_text("RUN", run_button_x + 40, button_y + 12, 1, 1, 1, Gosu::Color::WHITE)

    clear_button_x = run_button_x + button_width + 20
    Gosu.draw_rect(clear_button_x, button_y, button_width, button_height, Gosu::Color::RED)
    @font.draw_text("CLEAR", clear_button_x + 30, button_y + 15, 1, 1, 1, Gosu::Color::WHITE)
  end

  def button_down(id)
    case id
    when Gosu::KB_BACKSPACE
      editor.backspace
    when Gosu::KB_RETURN
      editor.append("\n")
    when Gosu::MS_LEFT
      if mouse_over_run_button? && game.lives > 0
        run_code
      elsif mouse_over_clear_button?
        clear_code
      end
    else
      editor.append_char(id, shift: Gosu.button_down?(Gosu::KB_RIGHT_SHIFT) || Gosu.button_down?(Gosu::KB_LEFT_SHIFT))
    end
  end

  def mouse_over_run_button?
    code_area_x = SIZE[:width] * GAME_CODE_RATIO
    button_y = SIZE[:height] - 60
    run_button_x = code_area_x + 20

    mouse_x >= run_button_x && mouse_x <= (run_button_x + 120) && mouse_y >= button_y && mouse_y <= (button_y + 50)
  end

  def mouse_over_clear_button?
    code_area_x = SIZE[:width] * GAME_CODE_RATIO
    button_y = SIZE[:height] - 60
    run_button_x = code_area_x + 20
    clear_button_x = run_button_x + 140

    mouse_x >= clear_button_x && mouse_x <= (clear_button_x + 120) && mouse_y >= button_y && mouse_y <= (button_y + 50)
  end

  def draw_score
    # Single line display: Points and hearts for lives
    score_text = "Points: #{game.points}  Lives: "
    text_width = @score_font.text_width(score_text)

    @score_font.draw_text(score_text, 10, 10, 1, 1, 1, Gosu::Color::WHITE)

    # Draw heart images for lives
    game.lives.times do |i|
      heart_x = 10 + text_width + (i * 35)
      Media::HEART.draw(heart_x, 10, 1, 30.0 / Media::HEART.width, 30.0 / Media::HEART.height)
    end
  end

  def draw_directions
    directions_text = "← left    ↑ up    ↓ down    → right"
    text_width = @font.text_width(directions_text)
    center_x = (SIZE[:width] - text_width) / 2

    @font.draw_text(directions_text, center_x, 5, 1, 1, 1, Gosu::Color::WHITE)
  end

  def clear_code
    editor.clear!
  end

  def run_code
    return if executor.running? || game.lives <= 0
    parser.parse(editor.text)
    executor.start!

    @animation_timer = Gosu.milliseconds
  end

  private

  attr_reader :game, :editor, :executor, :parser

  def grid_to_screen_coords(grid_x, grid_y)
    # Calculate grid area within the game area
    game_width = SIZE[:width] * GAME_CODE_RATIO
    game_height = SIZE[:height]

    # Center the grid within the game area
    grid_size_pixels = game.grid_size * CELL_SIZE
    grid_start_x = (game_width - grid_size_pixels) / 2
    grid_start_y = (game_height - grid_size_pixels) / 2

    x = grid_x * CELL_SIZE + grid_start_x
    y = grid_y * CELL_SIZE + grid_start_y

    [x, y]
  end

  def level_up!
    @level_index += 1
    @level = nil
  end

  def draw_sprites
    draw_walls
    draw_treats
    draw_player
    draw_target
  end

  def draw_player
    draw_item(items: [game.player], media: Media::PLAYER)
  end

  def draw_target
    draw_item(items: [game.target], media: Media::TARGET)
  end

  def draw_walls
    draw_item(items: game.level.walls, media: Media::WALL)
  end

  def draw_treats
    draw_item(items: game.treats.map(&:position), media: Media::TREAT)
  end

  def draw_item(items:, media:)
    items.each do |item|
      x, y = grid_to_screen_coords(item.x, item.y)

      media.draw(x + 2, y + 2, 1,
                       (CELL_SIZE - 4).to_f / media.width,
                       (CELL_SIZE - 4).to_f / media.height)
    end
  end
end
