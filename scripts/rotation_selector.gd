extends Node3D
class_name RotationSelector

@export var min_rotation: float
@export var max_rotation: float
@export var area: Area3D
@export var mesh_to_rotate: MeshInstance3D
@export var debug: bool = false

var can_be_controlled: bool = true
var mouse_clicked: bool = false
var mouse_position_when_clicked
var starting_rotation: float
var in_area: bool = false
var selected: bool = false
var angle

signal updated


func _ready() -> void:
	area.mouse_entered.connect(begin_selector_control)
	area.mouse_exited.connect(end_selector_control)


func _process(_delta: float) -> void:
	angle = mesh_to_rotate.rotation.z

	if debug:
		pass

	if in_area and mouse_clicked:
		if not selected:
			starting_rotation = mesh_to_rotate.rotation.z

		selected = true

	if not mouse_clicked:
		selected = false

	if selected or in_area:
		Input.set_default_cursor_shape(Input.CURSOR_HSIZE)

	if not can_be_controlled or not selected:
		return

	var mouse_position = get_viewport().get_mouse_position()
	#print("mouse not in area and not clicked (in process), resetting selector")

	var new_tried_rotation = (mouse_position.x - mouse_position_when_clicked.x) * 0.01 + starting_rotation
	var old_rotation = mesh_to_rotate.rotation.z
	var new_rotation = clamp(new_tried_rotation, deg_to_rad(min_rotation), deg_to_rad(max_rotation))

	if abs(old_rotation - new_rotation) > 0.001:
		if debug:
			print("Updating rotation to %f" % new_rotation)

		mesh_to_rotate.rotation.z = new_rotation
		updated.emit()


func _input(event):
	# Mouse in viewport coordinates.
	if event is InputEventMouseButton and event.button_index == 1:
		if in_area and event.pressed:
			mouse_position_when_clicked = get_viewport().get_mouse_position()
			mouse_clicked = true

		if not event.pressed:
			mouse_clicked = false


func begin_selector_control():
	#print("begin control %s" % selector)
	Input.set_default_cursor_shape(Input.CURSOR_HSIZE)
	in_area = true


func end_selector_control():
	#print("end control %s" % selector)
	in_area = false

	if not mouse_clicked:
		Input.set_default_cursor_shape(Input.CURSOR_ARROW)
