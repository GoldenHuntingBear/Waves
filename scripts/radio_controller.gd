extends Node3D
class_name RadioController

@onready var main_selector: RotationSelector = $MainSelectorArea
@onready var volume_selector: RotationSelector = $VolumeSelectorArea

signal updated


func _ready() -> void:
	main_selector.updated.connect(updated.emit)
	volume_selector.updated.connect(updated.emit)

	if not main_selector.selected and not main_selector.in_area and not volume_selector.selected and not volume_selector.in_area:
		Input.set_default_cursor_shape(Input.CURSOR_ARROW)


func _process(_delta: float) -> void:
	volume_selector.can_be_controlled = not main_selector.selected
	main_selector.can_be_controlled = not volume_selector.selected


func get_sin_wave() -> SinWave:
	var amplitude = change_max_min(rad_to_deg(volume_selector.angle), -130, 130, 0, 200)
	var frequency = change_max_min(rad_to_deg(main_selector.angle), -90, 90, 0.5, 2) / 1000
	#print(main_selector.rotation.z, " ", frequency)
	return SinWave.new(amplitude, frequency)


func change_max_min(value: float, old_min: float, old_max: float, new_min: float, new_max: float) -> float:
	var one_to_zero = (value - old_min) / (old_max - old_min)
	return one_to_zero * (new_max - new_min) + new_min
