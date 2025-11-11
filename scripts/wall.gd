extends Area2D
class_name Wall

@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
@onready var sprite_2d: Sprite2D = $Sprite2D
var screen_size: Vector2 = Vector2(1280, 720)


func _ready() -> void:
	body_entered.connect(check_collision)


func check_collision(body: Node2D):
	if body.name == "Character":
		print("character collision")
		body.take_damage()


func size_and_position_setup():
	var previous_size = collision_shape_2d.scale.y * 225
	var size = randf_range(0.1, 0.5) * screen_size.y / previous_size
	scale.y *= size
	var place = ["top", "bottom"].pick_random()

	if place == "top":
		position.y = size * previous_size/2
	else:
		position.y = screen_size.y - size * previous_size / 2
