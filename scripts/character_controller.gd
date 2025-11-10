extends CharacterBody2D

@onready var wave_controller: WaveController = $"../WaveController"


func _physics_process(_delta: float) -> void:
	var new_y = 300.0 + wave_controller.get_y(wave_controller.x)
	position.y = new_y
	rotation = 8*PI*wave_controller.get_tangent(wave_controller.x)/180


func take_damage():
	print("taking damage")
	pass
