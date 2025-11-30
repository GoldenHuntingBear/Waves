extends Node2D
class_name WaveController

@onready var active_wave: Path2D = $ActiveWave
@onready var future_wave: Path2D = $FutureWave
@onready var transition_wave: Path2D = $TransitionWave

@onready var input_controller: InputController = $"../../Control"

const START_SPEED = 10
@export var speed: float = START_SPEED
@export var transition_time: float = 12
@export var wave_factor_threshold = 0.05
@export var debug: bool = false

var wave_collections: Array[SinWaveCollection] = []

var x: float = 0

var running: bool = true


func _ready() -> void:
	active_wave.curve.clear_points()
	future_wave.curve.clear_points()
	transition_wave.curve.clear_points()
	input_controller.updated.connect(update_wave_collections)
	#ui_controller.updated.connect(setup_future_wave)
	setup_future_wave(0.1)
	future_wave.position.x += transition_time * speed


func _process(delta: float) -> void:
	if not running:
		return

	if debug:
		print(wave_collections[0].to_str())

	x += delta * speed
	active_wave_update(delta)
	setup_future_wave(0.1)
	setup_transition_wave(delta)
	check_wave_collection()
	speed += delta * 1.5


func active_wave_update(delta: float) -> void:
	if len(wave_collections) == 0:
		update_wave_collections()

	active_wave.position.x -= speed*delta
	var num_points = round(speed / 10)
	var step = delta*speed / num_points

	for i in range(num_points-1, -1, -1):
		var value = x - step * i
		var y = get_y(value)
		active_wave.curve.add_point(Vector2(value, y))

	if active_wave.curve.point_count >= 500:
		for i in range(200):
			active_wave.curve.remove_point(i)

	active_wave.queue_redraw()


func get_y(time: float, debug: bool = false) -> float:
	if len(wave_collections) == 0:
		return 0

	if len(wave_collections) < 2:
		return wave_collections[0].function(time)

	var result = 0
	var first_collection = wave_collections[0]
	var second_collection = wave_collections[1]

	result += first_collection.function(time, -1, debug)
	result += second_collection.function(time, 1)

	return result


func get_tangent(time: float) -> float:
	if len(wave_collections) == 0:
		return 0

	if len(wave_collections) < 2:
		return wave_collections[0].tangent(time)

	var result = 0
	result += wave_collections[0].tangent(time, -1)
	result += wave_collections[1].tangent(time, 1)
	return result


func update_wave_collections():
	var time = x
	#print("updating wave collections with time %f" % time)

	if len(wave_collections) == 0:
		wave_collections.append(input_controller.get_wave_collection(time))
		return

	var new_collection = SinWaveCollection.new(1, input_controller.get_sin_waves(), time)

	if len(wave_collections) == 2:
		#print("updating wave collections with time %f" % time)

		wave_collections[1].switch_to_diminishing(time)
		wave_collections[0].add(wave_collections[1])

		wave_collections[1] = new_collection
	else:
		wave_collections[0].change_start_times(time)
		new_collection.change_start_times(time)
		wave_collections.append(new_collection)


func check_wave_collection() -> void:
	var time = x

	if len(wave_collections) < 2:
		return

	wave_collections[0].check_delete_waves(time-200)
	if len(wave_collections[0].waves) == 0:
		wave_collections.remove_at(0)


func setup_future_wave(min_freq: float) -> void:
	if debug:
		print("future: " + input_controller.get_wave_collection(0).to_str())

	future_wave.curve.clear_points()
	var size = 1000.
	var num_points = 200
	var step = size / num_points

	for t in range(num_points):
		var future_x = t * step + x + transition_time * START_SPEED
		var new_point = Vector2(t*step, input_controller.get_wave_collection(future_x).function(future_x))
		future_wave.curve.add_point(new_point)

	future_wave.queue_redraw()


func setup_transition_wave(_delta: float) -> void:
	transition_wave.curve.clear_points()
	var time = x
	const num_points = 20
	var step = transition_time * START_SPEED / num_points
	#print("transition starts at %f" % (value))

	for n in range(num_points):
		var transition_x = step * n
		var new_point = Vector2(transition_x, get_y(transition_x + time))
		transition_wave.curve.add_point(new_point)

	var last_transition_x = transition_time * START_SPEED
	var last_point = Vector2(last_transition_x, future_wave.curve.get_point_position(0).y)
	transition_wave.curve.add_point(last_point)
	transition_wave.queue_redraw()


func get_spline(center_x: float, center_y: float, collection: SinWaveCollection, size: float) -> Vector2:
	var slope = -collection.tangent(center_x)
	var b = center_y - slope * center_x
	var y = slope * (center_x - size) + b
	var spline = Vector2(size, y-center_y)
	return spline
