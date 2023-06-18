# frozen_string_literal: true

def selectionsort
  Fiber.new do |data, draw_data|
    (0..data.size - 2).each do |i|
      min_idx = i

      (i + 1..data.size - 1).each do |j|
        min_idx = j if data[j] < data[min_idx]

        coloring = [Colors::BARS_DEFAULT] * data.size
        coloring[i] = Colors::BARS_RUNNER_MAIN
        coloring[j] = Colors::BARS_RUNNER_SECONDARY
        coloring[min_idx] = Colors::BARS_RUNNER_MAIN
        draw_data.call(data, coloring)
        Fiber.yield
      end

      data[i], data[min_idx] = data[min_idx], data[i]

      coloring = [Colors::BARS_DEFAULT] * data.size
      coloring[i] = Colors::BARS_RUNNER_MAIN
      coloring[min_idx] = Colors::BARS_RUNNER_MAIN
      draw_data.call(data, coloring)
      Fiber.yield
    end
    draw_data.call(data, [Colors::BARS_SORTED] * data.size)
  end
end
