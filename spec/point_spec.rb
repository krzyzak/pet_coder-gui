# frozen_string_literal: true

require "spec_helper"

RSpec.describe Point do
  describe "#==" do
    it "returns true for points with same coordinates" do
      point1 = described_class.new(x: 3, y: 4)
      point2 = described_class.new(x: 3, y: 4)

      expect(point1).to eq(point2)
    end

    it "returns false for points with different coordinates" do
      point1 = described_class.new(x: 3, y: 4)
      point2 = described_class.new(x: 3, y: 5)

      expect(point1).not_to eq(point2)
    end
  end
end
