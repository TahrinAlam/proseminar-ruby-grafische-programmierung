# frozen_string_literal: true

require 'tk'

root = TkRoot.new do
  title 'Ampel'
  resizable false, false
end

# 500x400px großer Canvas
canvas = TkCanvas.new(root) do
  width 500
  height 400
  pack
end

# Ampel Hintergrund
TkcRectangle.new(canvas, [[175, 15], [325, 375]], fill: 'black')

# Rotes Licht
red_coords = [[200, 35], [300, 135]]
red_on = '#cc3232'
red_off = '#4f4747'
red_light = TkcOval.new(canvas, red_coords, fill: red_on)

# Gelbes Licht
yellow_coords = [[200, 145], [300, 245]]
yellow_on = '#e7b416'
yellow_off = '#57544c'
yellow_light = TkcOval.new(canvas, yellow_coords, fill: yellow_on)

# Grünes Licht
green_coords = [[200, 255], [300, 355]]
green_on = '#2dc937'
green_off = '#475748'
green_light = TkcOval.new(canvas, green_coords, fill: green_on)

# Ampelphasen:
# 🔴    🔴    ⚫    ⚫
# ⚫ -> 🟡 -> ⚫ -> 🟡 -> ...
# ⚫    ⚫    🟢    ⚫
phases = [[red_on, yellow_off, green_off], [red_on, yellow_on, green_off], [red_off, yellow_off, green_on],
          [red_off, yellow_on, green_off]]

# Animation der Ampel
animate = proc {
  red_fill, yellow_fill, green_fill = phases[0]
  phases.rotate!(1) # die erste Phase wird ans Ende verschoben

  # Färbung der Ampel setzen
  red_light.fill = red_fill
  yellow_light.fill = yellow_fill
  green_light.fill = green_fill

  # Canvas aktualisieren
  canvas.update
}

TkButton.new(root) do
  text 'Next'
  width 10
  command animate
  pack(pady: 10)
end

Tk.mainloop
