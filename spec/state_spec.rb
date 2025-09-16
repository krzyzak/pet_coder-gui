# frozen_string_literal: true

require "spec_helper"

RSpec.describe State do
  describe "#initialize" do
    context "with default values" do
      let(:state) { described_class.new }

      it "sets default points to 0" do
        expect(state.points).to eq(0)
      end

      it "sets default lives to 3" do
        expect(state.lives).to eq(3)
      end

      it "sets default treats to empty array" do
        expect(state.treats).to eq([])
      end
    end

    context "with custom values" do
      let(:treats) { [Treat.new(position: Point.new(x: 1, y: 1))] }
      let(:state) { described_class.new(points: 100, lives: 5, treats: treats) }

      it "sets custom points" do
        expect(state.points).to eq(100)
      end

      it "sets custom lives" do
        expect(state.lives).to eq(5)
      end

      it "sets custom treats" do
        expect(state.treats).to eq(treats)
      end
    end
  end

  describe "#clone!" do
    let(:original_treats) { [Treat.new(position: Point.new(x: 1, y: 1))] }
    let(:original_state) { described_class.new(points: 50, lives: 2, treats: original_treats) }

    it "creates a new state with same values" do
      cloned_state = original_state.clone!

      expect(cloned_state).not_to be(original_state)
      expect(cloned_state.points).to eq(original_state.points)
      expect(cloned_state.lives).to eq(original_state.lives)
    end

    it "creates a duplicate of the treats array" do
      cloned_state = original_state.clone!

      expect(cloned_state.treats).to eq(original_state.treats)
      expect(cloned_state.treats).not_to be(original_state.treats)
    end

    it "allows independent modification of cloned state" do
      cloned_state = original_state.clone!
      cloned_state.points = 75
      cloned_state.lives = 1

      expect(original_state.points).to eq(50)
      expect(original_state.lives).to eq(2)
      expect(cloned_state.points).to eq(75)
      expect(cloned_state.lives).to eq(1)
    end
  end
end
