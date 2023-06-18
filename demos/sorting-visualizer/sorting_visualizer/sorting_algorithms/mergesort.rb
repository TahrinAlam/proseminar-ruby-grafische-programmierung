# frozen_string_literal: true

def merge(data, left, mid, right, draw_data)
  draw_data.call(data, ms_get_color_array(data.size, left, right))
  Fiber.yield

  temp = Array.new(right - left + 1)
  i = left
  j = mid + 1
  k = 0
  while i <= mid && j <= right
    if data[i] <= data[j]
      temp[k] = data[i]
      i += 1
    else
      temp[k] = data[j]
      j += 1
    end
    k += 1
  end

  while i <= mid
    temp[k] = data[i]
    i += 1
    k += 1
  end

  while j <= right
    temp[k] = data[j]
    j += 1
    k += 1
  end

  k = 0
  i = left
  while i <= right
    data[i] = temp[k]
    colors = [Colors::BARS_DEFAULT] * data.size
    colors[i] = Colors::BARS_RUNNER_MAIN
    draw_data.call(data, colors)
    Fiber.yield
    i += 1
    k += 1
  end
end

def merge_sort(data, left, right, draw_data)
  return unless left < right

  mid = (left + right) / 2
  merge_sort(data, left, mid, draw_data)
  merge_sort(data, mid + 1, right, draw_data)
  merge(data, left, mid, right, draw_data)
end

def ms_get_color_array(length, left, right)
  color_array = []
  (0..length).each do |i|
    if i >= left && i <= right
      color_array.push(Colors::BARS_RUNNER_MAIN)
    else
      color_array.push(Colors::BARS_DEFAULT)
    end
  end
  color_array
end

def mergesort
  Fiber.new do |data, draw_data|
    merge_sort(data, 0, data.size - 1, draw_data)
    draw_data.call(data, [Colors::BARS_SORTED] * data.size)
  end
end
