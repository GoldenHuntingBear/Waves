extends Path2D

@onready var ui_controller: UIController = $"../Control"
@export var speed:float = 10
@export var transition_speed: float = 0.5
var sin_values_amplitudes: Array[SinWaveCollection] = []


func _ready() -> void:
	ui_controller.updated.connect(update_sin_values_amplitudes)


func update_sin_values_amplitudes(_min_freq: float):
	print("changing")
	if len(sin_values_amplitudes) == 0:
		sin_values_amplitudes.append(SinWaveCollection.new(1, ui_controller.get_sin_values()))
		return

	if len(sin_values_amplitudes) == 2:
		var new_first_collection = sin_values_amplitudes[0].change_amplitude(1)
		new_first_collection.add(sin_values_amplitudes[1])
		sin_values_amplitudes[0] = new_first_collection
		sin_values_amplitudes[1] = SinWaveCollection.new(0, ui_controller.get_sin_values())
	else:
		sin_values_amplitudes.append(SinWaveCollection.new(0, ui_controller.get_sin_values()))


func _process(delta: float) -> void:
	if len(sin_values_amplitudes) == 0:
		update_sin_values_amplitudes(0)

	transition(delta)
	position.x -= speed*delta
	var value = speed*Time.get_ticks_msec()/1000
	var y = get_y(value)

	#if ui_controller.old_sin_values:
		#y = (ui_controller.my_function(value, ui_controller.get_sin_values()) + ui_controller.my_function(value, ui_controller.old_sin_values)) / 2.0

	#else:
		#y = ui_controller.my_function(value, ui_controller.get_sin_values())

	curve.add_point(Vector2(value, y))
	if curve.point_count >= 500:
		curve.remove_point(0)

	queue_redraw()


func get_y(time: float) -> float:
	var result = 0

	for collection in sin_values_amplitudes:
		result += collection.function(time)

	return result


func transition(delta: float) -> void:
	if len(sin_values_amplitudes) <= 1:
		return

	sin_values_amplitudes[0].amplitude -= delta * transition_speed
	sin_values_amplitudes[1].amplitude += delta * transition_speed

	if sin_values_amplitudes[1].amplitude > 1:
		sin_values_amplitudes[1].amplitude = 1

	if sin_values_amplitudes[0].amplitude < 0.01:
		sin_values_amplitudes.remove_at(0)

	# remove too small waves from [0]


func _draw():
	var points = curve.get_baked_points()

	if points != null:
		draw_polyline(points, Color.BLUE, 2, true)
