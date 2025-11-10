extends Path2D


func _draw():
	var points = curve.get_baked_points()

	if points != null:
		draw_polyline(points, Color.BLUE, 2, true)
