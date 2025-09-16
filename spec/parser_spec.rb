# frozen_string_literal: true

require "spec_helper"

RSpec.describe Parser do
  let(:parser) { described_class.new }

  describe "#initialize" do
    it "initializes with empty commands" do
      expect(parser.commands).to eq([])
    end
  end

  describe "#parse" do
    context "with basic movement commands" do
      it "parses single up command" do
        commands = parser.parse("up")
        expect(commands).to eq([:up])
      end

      it "parses single down command" do
        commands = parser.parse("down")
        expect(commands).to eq([:down])
      end

      it "parses single left command" do
        commands = parser.parse("left")
        expect(commands).to eq([:left])
      end

      it "parses single right command" do
        commands = parser.parse("right")
        expect(commands).to eq([:right])
      end
    end

    context "with multiple commands" do
      it "parses multiple movement commands" do
        text = <<~RUBY
          up
          right
          down
          left
        RUBY

        commands = parser.parse(text)
        expect(commands).to eq([:up, :right, :down, :left])
      end
    end

    context "with Ruby control structures" do
      it "parses commands with times loop" do
        commands = parser.parse("3.times { right }")
        expect(commands).to eq([:right, :right, :right])
      end

      it "parses mixed commands with loops" do
        text = <<~RUBY
          up
          2.times { right }
          down
        RUBY

        commands = parser.parse(text)
        expect(commands).to eq([:up, :right, :right, :down])
      end

      it "parses nested loops" do
        text = <<~RUBY
          2.times do
            2.times { right }
            down
          end
        RUBY

        commands = parser.parse(text)
        expect(commands).to eq([:right, :right, :down, :right, :right, :down])
      end
    end

    context "with conditional statements" do
      it "parses commands with if statements" do
        text = <<~RUBY
          if true
            up
            right
          end
        RUBY

        commands = parser.parse(text)
        expect(commands).to eq([:up, :right])
      end

      it "skips commands in false condition" do
        text = <<~RUBY
          if false
            up
          end
          right
        RUBY

        commands = parser.parse(text)
        expect(commands).to eq([:right])
      end
    end
  end

  describe "#commands" do
    it "returns the current commands array" do
      parser.parse("up; right")
      expect(parser.commands).to eq([:up, :right])
    end

    it "accumulates commands across multiple parse calls" do
      parser.parse("up")
      parser.parse("right")
      expect(parser.commands).to eq([:up, :right])
    end
  end

  describe "#clear!" do
    before do
      parser.parse("up; right; down")
    end

    it "clears the commands array" do
      expect(parser.commands).not_to be_empty
      parser.clear!
      expect(parser.commands).to be_empty
    end

    it "resets the context" do
      parser.clear!
      parser.parse("left")
      expect(parser.commands).to eq([:left])
    end
  end
end
