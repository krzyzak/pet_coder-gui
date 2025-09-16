# frozen_string_literal: true

class State
  attr_accessor :points, :lives, :treats

  def initialize(points: 0, lives: 3, treats: [])
    @points = points
    @lives = lives
    @treats = treats
  end

  def clone!
    State.new(points: points, lives: lives, treats: treats.dup)
  end
end
