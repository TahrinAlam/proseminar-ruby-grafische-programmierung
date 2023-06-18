# frozen_string_literal: true

require 'tk'
require_relative './helper/star'
require_relative './helper/color_helper'

# --- Setup ---
root = TkRoot.new do
  title 'Christmas Tree'
  resizable false, false
end

# 500x400px Canvas mit weißem Hintergrund
canvas = TkCanvas.new(root) do
  background '#202842'
  width 500
  height 400
  bind '1' do
    puts "x: #{winfo_pointerx - winfo_rootx}  y: #{winfo_pointery - winfo_rooty}"
  end
  pack
end

# --- Boden ---
TkcPolygon.new(canvas, coords: [[-100, 600], [700, 600], [700, 335], [400, 345], [200, 345], [-1000, 340]],
                       fill: '#aab1c3', outline: '', smooth: true)

# --- Weihnachtsbaum ---
# Stamm
TkcRectangle.new(canvas, [[225, 330], [275, 365]], fill: '#6c3f2b', outline: '', tag: 'stem') # Stamm

# unterer Baumteil
bot_points = [[250, 125], [375, 333], [333, 332], [291, 337], [255, 334], [212, 336], [169, 328], [124, 331]]
TkcPolygon.new(canvas, bot_points, fill: '#374b30', outline: '', tag: 'tree')
TkcLine.new(canvas, [[375, 333], [333, 332], [291, 337], [255, 334], [212, 336], [169, 328], [124, 331]],
            fill: '#aab1c3', width: 5)

# mittlerer Baumteil
mid_points = [[250, 79], [344, 232], [315, 229], [293, 233], [265, 230], [231, 234], [195, 229], [154, 231]]
TkcPolygon.new(canvas, mid_points, fill: '#455d3c', outline: '', tag: 'tree')
TkcLine.new(canvas, [[344, 232], [315, 229], [293, 233], [265, 230], [231, 234], [195, 229], [154, 231]],
            fill: '#aab1c3', width: 5)

# oberer Baumteil
top_points = [[250, 35], [316, 144], [284, 140], [254, 145], [215, 142], [181, 145]]
TkcPolygon.new(canvas, top_points, fill: '#53643F', outline: '', tag: 'tree')
TkcLine.new(canvas, [[316, 144], [284, 140], [254, 145], [215, 142], [181, 145]], fill: '#aab1c3', width: 5)

# Stern auf der Baumspitze
TREE_STAR_CENTER = [250, 37].freeze
tree_star = Star.new(canvas, TREE_STAR_CENTER, inner_radius: 7, outer_radius: 15, fill: '#e8c38b', outline: '')

# ----------------------------------------------------------------------------------------------------------------------

# Lichterkette:
# Der Weihnachtsbaum soll mit einer Lichterkette geschmückt werden. Hierfür sollen Lichter, dargestellt durch 'TkcOval',
# an beliebigen Stellen auf dem Baum angebracht werden. Für ein Bild des Baums mit Koordinatengitter siehe
# 'images/christmas-tree-grid.png'.

# Ein TkcOval kann mit folgendem Code erstellt werden:
#
#   TkcOval.new(canvas, [[x0, y0], [x1, y1]], fill: '<Farbe>', outline: '')
#
# Das erste Argument ist der Canvas, auf dem das Oval gezeichnet werden soll. Das zweite Argument sind die Koordinaten,
# wobei [x0, y0] die linke obere Ecke und [x1, y1] die rechte untere Ecke des Ovals angeben.
# Die Farbe des Ovals kann mit dem Parameter 'fill' angegeben werden. Hierbei können einige vordefinierte Farbnamen,
# wie 'white', 'red', ... verwendet werden. Alternativ kann auch ein Hex-Code, wie '#ff0000' angegeben werden.
# Standardmäßig wird das Oval mit einer schwarzen Umrandung gezeichnet. Diese kann mit dem Parameter 'outline' angepasst
# werden. Um keine Umrandung zu zeichnen, wird ein leerer String angegeben.

# Da die Lichter später animiert werden sollen, ist es sinnvoll, die erstellten Lichter auch wieder ansprechen zu
# können. Um nicht jedes einzelne TkcOval in einer Variable speichern zu müssen, bietet es sich an,
# Tags zu verwenden. Tags können bei der Erstellung eines Objektes mit dem Parameter 'tag' übergeben werden.
# Beispielsweise kann ein TkcOval mit dem Tag 'lights' wie folgt erstellt werden:
#
#   TkcOval.new(canvas, [[x0, y0], [x1, y1]], fill: '<Farbe>', outline: '', tag: 'lights')
#
# Mit unterschiedlichen Tags können unterschiedliche Lichtergruppen erstellt werden. So können beispielsweise später
# alle Lichter einer Gruppe immer mit der gleichen Farbe leuchten.

# < CODE HERE >

# ----------------------------------------------------------------------------------------------------------------------

