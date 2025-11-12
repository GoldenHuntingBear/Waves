extends CharacterBody2D

@onready var wave_controller: WaveController = $"../WaveController"
var score: int = 0


func _physics_process(_delta: float) -> void:
	var new_y = 300.0 + wave_controller.get_y(wave_controller.x)
	position.y = new_y
	#print(wave_controller.get_tangent(wave_controller.x))
	rotation = deg_to_rad(wave_controller.get_tangent(wave_controller.x)*45)


func take_damage():
	print("taking damage")
	pass


func add_score(amount: int):
	score += amount
	print("New score: %d" % score)
