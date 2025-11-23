extends Control
class_name UIController

@onready var h_slider: HSlider = $VBoxContainer/HSlider
@onready var h_slider_2: HSlider = $VBoxContainer/HSlider2
@onready var radio: RadioController = $"../radio"
@onready var sun_control: Node3D = $"../SunControl"

signal updated(min_freq)


func _ready() -> void:
	h_slider.value_changed.connect(send_update)
	h_slider_2.value_changed.connect(send_update)
	radio.updated.connect(send_update)
	sun_control.updated.connect(send_update)


func get_sin_waves() -> Array[SinWave]:
	var values: Array[SinWave] = []

	for slider in [h_slider, h_slider_2]:
		if slider:
			values.append(SinWave.new(100, slider.value/100))

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

	for frequency in [h_slider.value/100, h_slider_2.value/100, radio.get_sin_wave().frequency]:
		if frequency > 0 and frequency < min_frequency:
			min_frequency = frequency

	updated.emit(min_frequency)
