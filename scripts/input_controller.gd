extends Node3D
class_name InputController

@onready var radio: RadioController = $"../radio"
@onready var sun_control: Node3D = $"../SunControl"

signal updated


func _ready() -> void:
	radio.updated.connect(updated.emit)
	sun_control.updated.connect(updated.emit)


func get_sin_waves() -> Array[SinWave]:
	var values: Array[SinWave] = []

	if radio:
		values.append(radio.get_sin_wave())

	if sun_control:
		values.append(sun_control.get_sin_wave())

	return values


func get_wave_collection(start_time: float) -> SinWaveCollection:
	return SinWaveCollection.new(1, get_sin_waves(), start_time)
