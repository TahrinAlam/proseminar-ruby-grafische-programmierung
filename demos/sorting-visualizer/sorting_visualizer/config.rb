# frozen_string_literal: true

require 'tk'

PLAY_SYMBOL = '▶'
PAUSE_SYMBOL = '||'

# Configuration for sorting visualizer
class Config
  attr_accessor :data_size, :tick_speed, :min_value, :max_value, :algorithms, :generate_func, :draw_func, :data, :timer,
                :selected_algorithm, :run, :selected_algorithm_name, :data_size_range, :value_range, :tick_speed_range,
                :run_button_text, :canvas

  def initialize(algorithms, canvas, generate_func, data_size: TkVariable.new(50), data_size_range: [3, 500],
                 min_value: TkVariable.new(1), max_value: TkVariable.new(100), value_range: [1, 500],
                 tick_speed: TkVariable.new(0.01), tick_speed_range: [0.0, 1.0])
    # from constructor
    @algorithms = algorithms
    @canvas = canvas
    @generate_func = generate_func

    @data_size = data_size
    @data_size_range = data_size_range

    @min_value = min_value
    @max_value = max_value
    @value_range = value_range

    @tick_speed = tick_speed
    @tick_speed_range = tick_speed_range

    # other
    @data = []

    @draw_func = canvas.method(:draw_data) # shortcut for canvas.draw_data

    @selected_algorithm = algorithms[algorithms.keys.first]&.call
    @selected_algorithm_name = TkVariable.new(algorithms.keys.first)

    @run_button_text = TkVariable.new(PLAY_SYMBOL)

    @timer = TkTimer.new
  end

  # do a single step of the selected algorithm
  def do_sort_step
    return if @selected_algorithm.nil?

    @timer.stop
    @run_button_text.value = PLAY_SYMBOL
    begin
      @selected_algorithm&.resume(@data, @draw_func)
    rescue FiberError
      nil # Ignore error from Fiber#resume when pressing next while auto-sorting is running
    end
  end

  # sort @data with the selected algorithm.
  def run_sort
    return if @selected_algorithm.nil?

    @run_button_text.value = PAUSE_SYMBOL
    tick_speed_ms = (@tick_speed.to_f * 1000).to_i
    @timer.set_procs(tick_speed_ms, -1, proc {
      begin
        @selected_algorithm.resume(@data, @draw_func)
      rescue FiberError
        @run_button_text.value = PLAY_SYMBOL
        @timer.stop
        return
      end
    })
    @timer.start
  end

  # stop the sorting algorithm
  def stop_sort
    @run_button_text.value = PLAY_SYMBOL
    @timer.stop
  end

  # generate new data with the selected data generator
  def generate_data
    @timer.stop
    @run_button_text.value = PLAY_SYMBOL

    min_val = @min_value.to_i
    max_val = @max_value.to_i
    min_val, max_val = max_val, min_val if min_val > max_val

    @data = @generate_func.call(@data_size.to_i, min_val, max_val)

    @canvas.data_max = @data.max
    @canvas.draw_data(@data, [Colors::BARS_DEFAULT] * @data.size)

    @selected_algorithm = @algorithms[@selected_algorithm_name.value]&.call
  end

  # update the timer with the selected tick speed in ms
  def update_tick_speed
    @timer.set_interval((@tick_speed.to_f * 1000).to_i)
  end
end
