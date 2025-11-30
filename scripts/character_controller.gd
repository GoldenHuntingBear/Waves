extends CharacterBody2D

@onready var wave_controller: WaveController = $"../WaveController"
@onready var ui_controller: UIController = $"../../UI/UIController"

var score: int = 0


func _physics_process(_delta: float) -> void:
	var new_y = 360.0 + wave_controller.get_y(wave_controller.x)
	position.y = new_y

	#if len(wave_controller.wave_collections) < 1:
		#return
#
	#var center = Vector2(wave_controller.x, wave_controller.get_y(wave_controller.x))
	#var spline = wave_controller.get_spline(center.x, center.y, wave_controller.wave_collections[0], 20)
	#rotation = -(spline + center).angle_to(center)


func take_damage():
	print("taking damage")
	ui_controller.take_damage(1)


func add_score(amount: int):
	score += amount
	print("New score: %d" % score)
	ui_controller.update_score(score)