# Sterne im Himmel:
# Damit der Himmel nicht so leer aussieht, soll er mit Sternen bedeckt werden. TK stellt leider kein Stern-Objekt
# zur Verfügung. Normalerweise müsste hierfür dann ein Polygon gezeichnet werden. Da dies aber sehr viel Mathe
# beinhaltet und aufwändig ist, stellen wir die Klasse 'Star' zur Verfügung. Diese kann wie folgt verwendet werden:
#
#   Star.new(canvas, [x, y], n_segments: <Anzahl Zacken>, inner_radius: <Innenradius>, outer_radius: <Außenradius>,
#                            rotation: <Rotation in Grad>, fill: <Farbe>, outline: <Umrandungsfarbe>, tag: <Tag>)
#
# Das erste Argument ist wieder der Canvas, auf dem der Stern gezeichnet werden soll. Das zweite Argument sind die
# Koordinaten des Mittelpunktes des Sterns. Die Anzahl der Zacken kann mit dem Parameter 'n_segments' angegeben werden.
# Der Innenradius und Außenradius geben die Größe des Sterns an. Die Rotation gibt an, um wie viel Grad der Stern
# gedreht werden soll. 'fill', 'outline' und 'tag' funktionieren wie bei den anderen Canvas-Objekten.

# < CODE HERE >

# ----------------------------------------------------------------------------------------------------------------------

# Animation:
# Nun sollen die erstellten Sterne und Lichter animiert werden. Hierfür wird eine Endlosschleife verwendet, die
# in jedem Durchlauf die Eigenschaften der Sterne und Lichter verändert. Damit die Animation nicht zu schnell
# abläuft, wird am Ende jedes Durchlaufs eine kurze Pause mit 'sleep <Sekunden>' eingefügt.
# Die in den vorherigen Aufgaben erstellten Objekte können mit der Methode 'find_withtag' des Canvas gefunden werden:
#
#   canvas.find_withtag('<Tag>')
#   # => [Objekt1, Objekt2, ...]
#
# Bei den Lichtern bietet es sich an, die Farbe zu ändern. Hierfür kann das Attribut 'fill' verändert werden:
#
#   light.fill = <Farbe>
#
# Die Farben können beispielsweise zufällig aus einem Farb-Array, oder nach einer vordefinierten Sequenz (vgl.
# Ampel Beispiel), ausgewählt werden. Die Position eines Lichts kann mit dem Attribute 'coords' verändert werden.
# Die Sterne haben ebenfalls Parameter zum anpassen:
#   - 'star.n_segments' legt die Anzahl der Zacken des Sterns fest
#   - 'star.center_coords' ermöglicht das Verändern der Position des Sterns
#   - 'star.outer_radius'/'star.inner_radius' ändert die Größe des Sterns
#   - 'star.rotation' dreht den Stern um den Mittelpunkt
#
# Da ca. alle 0.01 Sekunden ein neues Bild gezeichnet wird, sollten nicht in jedem Schleifendurchlauf die Parameter
# verändert werden. Hierfür wird vor dem Start der Schleife ein Timer erstellt. Der Timer nimmt Werte zwischen 0 und
# 99 an und wird mit jedem Schleifendurchlauf um 1 erhöht (und bei 99 wieder auf 0 gesetzt). Insgesamt benötigt der
# Timer 1 Sekunde, um von 0 auf 0 zu zählen. Mit dem Timer können nun bestimmte Aktionen nur alle x Schleifendurchläufe
# ausgeführt werden. Beispielsweise kann die Farbe der Lichter nur alle 100 Schleifendurchläufe (= 1 Sekunde) geändert
# werden, indem nur bei timer == 0 die Farbe geändert wird:
#
#   if timer.zero?
#     # Aktion
#   end
#
# Soll etwas alle 0.1 Sekunden ausgeführt werden, bietet sich die Modulo-Operation an:
#
#   if (timer % 10).zero?
#     # Aktion
#   end
#
# Reicht der Wertebereich des Timers nicht aus, kann dieser einfach angepasst werden, indem ein anderer Modulo-Wert
# verwendet wird.
#
# Als Beispiel ist bereits eine Animation für den Stern auf der Spitze des Weihnachtsbaums vorgegeben: Der Stern
# dreht sich langsam und ändert dabei seine Größe.

animate = proc {
  timer = 0
  increase = true
  loop do
    # Animation für den Stern auf der Spitze des Weihnachtsbaums
    # Bei jeden Schleifendurchlauf wird der Stern um einen kleinen Wert weiter rotiert. Zusätzlich wird die Größe
    # des Sterns, je nach aktuellem Wert, leicht erhöht oder vermindert.
    # Die Geschwindigkeit der Veränderungen lässt sich durch die Größe des addierten/subtrahierten Werts anpassen.
    # '% 360' verhindert, dass es zu einem Overflow kommt.
    tree_star.rotation = (tree_star.rotation + 0.3) % 360
    tree_star.outer_radius += 0.02 * (increase ? 1 : -1)
    increase = !increase if tree_star.outer_radius >= 17 || tree_star.outer_radius <= 13

    # < CODE HERE >

    # Timer erhöhen, Canvas neu zeichnen und kurz warten
    timer = (timer + 1) % 100
    canvas.update
    sleep 0.01
  end
}

# sobald der Canvas gezeichnet wird, startet die Animation
canvas.bind('Map') do
  animate.call
  canvas.bind('Map') {} # Animation nur beim ersten Mal starten
end

Tk.mainloop
