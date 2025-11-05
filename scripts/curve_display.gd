extends Path2D
class_name CurveDisplay

@onready var ui_controller: UIController = $"../Control"
#@export var ui_controller = null
@export var spline_length = 10
@export var smooth = true
@export var speed:float = 10


func _ready() -> void:
	ui_controller.updated.connect(setup)
	setup(0.1)
	print(curve.point_count)
	#smooth_curve(spline_length)


func _process(delta: float) -> void:
	setup(0.1)


func setup(min_freq: float) -> void:
	curve.clear_points()
	var max_points = min(round(100/min_freq), 10000)

	for t in range(speed*Time.get_ticks_msec()/1000, speed*Time.get_ticks_msec()/1000+ max_points):
		var new_point = Vector2(
			t-speed*Time.get_ticks_msec()/1000,
			ui_controller.my_function(t, ui_controller.get_sin_values())
		)
		curve.add_point(new_point)

	#_draw()
	queue_redraw()
	#_notification(NOTIFICATION_DRAW)
	#draw.emit()


func _draw():
	var points = curve.get_baked_points()

	if points:
		draw_polyline(points, Color.BLACK, 2, true)


func smooth_curve(value):
	if not value: return

	var point_count = curve.get_point_count()

	for i in point_count:
		var spline = _get_spline(i)
		curve.set_point_in(i, -spline)
		curve.set_point_out(i, spline)


func _get_spline(i):
	var last_point = _get_point(i - 1)
	var next_point = _get_point(i + 1)
	var spline = last_point.direction_to(next_point) * spline_length
	return spline


func _get_point(i):
	var point_count = curve.get_point_count()
	i = wrapi(i, 0, point_count - 1)
	return curve.get_point_position(i)
