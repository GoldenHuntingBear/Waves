extends Node2D
class_name WaveController

@onready var active_wave: Path2D = $ActiveWave
@onready var future_wave: Path2D = $FutureWave
@onready var transition_wave: Path2D = $TransitionWave

@onready var ui_controller: InputController = $"../../Control"

const START_SPEED = 10
@export var speed: float = START_SPEED
@export var transition_time: float = 10
@export var wave_factor_threshold = 0.05

var wave_collections: Array[SinWaveCollection] = []

var x: float = 0


func _ready() -> void:
	ui_controller.updated.connect(update_wave_collections)
	#ui_controller.updated.connect(setup_future_wave)
	setup_future_wave(0.1)
	future_wave.position.x += transition_time * speed


func _process(delta: float) -> void:
	x += delta * speed
	setup_transition_wave(delta)
	active_wave_update(delta)
	setup_future_wave(0.1)
	check_wave_collection()
	speed += delta * 10


func active_wave_update(delta: float) -> void:
	if len(wave_collections) == 0:
		update_wave_collections(0)

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

	#if debug:
		#if not diminishing_wave_factor(time, first_collection.start_time) == 0.0:
			#print(time, " ", diminishing_wave_factor(time, first_collection.start_time), " ", first_collection.start_time, " ", augmenting_wave_factor(time, second_collection.start_time))
			#pass

	result += first_collection.function(time, debug) * diminishing_wave_factor(time, first_collection.start_time)
	result += second_collection.function(time) * augmenting_wave_factor(time, second_collection.start_time)

	return result


func get_tangent(time: float) -> float:
	if len(wave_collections) == 0:
		return 0

	if len(wave_collections) < 2:
		return wave_collections[0].tangent(time)

	var result = 0
	var first_collection = wave_collections[0]
	var second_collection = wave_collections[1]

	result += first_collection.tangent(time) * diminishing_wave_factor(time, first_collection.start_time)
	result += second_collection.tangent(time) * augmenting_wave_factor(time, second_collection.start_time)
	return result


func update_wave_collections(_min_freq: float):
	var time = x
	#print("updating wave collections with time %f" % time)

	if len(wave_collections) == 0:
		wave_collections.append(ui_controller.get_wave_collection(time))
		return

	var new_collection = SinWaveCollection.new(1, ui_controller.get_sin_waves(), time)

	if len(wave_collections) == 2:
		var first_wave_factor = diminishing_wave_factor(time, wave_collections[0].start_time)
		var new_first_collection = wave_collections[0].change_amplitude(first_wave_factor, time)
		var second_wave_factor = augmenting_wave_factor(time, wave_collections[1].start_time)
		#print(wave_collections[0].amplitude, " ",first_wave_factor, " ", new_first_collection.amplitude)

		if second_wave_factor > wave_factor_threshold:
			new_first_collection.add(wave_collections[1].change_amplitude(second_wave_factor, time))

		wave_collections[0] = new_first_collection
		wave_collections[1] = new_collection
	else:
		wave_collections[0].start_time = time
		wave_collections.append(new_collection)


func diminishing_wave_factor(time: float, start_time: float) -> float:
	if time < start_time:
		return 1

	var transition = transition_time * START_SPEED
	var value = time/transition - start_time/transition

	return max(-value + 1, 0)
	#return cos(PI/2 * min(value, 1))


func augmenting_wave_factor(time: float, start_time: float) -> float:
	if time < start_time:
		return 0

	var transition = transition_time * START_SPEED
	var value = time/transition - start_time/transition

	return min(value, 1)
	#return sin(PI/2 * min(value, 1))


func check_wave_collection() -> void:
	if len(wave_collections) < 2:
		return

	var time = x

	var wave_factor = diminishing_wave_factor(time, wave_collections[0].start_time)

	if wave_factor == 0.0:
		#print("deleting first wave collection")
		wave_collections.remove_at(0)
		return

	for wave in wave_collections[0].waves:
		if wave_factor * wave.amplitude < wave_factor_threshold * 10:
			#print("removing a wave")
			wave_collections[0].waves.erase(wave)

		#print(wave_factor * wave.amplitude)


func setup_future_wave(min_freq: float) -> void:
	future_wave.curve.clear_points()

	for t in range(2000):
		var future_x = t + x + transition_time * START_SPEED
		var new_point = Vector2(
			t,
			ui_controller.get_wave_collection(future_x).function(future_x)
		)
		future_wave.curve.add_point(new_point)

	future_wave.queue_redraw()


func setup_transition_wave(delta: float) -> void:
	transition_wave.curve.clear_points()
	var time = x
	var value = 0
	#print("transition starts at %f" % (value))

	while value <= transition_time * START_SPEED:
		var new_point = Vector2(value, get_y(value + time))
		transition_wave.curve.add_point(new_point)
		value += delta

	transition_wave.queue_redraw()


func transition_wave_splines():
	transition_wave.curve.clear_points()

	if len(wave_collections) == 0:
		return

	var second_collection
	if len(wave_collections) == 1:
		second_collection = wave_collections[0]
	else:
		second_collection = wave_collections[1]

	var y = get_y(x)
	var first_point = Vector2(0, y)
	var first_spline = get_spline(x, y, wave_collections[0], 30)
	transition_wave.curve.add_point(first_point, -first_spline, first_spline)

	var new_x = x + transition_time * speed
	var second_point = Vector2(new_x-x, second_collection.function(new_x))
	var second_spline = get_spline(new_x, second_collection.function(new_x), second_collection, 30)
	transition_wave.curve.add_point(second_point, -second_spline, second_spline)

	transition_wave.queue_redraw()


func get_spline(center_x: float, center_y: float, collection: SinWaveCollection, size: float) -> Vector2:
	var slope = -collection.tangent(center_x)
	var b = center_y - slope * center_x
	var y = slope * (center_x - size) + b
	var spline = Vector2(size, y-center_y)
	return spline
