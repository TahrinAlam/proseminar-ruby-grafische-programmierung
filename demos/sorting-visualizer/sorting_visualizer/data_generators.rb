# frozen_string_literal: true

# Data generators for sorting visualizer
module DataGenerator
  def self.random(size, min, max)
    Array.new(size) { rand(min..max) }
  end

  def self.straight(size, min, max)
    Array.new(size) { |i| (i + 1) * (max - min) / size + min }.shuffle
  end

  def self.stairs(size, _, _)
    (1..size).to_a.shuffle
  end
end
