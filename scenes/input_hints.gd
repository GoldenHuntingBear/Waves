extends Node3D

@onready var blinds_up: Label3D = $blinds_up
@onready var blinds_down: Label3D = $blinds_down
@onready var radio_frequency_up: Label3D = $radio_frequency_up
@onready var radio_frequency_down: Label3D = $radio_frequency_down


func _ready() -> void:
	blinds_up.text = action_to_unicode("blinds_up")
	blinds_down.text = action_to_unicode("blinds_down")
	radio_frequency_up.text = action_to_unicode("radio_frequency_up")
	radio_frequency_down.text = action_to_unicode("radio_frequency_down")


func action_to_unicode(action_name: String) -> String:
	var event = InputMap.action_get_events(action_name)[0]
	return OS.get_keycode_string(event.unicode).to_upper()
