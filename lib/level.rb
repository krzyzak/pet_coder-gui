LEVELS_DATA = [
  # Level 0 - just go up
  {
    player: Point.new(x: 1, y: 3),
    target: Point.new(x: 1, y: 1),
    treats: [
      Treat.new(position: Point.new(x: 1, y: 2))
    ]
  },
  # Level 1 - spiral
  {
    player: Point.new(x: 5, y: 5),
      walls: [
        Point.new(x: 4, y: 5),
        Point.new(x: 4, y: 6),
        Point.new(x: 5, y: 6),
        Point.new(x: 6, y: 6),

        Point.new(x: 6, y: 5),
        Point.new(x: 6, y: 4),
        Point.new(x: 6, y: 3),

        Point.new(x: 5, y: 3),
        Point.new(x: 4, y: 3),
        Point.new(x: 3, y: 3),
        Point.new(x: 2, y: 3),
        Point.new(x: 1, y: 3),

        Point.new(x: 1, y: 4),
        Point.new(x: 1, y: 5),
        Point.new(x: 1, y: 6),

        Point.new(x: 3, y: 5),


        Point.new(x: 1, y: 7),
        Point.new(x: 2, y: 7),
        Point.new(x: 3, y: 7),
        Point.new(x: 4, y: 7),
        Point.new(x: 5, y: 7),
        Point.new(x: 6, y: 7),
    ],
    target: Point.new(x: 3, y: 6),
  },

  # {
  #   turtle: Point.new(x: 1, y: 3),
  #   apple: Point.new(x: 6, y: 2),
  # },
  {
    player: Point.new(x: 0, y: 0),
    walls: [
      Point.new(x: 0, y: 9),
      Point.new(x: 9, y: 0),

      Point.new(x: 8, y: 8),
    ],
    target: Point.new(x: 9, y: 9)
  }
]

class Level
  def self.fetch(index)
    data = LEVELS_DATA[index]

    new(**data)
  end

  def initialize(player:, target:, walls: [], treats: [], holes: [], max_lines: -1)
    @player = player
    @target = target
    @walls = walls
    @treats = treats
    @holes = holes
    @max_lines = max_lines
  end

  attr_reader :player, :target, :walls, :treats, :holes
end
