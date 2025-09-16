class Treat
  attr_reader :position, :points

  def initialize(position:, points: 10)
    @position = position
    @points = points
  end
end
