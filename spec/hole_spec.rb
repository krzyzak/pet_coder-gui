# frozen_string_literal: true

require "spec_helper"

RSpec.describe Hole do
  describe "#initialize" do
    let(:position) { Point.new(x: 5, y: 7) }
    let(:hole) { described_class.new(position: position) }

    it "creates a hole with given position" do
      expect(hole.position).to eq(position)
    end
  end
end
