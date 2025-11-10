extends CharacterBody2D

@onready var wave_controller: WaveController = $"../WaveController"


func _physics_process(delta: float) -> void:
	var new_y = 300.0 + wave_controller.get_y(wave_controller.x)
	position.y = new_y
	rotation = 8*PI*wave_controller.get_tangent(wave_controller.x)/180
	#var collision_info = move_and_collide(Vector2(position.x, new_y))
#
	#if collision_info:
		#print(collision_info)


func take_damage():
	print("taking damage")
	pass
