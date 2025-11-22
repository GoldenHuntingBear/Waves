extends Node3D
class_name RadioController

@onready var main_selector_area: Area3D = $MainSelectorArea
@onready var volume_selector_area: Area3D = $VolumeSelectorArea
@onready var main_selector: MeshInstance3D = $"Main selector"
@onready var volume_selector: MeshInstance3D = $"Volume selector"

var mouse_position
var selected_selector
var mouse_clicked: bool = false
var mouse_position_when_clicked
var in_area: bool = false
var starting_rotation: float = 0

signal updated(frequency)


func _ready() -> void:
	main_selector_area.mouse_entered.connect(func(): begin_selector_control(main_selector_area))
	main_selector_area.mouse_exited.connect(func(): end_selector_control(main_selector_area))

	volume_selector_area.mouse_entered.connect(func(): begin_selector_control(volume_selector_area))
	volume_selector_area.mouse_exited.connect(func(): end_selector_control(volume_selector_area))


func _process(_delta: float) -> void:
	mouse_position = get_viewport().get_mouse_position()

	if not in_area and not mouse_clicked:
		selected_selector = null
		return

	if not mouse_clicked:
		return

	if selected_selector and not mouse_position_when_clicked:
		mouse_position_when_clicked = mouse_position

	if selected_selector:
		var min_rotation
		var max_rotation
		if selected_selector == main_selector:
			min_rotation = -90
			max_rotation = 90
		else:
			min_rotation = -130
			max_rotation = 130

		var new_tried_rotation = (mouse_position.x - mouse_position_when_clicked.x) * 0.01 + starting_rotation
		var old_rotation = selected_selector.rotation.z
		var new_rotation = clamp(new_tried_rotation, deg_to_rad(min_rotation), deg_to_rad(max_rotation))
		selected_selector.rotation.z = new_rotation

		if abs(new_rotation - old_rotation) > 0.01:
			updated.emit(get_sin_wave().frequency)


func _input(event):
	# Mouse in viewport coordinates.
	if event is InputEventMouseButton and event.button_index == 1:
		mouse_clicked = event.pressed

		if not event.pressed:
			mouse_position_when_clicked = null


func begin_selector_control(selector: Area3D):
	#print("begin control %s" % selector)
	if selected_selector:
		return

	in_area = true

	if selector == main_selector_area:
		selected_selector = main_selector
	else:
		selected_selector = volume_selector

	starting_rotation = selected_selector.rotation.z


func end_selector_control(selector: Area3D):
	#print("end control %s" % selector)
	in_area = false

	if not mouse_clicked:
		selected_selector = null


func get_sin_wave() -> SinWave:
	var amplitude = change_max_min(rad_to_deg(volume_selector.rotation.z), -130, 130, 0, 100)
	var frequency = change_max_min(rad_to_deg(main_selector.rotation.z), -90, 90, 1, 3) / 1000
	#print(main_selector.rotation.z, " ", frequency)
	return SinWave.new(amplitude, frequency)


func change_max_min(value: float, old_min: float, old_max: float, new_min: float, new_max: float) -> float:
	var one_to_zero = (value - old_min) / (old_max - old_min)
	return one_to_zero * (new_max - new_min) + new_min
