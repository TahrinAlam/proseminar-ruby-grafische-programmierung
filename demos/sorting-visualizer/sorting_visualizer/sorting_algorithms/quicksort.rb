# frozen_string_literal: true

def partition(data, head, tail, draw_data)
  border = head
  pivot = data[tail]

  (head..tail).each do |j|
    if data[j] < pivot
      data[border], data[j] = data[j], data[border]
      border += 1
    end

    draw_data.call(data, qs_get_color_array(data.size, head, tail, border, j))
    Fiber.yield
  end

  data[border], data[tail] = data[tail], data[border]

  border
end

def quicksort_helper(data, head, tail, draw_data)
  return unless head < tail

  pivot_index = partition(data, head, tail, draw_data)
  quicksort_helper(data, head, pivot_index - 1, draw_data)
  quicksort_helper(data, pivot_index + 1, tail, draw_data)
end

def quicksort
  Fiber.new do |data, draw_data|
    quicksort_helper(data, 0, data.length - 1, draw_data)
    draw_data.call(data, [Colors::BARS_SORTED] * data.size)
  end
end

def qs_get_color_array(length, _head, tail, border, curr_idx)
  color_array = [Colors::BARS_DEFAULT] * length

  (0..length).each do |i|
    if i == tail
      color_array[i] = Colors::BARS_RUNNER_SECONDARY
    elsif i == border || i == curr_idx
      color_array[i] = Colors::BARS_RUNNER_MAIN
    end
  end

  color_array
end
