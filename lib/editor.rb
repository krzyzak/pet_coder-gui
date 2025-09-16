# frozen_string_literal: true

class Editor
  SHIFT_MAP = {
    "1" => "!",
    "2" => "@",
    "3" => "#",
    "4" => "$",
    "5" => "%",
    "6" => "^",
    "7" => "&",
    "8" => "*",
    "9" => "(",
    "0" => ")",
    "-" => "_",
    "=" => "+",
    "[" => "{",
    "]" => "}",
    ";" => ":",
    "'" => '"',
    "," => "<",
    "." => ">",
    "/" => "?",
    "\\" => "|",
    "`" => "~",
  }

  attr_reader :cursor, :text

  def initialize
    @text = +""
    @cursor = 0
  end

  def lines
    @text.split("\n")
  end

  def append_char(id, shift: false)
    base_char = Gosu.button_id_to_char(id)

    return if base_char.empty?

    char = if shift
      SHIFT_MAP[base_char] || base_char.upcase
    else
      base_char
    end

    append(char)
  end

  def append(text)
    return if text.empty?

    @text.insert(cursor, text)
    @cursor += text.length
  end

  def backspace
    return if cursor.zero?

    @text = @text[0...cursor - 1] + @text[cursor..-1]
    @cursor -= 1
  end

  def clear!
    @text = ""
    @cursor = 0
  end
end
