# frozen_string_literal: true

class Media
  WALL = Gosu::Image.new("media/wall.png")
  BACKGROUND = Gosu::Image.new("media/background.png")
  HEART = Gosu::Image.new("media/heart.png")
  HOLE = Gosu::Image.new("media/hole.png")

  PLAYERS = {
    dog: Gosu::Image.new("media/players/dog.png"),
    turtle: Gosu::Image.new("media/players/turtle.png"),
    cat: Gosu::Image.new("media/players/cat.png"),
  }.freeze

  TARGETS = {
    dog_ice_cream: Gosu::Image.new("media/targets/dog_ice_cream.png"),
    cat_bowl: Gosu::Image.new("media/targets/cat_bowl.png"),
    apple: Gosu::Image.new("media/targets/apple.png"),
  }.freeze

  TREATS = {
    bone: Gosu::Image.new("media/treats/bone.png"),
    salad: Gosu::Image.new("media/treats/salad.png"),
    fish: Gosu::Image.new("media/treats/fish.png"),
  }.freeze

  def self.players
    @players ||= PLAYERS.keys.cycle
  end

  def self.targets
    @targets ||= TARGETS.keys.cycle
  end

  def self.treats
    @treats ||= TREATS.keys.cycle
  end
end
