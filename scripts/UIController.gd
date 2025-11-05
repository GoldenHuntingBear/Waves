extends Control
class_name UIController

@onready var h_slider: HSlider = $VBoxContainer/HSlider
@onready var h_slider_2: HSlider = $VBoxContainer/HSlider2
signal updated(min_freq)
var old_sin_values = []


func _ready() -> void:
	h_slider.value_changed.connect(send_update)
	h_slider_2.value_changed.connect(send_update)
	h_slider.drag_started.connect(update_function)
	h_slider_2.drag_started.connect(update_function)


func update_function() -> void:
	old_sin_values = get_sin_values()


func get_sin_values() -> Array[SinWave]:
	var values: Array[SinWave] = []

	for slider in [h_slider, h_slider_2]:
		if slider:
			values.append(SinWave.new(100, slider.value/100))

	return values


func my_function(time: float, sin_waves: Array[SinWave]) -> float:
	var result = 0

	for sin_wave in sin_waves:
		result += sin_wave.amplitude*sin(2*PI*sin_wave.frequency*time)

	return result
	#return 100*sin(2*PI*h_slider.value/100*time) + 100*sin(2*PI*h_slider_2.value/100*time)


func send_update(value: bool):
	updated.emit(min(h_slider.value/100, h_slider_2.value/100))
