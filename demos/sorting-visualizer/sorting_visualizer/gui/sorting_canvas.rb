# frozen_string_literal: true

require_relative 'colors'

# canvas for drawing the visualization of the sorting process
class SortingCanvas < TkCanvas
  attr_accessor :data_max

  def calc_bar_coords(index, bar_height_perc, bar_width)
    spacing = (bar_width / 20).round
    x_offset = bar_width / 2
    y_offset = 30

    # top left coords
    x0 = index * bar_width + x_offset + spacing
    y0 = winfo_height - bar_height_perc * (winfo_height - y_offset)

    # bottom right coords
    x1 = (index + 1) * bar_width + x_offset - spacing
    y1 = winfo_height

    [x0, y0, x1, y1]
  end

  def draw_bar(index, value, bar_height_perc, bar_width, color)
    x0, y0, x1, y1 = calc_bar_coords(index, bar_height_perc, bar_width)

    TkcRectangle.new(self, x0, y0, x1, y1, fill: color, outline: '')
    text = bar_width < 17.25 ? nil : value
    TkcText.new(self, (x0 + x1) / 2, y0, anchor: 's', text: text, fill: color, font: 'monospace 10 bold')
  end

  def draw_data(data, coloring)
    delete('all')

    bar_width = winfo_width.to_f / (data.size + 1)

    normalized_data = data.map { |num| num.to_f / @data_max }
    normalized_data.each_with_index do |bar_height, index|
      draw_bar(index, data[index], bar_height, bar_width, coloring[index])
    end

    update
  end

  private :calc_bar_coords, :draw_bar
end
