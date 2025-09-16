# frozen_string_literal: true

class Hole
  attr_reader :position

  def initialize(position:)
    @position = position
  end
end
