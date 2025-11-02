extends Path2D

@onready var ui_controller: UIController = $"../Control"

func _process(delta: float) -> void:
	position.y -= delta
	curve.add_point(Vector2(Time.get_ticks_msec()/1000, ui_controller.my_function(Time.get_ticks_msec()/1000)))
	if curve.point_count >= 500:
		curve.remove_point(0)
	queue_redraw()


func _draw():
	var points = curve.get_baked_points()
	if points:
		draw_polyline(points, Color.BLUE, 4, true)
