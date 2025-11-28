extends Control
class_name UIController

@export var heart_sprite: CompressedTexture2D
@onready var hearts_container: HBoxContainer = $Panel/MarginContainer/VBoxContainer/HeartsContainer
@onready var score: Label = $Panel/MarginContainer/VBoxContainer/Control/Score
@onready var end_screen: Control = $"../../EndScreen"
@onready var wave_controller: WaveController = $"../../SubViewport/WaveController"
@onready var restart_button: Button = $"../../EndScreen/Panel/VBoxContainer/RestartButton"

var health = 3


func _ready() -> void:
	restart_button.pressed.connect(restart_game)
	update_health_display()


func take_damage(amount: int):
	health -= amount
	update_health_display()

	if health <= 0:
		end_screen.visible = true
		wave_controller.running = false
		return


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
	score.position.x = 231


func restart_game():
	get_tree().reload_current_scene()
