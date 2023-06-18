# frozen_string_literal: true

# AUFGABE
# Die beiden bisherigen Buttons sollen um zwei weitere ergänzt werden, sodass es auch möglich ist, die Richtung des
# Balls nach oben und unten zu verändern. Dabei soll der Ball auch weiterhin beim Treffen auf den Canvasrand sowohl die
# Farbe als auch die Richtung ändern.

require 'tk'

root = TkRoot.new do
  title 'Bouncing Ball'
  resizable false, false
end

# 500x400px Canvas mit weißem Hintergrund
canvas = TkCanvas.new(root) do
  background 'white'
  width 500
  height 400
  pack
end

# Ball startet in der Mitte des Canvas, hat die Größe 100x100 und ist zufällig gefärbt
colors = %w[red orange green blue indigo violet]
BALL_SIZE = 100
ball_coords = [[(canvas.width - BALL_SIZE) / 2, (canvas.height - BALL_SIZE) / 2],
               [(canvas.width + BALL_SIZE) / 2, (canvas.height + BALL_SIZE) / 2]]
ball = TkcOval.new(canvas, ball_coords, fill: colors.sample, outline: '')

# Bewegungsrichtung (und -geschwindigkeit) des Balls
# +movement+ wird verwendet um die Richtung für die x-Achse zu verändern. Für den Richtungswechsel nach oben und unten
# muss diese dementsprechend so angepasst werden, dass sie auch Informationen über die y-Achse enthält.
movement = 1

animate = proc {
  loop do
    # aktuelle Koordinaten des Balls abfragen
    x0, y0, x1, y1 = ball.coords

    at_left_edge = x0 <= 0 # der Ball erreicht den linken Rand des Canvas
    at_right_edge = x1 >= canvas.width # der Ball erreicht den rechten Rand des Canvas

    # wenn der Ball einen Rand des Canvas erreicht, wird die Bewegungsrichtung umgekehrt und
    # eine neue, zufällige Farbe ausgewählt
    if at_left_edge || at_right_edge
      movement *= -1
      ball.fill = colors.sample
    end

    # Ball um die Bewegungsrichtung verschieben
    ball.coords = [x0 + movement, y0, x1 + movement, y1]

    # Canvas aktualisieren und 0.01 Sekunden warten
    canvas.update
    sleep 0.01
  end
}

# nach Links bewegen
TkButton.new(root) do
  text 'Links'
  command proc { movement = -1 }
  pack(side: 'left', padx: [100, 0])
end

# nach Rechts bewegen
TkButton.new(root) do
  text 'Rechts'
  command proc { movement = 1 }
  pack(side: 'right', padx: [0, 100])
end

# sobald der Canvas gezeichnet wird, startet die Animation
canvas.bind('Map') do
  animate.call
  canvas.bind('Map') {} # Animation nur beim ersten Mal starten
end

Tk.mainloop
