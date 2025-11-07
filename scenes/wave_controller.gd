extends Node2D

@onready var active_wave: Path2D = $ActiveWave
@onready var future_wave: Path2D = $FutureWave
@onready var transition_wave: Path2D = $TransitionWave

@onready var ui_controller: UIController = $"../Control"

@export var speed: float = 10
@export var transition_time: float = 10

var wave_collections: Array[SinWaveCollection] = []


func _ready() -> void:
	ui_controller.updated.connect(update_wave_collections)
	ui_controller.updated.connect(setup_future_wave)
	setup_future_wave(0.1)
	future_wave.position.x += transition_time * speed


func _process(delta: float) -> void:
	active_wave_update(delta)
	setup_future_wave(0.1)
	setup_transition_wave()


func now() -> float:
	return speed*Time.get_ticks_msec()/1000


func active_wave_update(delta: float) -> void:
	if len(wave_collections) == 0:
		update_wave_collections(0)

	transition(delta)
	active_wave.position.x -= speed*delta
	var value = now()
	var y = get_y(value)

	active_wave.curve.add_point(Vector2(value, y))
	if active_wave.curve.point_count >= 500:
		active_wave.curve.remove_point(0)

	active_wave.queue_redraw()


func get_y(time: float) -> float:
	var result = 0

	for collection in wave_collections:
		result += collection.function(time)

	return result


func update_wave_collections(_min_freq: float):
	if len(wave_collections) == 0:
		wave_collections.append(ui_controller.get_wave_collection())
		return

	if len(wave_collections) == 2:
		var new_first_collection = wave_collections[0].change_amplitude(1)
		new_first_collection.add(wave_collections[1])
		wave_collections[0] = new_first_collection
		wave_collections[1] = SinWaveCollection.new(0, ui_controller.get_sin_waves())
	else:
		wave_collections.append(SinWaveCollection.new(0, ui_controller.get_sin_waves()))


func transition(delta: float) -> void:
	if len(wave_collections) <= 1:
		return

	wave_collections[0].amplitude -= delta / transition_time
	wave_collections[1].amplitude += delta / transition_time

	if wave_collections[1].amplitude > 1:
		wave_collections[1].amplitude = 1

	if wave_collections[0].amplitude < 0.01:
		wave_collections.remove_at(0)

	# remove too small waves from [0]


func setup_future_wave(min_freq: float) -> void:
	future_wave.curve.clear_points()
	var max_points = min(round(100/min_freq), 10000)

	var value = now() + transition_time * speed

	print("future from %d to %d" % [value, value + max_points])
	for t in range(value, value + max_points):
		var new_point = Vector2(
			t-value,
			ui_controller.get_wave_collection().function(t)
		)
		future_wave.curve.add_point(new_point)

	future_wave.queue_redraw()


func setup_transition_wave() -> void:
	transition_wave.curve.clear_points()
	var value = now()

	print("transition from %d to %d" % [value, value + transition_time * speed])
	for t in range(value, value + transition_time * speed + 1):
		var new_point = Vector2(t-value, get_y(t))
		transition_wave.curve.add_point(new_point)

	transition_wave.queue_redraw()
