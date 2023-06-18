# frozen_string_literal: true

def bubblesort
  Fiber.new do |data, draw_data|
    swapped = true
    while swapped
      swapped = false
      (0..data.size - 2).each do |i|
        if data[i] > data[i + 1]
          coloring = [Colors::BARS_DEFAULT] * data.size
          coloring[i] = Colors::BARS_RUNNER_MAIN
          coloring[i + 1] = Colors::BARS_RUNNER_MAIN
          draw_data.call(data, coloring)
          Fiber.yield

          data[i], data[i + 1] = data[i + 1], data[i]
          swapped = true
          next
        end

        coloring = [Colors::BARS_DEFAULT] * data.size
        coloring[i] = Colors::BARS_RUNNER_MAIN
        coloring[i + 1] = Colors::BARS_RUNNER_MAIN
        draw_data.call(data, coloring)
        Fiber.yield
      end
    end
    draw_data.call(data, [Colors::BARS_SORTED] * data.size)
  end
end
