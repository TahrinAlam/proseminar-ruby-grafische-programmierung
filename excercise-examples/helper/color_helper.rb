# frozen_string_literal: true

def hex_transition(start_hex, end_hex, steps)
  # Convert start and end hexadecimal color values to RGB values
  start_r = (start_hex[1..2].to_i(16) / 255.0)
  start_g = (start_hex[3..4].to_i(16) / 255.0)
  start_b = (start_hex[5..6].to_i(16) / 255.0)
  end_r = (end_hex[1..2].to_i(16) / 255.0)
  end_g = (end_hex[3..4].to_i(16) / 255.0)
  end_b = (end_hex[5..6].to_i(16) / 255.0)

  # Calculate the step size for each RGB value
  r_step = (end_r - start_r) / steps.to_f
  g_step = (end_g - start_g) / steps.to_f
  b_step = (end_b - start_b) / steps.to_f

  # Generate an array of colors that transition smoothly between the start and end colors
  (0..steps).map do |i|
    r = start_r + r_step * i
    g = start_g + g_step * i
    b = start_b + b_step * i
    rgb_to_hex((r * 255).round, (g * 255).round, (b * 255).round)
  end
end

def rgb_to_hex(r, g, b)
  # Convert RGB values to hexadecimal color value
  hex = (r << 16) + (g << 8) + b
  "##{hex.to_s(16).rjust(6, '0')}"
end

def hsv_to_hex(h, s, v)
  # Convert HSV values to RGB values
  c = v * s
  x = c * (1 - ((h / 60.0) % 2 - 1).abs)
  m = v - c
  r, g, b = if h < 60
              [c, x, 0]
            elsif h < 120
              [x, c, 0]
            elsif h < 180
              [0, c, x]
            elsif h < 240
              [0, x, c]
            elsif h < 300
              [x, 0, c]
            else
              [c, 0, x]
            end
  r = ((r + m) * 255).round
  g = ((g + m) * 255).round
  b = ((b + m) * 255).round

  # Convert RGB values to hexadecimal color value
  hex = (r << 16) + (g << 8) + b
  "##{hex.to_s(16).rjust(6, '0')}"
end

def color_wheel(steps)
  # Calculate the step size for each color value
  step_size = 360 / steps.to_f

  # Generate an array of colors that rotate through the color wheel
  (0..steps).map do |i|
    hue = (i * step_size) % 360
    hsv_to_hex(hue, 1, 1)
  end
end
