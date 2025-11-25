extends Node3D
class_name InputController

@onready var radio: RadioController = $"../radio"
@onready var sun_control: Node3D = $"../SunControl"

signal updated(min_freq)


func _ready() -> void:
	radio.updated.connect(send_update)
	sun_control.updated.connect(send_update)


func get_sin_waves() -> Array[SinWave]:
	var values: Array[SinWave] = []

	if radio:
		values.append(radio.get_sin_wave())

	if sun_control:
		values.append(sun_control.get_sin_wave())

	return values


func get_wave_collection(start_time: float) -> SinWaveCollection:
	return SinWaveCollection.new(1, get_sin_waves(), start_time)


func send_update(value: bool):
	#print("send update")
	var min_frequency = 10000

	for frequency in [radio.get_sin_wave().frequency, sun_control.get_sin_wave().frequency]:
		if frequency > 0 and frequency < min_frequency:
			min_frequency = frequency

	updated.emit(min_frequency)
