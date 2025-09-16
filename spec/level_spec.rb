# frozen_string_literal: true

require "spec_helper"

RSpec.describe Level do
  describe "#initialize" do
    let(:player_pos) { Point.new(x: 2, y: 2) }
    let(:target_pos) { Point.new(x: 8, y: 8) }
    let(:walls) { [Point.new(x: 3, y: 3), Point.new(x: 4, y: 4)] }
    let(:treats) { [Treat.new(position: Point.new(x: 5, y: 5))] }
    let(:holes) { [Hole.new(position: Point.new(x: 6, y: 6))] }

    let(:level) do
      described_class.new(
        player: player_pos,
        target: target_pos,
        walls: walls,
        treats: treats,
        holes: holes,
        max_lines: 20,
      )
    end

    it "sets the player position" do
      expect(level.player).to eq(player_pos)
    end

    it "sets the target position" do
      expect(level.target).to eq(target_pos)
    end

    it "sets the walls" do
      expect(level.walls).to eq(walls)
    end

    it "sets the treats" do
      expect(level.treats).to eq(treats)
    end

    it "sets the holes" do
      expect(level.holes).to eq(holes)
    end

    context "with default parameters" do
      let(:simple_level) { described_class.new(player: player_pos, target: target_pos) }

      it "sets empty walls array by default" do
        expect(simple_level.walls).to eq([])
      end

      it "sets empty treats array by default" do
        expect(simple_level.treats).to eq([])
      end

      it "sets empty holes array by default" do
        expect(simple_level.holes).to eq([])
      end
    end
  end
end
