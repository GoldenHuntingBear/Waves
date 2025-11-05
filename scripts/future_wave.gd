extends Path2D


func setup(min_freq: float, speed: float, waves_collection: SinWaveCollection) -> void:
	curve.clear_points()
	var max_points = min(round(100/min_freq), 10000)

	for t in range(speed*Time.get_ticks_msec()/1000, speed*Time.get_ticks_msec()/1000+ max_points):
		var new_point = Vector2(
			t-speed*Time.get_ticks_msec()/1000,
			waves_collection.function(t)
		)
		curve.add_point(new_point)

	queue_redraw()


func _draw():
	var points = curve.get_baked_points()

	if points:
		draw_polyline(points, Color.BLACK, 2, true)
