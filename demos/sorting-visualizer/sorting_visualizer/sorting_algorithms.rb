# frozen_string_literal: true

require_relative 'sorting_algorithms/bubblesort'
require_relative 'sorting_algorithms/selectionsort'
require_relative 'sorting_algorithms/bogosort'
require_relative 'sorting_algorithms/combsort'
require_relative 'sorting_algorithms/cocktailsort'
require_relative 'sorting_algorithms/mergesort'
require_relative 'sorting_algorithms/quicksort'

SORTING_ALGORITHMS = {
  'Bubblesort' => method(:bubblesort),
  'Selectionsort' => method(:selectionsort),
  # 'Bogosort' => method(:bogosort),
  'Combsort' => method(:combsort),
  'Cocktailsort' => method(:cocktailsort),
  'Mergesort' => method(:mergesort),
  'Quicksort' => method(:quicksort)
}.sort.to_h.freeze
