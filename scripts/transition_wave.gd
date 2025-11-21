extends Path2D


func _draw():
	var points = curve.get_baked_points()

	var color = Color.GREEN

	if OS.is_debug_build():
		color = Color.YELLOW

	if points != null:
		draw_polyline(points, color, 2, true)
