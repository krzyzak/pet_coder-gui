# frozen_string_literal: true

require "spec_helper"

RSpec.describe GameObject do
  let(:position) { Point.new(x: 5, y: 5) }
  let(:grid_size) { 10 }
  let(:walls) { [Point.new(x: 3, y: 5), Point.new(x: 7, y: 5)] }
  let(:treats) { [Treat.new(position: Point.new(x: 5, y: 4))] }
  let(:holes) { [Hole.new(position: Point.new(x: 5, y: 6))] }

  let(:game_object) do
    described_class.new(
      position: position,
      grid_size: grid_size,
      walls: walls,
      treats: treats,
      holes: holes,
    )
  end

  describe "#initialize" do
    it "sets the position" do
      expect(game_object.position).to eq(position)
    end

    it "sets the grid size" do
      expect(game_object.grid_size).to eq(grid_size)
    end

    it "sets the treats" do
      expect(game_object.treats).to eq(treats)
    end

    it "sets the holes" do
      expect(game_object.holes).to eq(holes)
    end

    context "with default walls, treats, and holes" do
      let(:simple_object) { described_class.new(position: position, grid_size: grid_size) }

      it "initializes with empty arrays" do
        expect(simple_object.treats).to eq([])
        expect(simple_object.holes).to eq([])
      end
    end
  end

  describe "movement methods" do
    describe "#move_up" do
      context "when movement is valid" do
        it "decreases y coordinate" do
          expect { game_object.move_up }.to change { game_object.position.y }.from(5).to(4)
        end
      end

      context "when at top boundary" do
        let(:position) { Point.new(x: 5, y: 0) }

        it "does not move beyond grid boundary" do
          expect { game_object.move_up }.not_to change { game_object.position.y }
        end
      end

      context "when blocked by wall" do
        let(:walls) { [Point.new(x: 5, y: 4)] }

        it "does not move into wall" do
          expect { game_object.move_up }.not_to change { game_object.position.y }
        end
      end
    end

    describe "#move_down" do
      context "when movement is valid" do
        it "increases y coordinate" do
          expect { game_object.move_down }.to change { game_object.position.y }.from(5).to(6)
        end
      end

      context "when at bottom boundary" do
        let(:position) { Point.new(x: 5, y: 9) }

        it "does not move beyond grid boundary" do
          expect { game_object.move_down }.not_to change { game_object.position.y }
        end
      end

      context "when blocked by wall" do
        let(:walls) { [Point.new(x: 5, y: 6)] }

        it "does not move into wall" do
          expect { game_object.move_down }.not_to change { game_object.position.y }
        end
      end
    end

    describe "#move_left" do
      context "when movement is valid" do
        it "decreases x coordinate" do
          expect { game_object.move_left }.to change { game_object.position.x }.from(5).to(4)
        end
      end

      context "when at left boundary" do
        let(:position) { Point.new(x: 0, y: 5) }

        it "does not move beyond grid boundary" do
          expect { game_object.move_left }.not_to change { game_object.position.x }
        end
      end

      context "when blocked by wall" do
        let(:walls) { [Point.new(x: 4, y: 5)] }

        it "does not move into wall" do
          expect { game_object.move_left }.not_to change { game_object.position.x }
        end
      end
    end

    describe "#move_right" do
      context "when movement is valid" do
        it "increases x coordinate" do
          expect { game_object.move_right }.to change { game_object.position.x }.from(5).to(6)
        end
      end

      context "when at right boundary" do
        let(:position) { Point.new(x: 9, y: 5) }

        it "does not move beyond grid boundary" do
          expect { game_object.move_right }.not_to change { game_object.position.x }
        end
      end

      context "when blocked by wall" do
        let(:walls) { [Point.new(x: 6, y: 5)] }

        it "does not move into wall" do
          expect { game_object.move_right }.not_to change { game_object.position.x }
        end
      end
    end
  end

  describe "position accessors" do
    describe "#x" do
      it "returns the x coordinate" do
        expect(game_object.x).to eq(5)
      end
    end

    describe "#y" do
      it "returns the y coordinate" do
        expect(game_object.y).to eq(5)
      end
    end
  end

  describe "#treat" do
    context "when there is a treat at current position" do
      let(:treat_at_position) { Treat.new(position: Point.new(x: 5, y: 5)) }
      let(:treats) { [treat_at_position, Treat.new(position: Point.new(x: 3, y: 3))] }

      it "returns the treat at current position" do
        expect(game_object.treat).to eq(treat_at_position)
      end
    end

    context "when there is no treat at current position" do
      let(:treats) { [Treat.new(position: Point.new(x: 3, y: 3))] }

      it "returns nil" do
        expect(game_object.treat).to be_nil
      end
    end
  end

  describe "#on_hole?" do
    context "when there is a hole at current position" do
      let(:holes) { [Hole.new(position: Point.new(x: 5, y: 5))] }

      it "returns true" do
        expect(game_object.on_hole?).to be true
      end
    end

    context "when there is no hole at current position" do
      let(:holes) { [Hole.new(position: Point.new(x: 3, y: 3))] }

      it "returns false" do
        expect(game_object.on_hole?).to be false
      end
    end

    context "when there are no holes" do
      let(:holes) { [] }

      it "returns false" do
        expect(game_object.on_hole?).to be false
      end
    end
  end
end
