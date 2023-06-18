# frozen_string_literal: true

MIDDLE_GAP = 10
OUTER_PADDING = 10
Y_PADDING = 5
BOTTOM_PADDING = 5

LEFT_HALF_PADDING = [OUTER_PADDING, MIDDLE_GAP].freeze
RIGHT_HALF_PADDING = [MIDDLE_GAP, OUTER_PADDING].freeze

# settings bar at the top of the window
class SettingsFrame < TkFrame
  def initialize(parent, config)
    super(parent)

    # ---------- Algorithm Settings ----------
    # label for the algorithm selection combobox
    TkLabel.new(self) do
      text 'Algorithm'
      grid(column: 2, row: 0, sticky: 'nsw', padx: RIGHT_HALF_PADDING, pady: [Y_PADDING, 0])
    end

    # combobox to select a sorting algorithm
    TkCombobox.new(self) do
      state 'readonly'
      values config.algorithms.keys
      textvariable config.selected_algorithm_name
      bind '<ComboboxSelected>' do
        config.selected_algorithm = config.algorithms[config.selected_algorithm_name.value].call
        config.stop_sort
      end
      grid(column: 2, row: 1, columnspan: 2, sticky: 'news', padx: RIGHT_HALF_PADDING, pady: [0, Y_PADDING])
    end

    # scale to select the tick speed
    TkScale.new(self) do
      orient 'horizontal'
      from 0.0
      to 1
      digits 2
      resolution 0.1
      label 'Tick Speed [s]'
      variable config.tick_speed
      bind 'ButtonRelease' do
        config.update_tick_speed
      end
      grid(column: 2, row: 2, columnspan: 2, sticky: 'news', padx: RIGHT_HALF_PADDING, pady: Y_PADDING)
    end

    # button to start/stop the sorting algorithm
    TkButton.new(self) do
      textvariable config.run_button_text
      command proc { config.timer.running? ? config.stop_sort : config.run_sort }
      grid(column: 3, row: 3, sticky: 'news', padx: [1, OUTER_PADDING], pady: [Y_PADDING, BOTTOM_PADDING])
    end

    # button to do a single step of the sorting algorithm
    TkButton.new(self) do
      text 'Step'
      command proc { config.do_sort_step }
      grid(column: 2, row: 3, sticky: 'news', padx: [MIDDLE_GAP, 1], pady: [Y_PADDING, BOTTOM_PADDING])
    end

    # ---------- Data Settings ----------
    # scale to select the data size
    TkScale.new(self) do
      orient 'horizontal'
      from config.data_size_range[0]
      to config.data_size_range[1]
      label 'Data Size'
      variable config.data_size
      grid(column: 0, row: 0, columnspan: 2, rowspan: 2, sticky: 'news', padx: LEFT_HALF_PADDING,
           pady: Y_PADDING)
    end

    # scale to select the minimum data value
    TkScale.new(self) do
      orient 'horizontal'
      from config.value_range[0]
      to config.value_range[1]
      label 'Min Value'
      variable config.min_value
      grid(column: 0, row: 2, sticky: 'news', padx: [OUTER_PADDING, 0], pady: Y_PADDING)
    end

    # scale to select the maximum data value
    TkScale.new(self) do
      orient 'horizontal'
      from config.value_range[0]
      to config.value_range[1]
      label 'Max Value'
      variable config.max_value
      grid(column: 1, row: 2, sticky: 'news', padx: [0, MIDDLE_GAP], pady: Y_PADDING)
    end

    # button to generate new data
    TkButton.new(self) do
      text 'Generate Data'
      command proc { config.generate_data }
      grid(column: 0, row: 3, columnspan: 2, sticky: 'news', padx: LEFT_HALF_PADDING,
           pady: [Y_PADDING, BOTTOM_PADDING])
    end
  end
end
