extends CharacterBody2D

@onready var wave_controller: WaveController = $"../WaveController"
@onready var ui_controller: UIController = $"../../UI/UIController"

var score: int = 0


func _physics_process(_delta: float) -> void:
	var new_y = 360.0 + wave_controller.get_y(wave_controller.x)
	position.y = new_y
	rotation = wave_controller.get_tangent(wave_controller.x)


func take_damage():
	ui_controller.take_damage(1)


func add_score(amount: int):
	score += amount
	ui_controller.update_score(score)
