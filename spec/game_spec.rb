# frozen_string_literal: true

require "spec_helper"

RSpec.describe Game do
  let(:game) { described_class.new }

  describe "#initialize" do
    it "starts at level 0" do
      expect(game.instance_variable_get(:@level_index)).to eq(0)
    end
  end

  describe "#player" do
    it "returns a Player instance" do
      expect(game.player).to be_a(Player)
    end

    it "player has correct initial position" do
      expect(game.player.position).to eq(game.level.player)
    end

    it "player has correct grid size" do
      expect(game.player.grid_size).to eq(Game::GRID_SIZE)
    end
  end

  describe "#target" do
    it "returns the level target" do
      expect(game.target).to eq(game.level.target)
    end
  end

  describe "#points" do
    it "returns current state points" do
      expect(game.points).to eq(0)
    end

    context "when executing" do
      before { game.start! }

      it "returns executing state points" do
        expect(game.points).to eq(0)
      end
    end
  end

  describe "#consume_treat" do
    let(:treat) { Treat.new(position: Point.new(x: 9, y: 9), points: 15) }

    before do
      game.treats << treat
    end

    context "with valid treat" do
      it "removes treat from treats array" do
        expect { game.consume_treat(treat) }.to change { game.treats.include?(treat) }.from(true).to(false)
      end

      it "increases points by treat points" do
        initial_points = game.points
        game.consume_treat(treat)
        expect(game.points).to eq(initial_points + treat.points)
      end
    end

    context "with nil treat" do
      it "does nothing" do
        initial_treats_count = game.treats.count
        initial_points = game.points

        game.consume_treat(nil)

        expect(game.treats.count).to eq(initial_treats_count)
        expect(game.points).to eq(initial_points)
      end
    end
  end

  describe "#level_up!" do
    before do
      game.start!
      game.instance_variable_get(:@executing_state).points = 100
    end

    it "increases level index" do
      expect { game.level_up! }.to change { game.instance_variable_get(:@level_index) }.by(1)
    end

    it "resets level cache" do
      original_level = game.level
      game.level_up!
      new_level = game.level

      expect(new_level).not_to be(original_level)
    end

    it "resets player" do
      original_player = game.player
      game.level_up!
      new_player = game.player

      expect(new_player).not_to be(original_player)
    end

    it "updates state from executing state" do
      game.level_up!
      state = game.instance_variable_get(:@state)

      expect(state.points).to eq(100)
    end

    it "sets executing to false" do
      game.level_up!
      expect(game.instance_variable_get(:@executing)).to be false
    end
  end

  describe "#scored?" do
    context "when player is at target position" do
      before do
        game.player.position.x = game.target.x
        game.player.position.y = game.target.y
      end

      it "returns true" do
        expect(game.scored?).to be true
      end
    end

    context "when player is not at target position" do
      before do
        game.player.position.x = game.target.x + 1
        game.player.position.y = game.target.y + 1
      end

      it "returns false" do
        expect(game.scored?).to be false
      end
    end
  end
end
