# frozen_string_literal: true

require "spec_helper"

RSpec.describe Editor do
  let(:editor) { described_class.new }

  describe "#initialize" do
    it "starts with empty text" do
      expect(editor.text).to eq("")
    end

    it "starts with cursor at position 0" do
      expect(editor.cursor).to eq(0)
    end
  end

  describe "#lines" do
    context "with empty text" do
      it "returns an empty array" do
        expect(editor.lines).to eq([])
      end
    end

    context "with single line" do
      before { editor.append("hello world") }

      it "returns array with single line" do
        expect(editor.lines).to eq(["hello world"])
      end
    end

    context "with multiple lines" do
      before do
        editor.append("line 1")
        editor.append("\n")
        editor.append("line 2")
        editor.append("\n")
        editor.append("line 3")
      end

      it "returns array with multiple lines" do
        expect(editor.lines).to eq(["line 1", "line 2", "line 3"])
      end
    end
  end

  describe "#append" do
    it "appends text at cursor position" do
      editor.append("hello")
      expect(editor.text).to eq("hello")
    end

    it "moves cursor to end of appended text" do
      editor.append("hello")
      expect(editor.cursor).to eq(5)
    end

    it "appends text in the middle" do
      editor.append("hello")
      editor.instance_variable_set(:@cursor, 2)
      editor.append("XYZ")
      expect(editor.text).to eq("heXYZllo")
    end

    it "ignores empty text" do
      initial_text = editor.text
      initial_cursor = editor.cursor

      editor.append("")

      expect(editor.text).to eq(initial_text)
      expect(editor.cursor).to eq(initial_cursor)
    end

    it "handles newlines" do
      editor.append("line1")
      editor.append("\n")
      editor.append("line2")

      expect(editor.text).to eq("line1\nline2")
      expect(editor.lines).to eq(["line1", "line2"])
    end
  end

  describe "#append_char" do
    before do
      allow(Gosu).to receive(:button_id_to_char).and_return("a")
    end

    context "without shift" do
      it "appends lowercase character" do
        editor.append_char(1, shift: false)
        expect(editor.text).to eq("a")
      end
    end

    context "with shift" do
      it "appends uppercase character" do
        editor.append_char(1, shift: true)
        expect(editor.text).to eq("A")
      end
    end

    context "with special characters and shift" do
      before do
        allow(Gosu).to receive(:button_id_to_char).and_return("1")
      end

      it "appends shifted special character" do
        editor.append_char(1, shift: true)
        expect(editor.text).to eq("!")
      end
    end

    context "with empty character from Gosu" do
      before do
        allow(Gosu).to receive(:button_id_to_char).and_return("")
      end

      it "does not append anything" do
        initial_text = editor.text
        editor.append_char(1)
        expect(editor.text).to eq(initial_text)
      end
    end
  end

  describe "#backspace" do
    context "with text at cursor position" do
      before do
        editor.append("hello")
      end

      it "removes character before cursor" do
        editor.backspace
        expect(editor.text).to eq("hell")
      end

      it "moves cursor back" do
        editor.backspace
        expect(editor.cursor).to eq(4)
      end
    end

    context "when cursor is at beginning" do
      it "does not remove anything" do
        editor.append("hello")
        editor.instance_variable_set(:@cursor, 0)

        editor.backspace
        expect(editor.text).to eq("hello")
        expect(editor.cursor).to eq(0)
      end
    end

    context "when cursor is in middle of text" do
      before do
        editor.append("hello")
        editor.instance_variable_set(:@cursor, 3)
      end

      it "removes character at cursor position" do
        editor.backspace
        expect(editor.text).to eq("helo")
      end

      it "moves cursor back" do
        editor.backspace
        expect(editor.cursor).to eq(2)
      end
    end
  end

  describe "#clear!" do
    before do
      editor.append("some text")
    end

    it "clears all text" do
      editor.clear!
      expect(editor.text).to eq("")
    end

    it "resets cursor to beginning" do
      editor.clear!
      expect(editor.cursor).to eq(0)
    end
  end

  describe "SHIFT_MAP constant" do
    it "contains expected character mappings" do
      expect(Editor::SHIFT_MAP["1"]).to eq("!")
      expect(Editor::SHIFT_MAP["2"]).to eq("@")
      expect(Editor::SHIFT_MAP["3"]).to eq("#")
      expect(Editor::SHIFT_MAP["="]).to eq("+")
      expect(Editor::SHIFT_MAP[";"]).to eq(":")
      expect(Editor::SHIFT_MAP["'"]).to eq('"')
    end
  end

  describe "complex text editing scenarios" do
    it "handles mixed operations" do
      editor.append("hello")
      editor.append(" ")
      editor.append("world")
      editor.backspace
      editor.backspace
      editor.backspace
      editor.backspace
      editor.backspace
      editor.append("ruby")

      expect(editor.text).to eq("hello ruby")
    end

    it "handles newlines and backspace" do
      editor.append("line1")
      editor.append("\n")
      editor.append("line2")
      editor.backspace
      editor.backspace

      expect(editor.text).to eq("line1\nlin")
      expect(editor.lines).to eq(["line1", "lin"])
    end
  end
end
