extends Control

var width: int = ProjectSettings.get_setting("display/window/size/viewport_width")
var height: int = ProjectSettings.get_setting("display/window/size/viewport_height")

var color: Color = Color.BLACK
var points: PackedVector2Array = []

func setup_zigzag() -> void:
	var temp_array: PackedVector2Array = []

	var x: int = width
	var y: int = 0
	points.append(Vector2(x,y))
	temp_array.append(Vector2(x - (width + 64), y))

	while y <= height * 2:
		y += 32
		if x <= width:
			x += 32
		else:
			x -= 32

		points.append(Vector2(x,y))
		temp_array.append(Vector2(x - (width + 64), y))

	temp_array.reverse()
	points.append_array(temp_array)

	global_position = Vector2(-width, 0)

func _draw() -> void:
	draw_polygon(points, [color])
