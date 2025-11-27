extends Control
class_name UIController

@export var heart_sprite: CompressedTexture2D
@onready var hearts_container: HBoxContainer = $Panel/MarginContainer/VBoxContainer/HeartsContainer
@onready var score: Label = $Panel/MarginContainer/VBoxContainer/HBoxContainer/Score

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
		new_sprite.custom_minimum_size = Vector2(100, 100)
		new_sprite.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
		hearts_container.add_child(new_sprite)


func update_score(score_amount: int):
	score.text = str(score_amount)
