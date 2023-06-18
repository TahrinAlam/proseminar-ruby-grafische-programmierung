# frozen_string_literal: true

def combsort
  Fiber.new do |data, draw_data|
    gap = data.size
    swapped = true
    while gap > 1 || swapped
      gap = (gap / 1.3).to_i
      gap = 1 if gap < 1

      swapped = false
      (0..data.size - gap - 1).each do |i|
        if data[i] > data[i + gap]
          data[i], data[i + gap] = data[i + gap], data[i]
          swapped = true
        end

        coloring = [Colors::BARS_DEFAULT] * data.size
        coloring[i] = Colors::BARS_RUNNER_MAIN
        coloring[i + gap] = Colors::BARS_RUNNER_MAIN
        draw_data.call(data, coloring)
        Fiber.yield
      end
    end
    draw_data.call(data, [Colors::BARS_SORTED] * data.size)
  end
end
