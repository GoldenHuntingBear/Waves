extends Node3D

@onready var blinds_switch: Node3D = $blinds_switch
@onready var blinds: Node3D = $Blinds
@onready var up_button: Area3D = $blinds_switch/UpButton
@onready var down_button: Area3D = $blinds_switch/DownButton

var mouse_position
var selected_button
var mouse_clicked: bool = false
var in_area: bool = false

const MAX_POSITION = 110
const MIN_POSITION = 80
const FREQUENCY = 10. / 1000

signal updated(frequency)


func _ready() -> void:
	up_button.mouse_entered.connect(func(): begin_button_pressed(up_button))
	up_button.mouse_exited.connect(end_button_pressed)

	down_button.mouse_entered.connect(func(): begin_button_pressed(down_button))
	down_button.mouse_exited.connect(end_button_pressed)


func _process(delta: float) -> void:
	mouse_position = get_viewport().get_mouse_position()

	if in_area and mouse_clicked:
		var direction = -1

		if selected_button == up_button:
			direction = 1

		blinds.position.y = clamp(blinds.position.y + direction * delta * 10, MIN_POSITION, MAX_POSITION)
		updated.emit(FREQUENCY)


func _input(event):
	# Mouse in viewport coordinates.
	if event is InputEventMouseButton and event.button_index == 1:
		mouse_clicked = event.pressed


func begin_button_pressed(button: Area3D):
	#print("begin control %s" % button)
	Input.set_default_cursor_shape(Input.CURSOR_POINTING_HAND)

	in_area = true

	if button == up_button:
		selected_button = up_button
	else:
		selected_button = down_button


func end_button_pressed():
	Input.set_default_cursor_shape(Input.CURSOR_ARROW)
	in_area = false
	selected_button = null


func get_sin_wave() -> SinWave:
	var amplitude = change_max_min(blinds.position.y, MIN_POSITION, MAX_POSITION, 0, 100)
	#print(main_selector.rotation.z, " ", frequency)
	return SinWave.new(amplitude, FREQUENCY)


func change_max_min(value: float, old_min: float, old_max: float, new_min: float, new_max: float) -> float:
	var one_to_zero = (value - old_min) / (old_max - old_min)
	return one_to_zero * (new_max - new_min) + new_min
