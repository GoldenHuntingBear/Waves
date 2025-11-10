extends Area2D


func _ready() -> void:
	body_entered.connect(check_collision)


func check_collision(body: Node2D):
	if body.name == "Character":
		print("character collision")
		body.take_damage()
