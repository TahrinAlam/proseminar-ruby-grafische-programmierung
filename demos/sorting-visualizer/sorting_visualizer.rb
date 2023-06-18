# frozen_string_literal: true

require 'tk'
require_relative 'sorting_visualizer/sorting_algorithms'
require_relative 'sorting_visualizer/gui/sorting_canvas'
require_relative 'sorting_visualizer/gui/settings_frame'
require_relative 'sorting_visualizer/config'
require_relative 'sorting_visualizer/data_generators'

# Visualizer for sorting algorithms
class SortingVisualizer
  def initialize(sorting_algorithms: SORTING_ALGORITHMS, data_generator: DataGenerator.method(:straight))
    window = TkRoot.new do
      title 'Sorting Algorithm Visualizer'
      resizable false, false
      minsize 900, 600
      maxsize 900, 600
      bind 'Escape' do
        destroy
      end
    end

    canvas = SortingCanvas.new(window) do
      background Colors::BG_CANVAS
      highlightthickness 0
      pack(side: 'bottom', expand: 'yes', fill: 'both', padx: 10, pady: 10)
    end

    config = Config.new(sorting_algorithms, canvas, data_generator)

    settings_frame = SettingsFrame.new(window, config) do
      pack(side: 'top', fill: 'both', anchor: 'center')
    end
    settings_frame.grid_columnconfigure((0..1).to_a, weight: 1)
    settings_frame.grid_columnconfigure(2, weight: 0)
    settings_frame.grid_columnconfigure(3, weight: 2)
    settings_frame.grid_rowconfigure((0..3).to_a, weight: 1)

    # generate data on startup
    canvas.bind('Map') do
      config.generate_data
      canvas.bind('Map') {}
    end
  end
end

if __FILE__ == $PROGRAM_NAME
  SortingVisualizer.new
  Tk.mainloop
end
