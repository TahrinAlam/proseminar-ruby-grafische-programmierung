# frozen_string_literal: true

def bogosort
  Fiber.new do |data, draw_data|
    until sorted?(data)
      data.shuffle!
      draw_data.call(data, [Colors::BARS_DEFAULT] * data.size)
      Fiber.yield
    end
    draw_data.call(data, [Colors::BARS_SORTED] * data.size)
  end
end

def sorted?(data)
  data.each_cons(2) do |curr, nxt|
    return false if curr > nxt
  end
  true
end
