# frozen_string_literal: true

require "spec_helper"

RSpec.describe Treat do
  describe "#initialize" do
    let(:position) { Point.new(x: 3, y: 4) }

    context "with default points" do
      let(:treat) { described_class.new(position: position) }

      it "creates a treat with given position" do
        expect(treat.position).to eq(position)
      end

      it "sets default points to 10" do
        expect(treat.points).to eq(10)
      end
    end

    context "with custom points" do
      let(:treat) { described_class.new(position: position, points: 25) }

      it "creates a treat with custom points" do
        expect(treat.points).to eq(25)
      end

      it "maintains the position" do
        expect(treat.position).to eq(position)
      end
    end
  end
end
