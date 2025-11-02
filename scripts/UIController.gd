extends Control
class_name UIController

@onready var h_slider: HSlider = $VBoxContainer/HSlider
@onready var h_slider_2: HSlider = $VBoxContainer/HSlider2
signal updated(min_freq)

func _ready() -> void:
	h_slider.value_changed.connect(send_update)
	h_slider_2.value_changed.connect(send_update)
	

func my_function(time: float) -> float:
	if not h_slider:
		print("no slider")
		return 0
	return 100*sin(2*PI*h_slider.value/100*time) + 100*sin(2*PI*h_slider_2.value/100*time)

func send_update(value: bool):
	updated.emit(min(h_slider.value/100, h_slider_2.value/100))
