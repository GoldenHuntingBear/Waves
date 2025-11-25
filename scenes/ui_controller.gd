extends Control
class_name UIController

@export var heart_sprite: CompressedTexture2D
@onready var hearts_container: HBoxContainer = $HeartsContainer

var health = 3


func _ready() -> void:
	update_health_display()


func take_damage(amount: int):
	health -= amount
	update_health_display()


func update_health_display():
	for child in hearts_container.get_children():
		hearts_container.remove_child(child)

	for h in health:
		var new_sprite = TextureRect.new()
		new_sprite.texture = heart_sprite
		hearts_container.add_child(new_sprite)
