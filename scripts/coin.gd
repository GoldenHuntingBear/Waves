extends Area2D
class_name Coin

@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
var screen_size: Vector2 = Vector2(1280, 720)


func _ready() -> void:
	body_entered.connect(check_collision)


func check_collision(body: Node2D):
	if body.name == "Character":
		print("character collision")
		body.add_score(1)
		queue_free()
