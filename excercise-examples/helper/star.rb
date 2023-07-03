# frozen_string_literal: true

require 'tk'

# Star for TkCanvas
class Star < TkcPolygon
  attr_reader :center_coords, :n_segments, :inner_radius, :outer_radius, :rotation

  # Creates a new Star on the canvas.
  # Params:
  # +parent+:: The parent canvas.
  # +center_coords+:: +Array+   The center coordinates of the star.
  # +n_segments+::    +Integer+ The number of segments of the star.
  # +inner_radius+::  +Integer+ The inner radius of the star.
  # +outer_radius+::  +Integer+ The outer radius of the star.
  # +rotation+::      +Integer+ The rotation of the star in degrees.
  def initialize(parent, center_coords, *args)
    @parent = parent
    @center_coords = center_coords
    @n_segments = args[-1].delete(:n_segments) || 5
    @inner_radius = args[-1].delete(:inner_radius) || 10
    @outer_radius = args[-1].delete(:outer_radius) || 20
    @rotation = args[-1].delete(:rotation) || 0
    args[-1][:coords] =
      calc_star_points(@center_coords, @n_segments, @inner_radius, @outer_radius, rotation: @rotation)
    super(parent, *args)
  end

  def center_coords=(coords)
    @center_coords = coords
    self.coords = calc_star_points(@center_coords, @n_segments, @inner_radius, @outer_radius, rotation: @rotation)
  end

  def n_segments=(n_segments)
    @n_segments = n_segments
    self.coords = calc_star_points(@center_coords, @n_segments, @inner_radius, @outer_radius, rotation: @rotation)
  end

  def inner_radius=(radius)
    @inner_radius = radius
    self.coords = calc_star_points(@center_coords, @n_segments, @inner_radius, @outer_radius, rotation: @rotation)
  end

  def outer_radius=(radius)
    @outer_radius = radius
    self.coords = calc_star_points(@center_coords, @n_segments, @inner_radius, @outer_radius, rotation: @rotation)
  end

  def rotation=(rotation)
    @rotation = rotation
    self.coords = calc_star_points(@center_coords, @n_segments, @inner_radius, @outer_radius, rotation: @rotation)
  end

  def calc_star_points(center, n_segments, inner_radius, outer_radius, rotation: 0)
    points = []
    angle_step = Math::PI / n_segments
    rotation_rad = rotation * Math::PI / 180

    (0..n_segments * 2).each do |i|
      angle = i * angle_step + Math::PI / 2 + rotation_rad
      r = i.even? ? outer_radius : inner_radius
      x = center[0] - r * Math.cos(angle)
      y = center[1] - r * Math.sin(angle)
      points.append(x, y)
    end
    points
  end

  private :calc_star_points
end
