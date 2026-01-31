extends Node2D
class_name RewardController

@export var coin_scene: PackedScene
@onready var rewards_parent: Node2D = $Rewards
@onready var wave_controller: WaveController = $"../WaveController"

var timer = 1000


func _ready() -> void:
	spawn_reward()


func _process(delta: float) -> void:
	if not wave_controller.running:
		return

	move_rewards(delta)
	check_positions()
	if GameController.current_phase.rewards:
		timer -= delta * wave_controller.speed

	if timer < 0:
		spawn_reward()


func spawn_reward():
	var coin: Node2D = coin_scene.instantiate()
	rewards_parent.add_child(coin)
	coin.position.y = randf_range(-250, 250)
	reset_timer()


func reset_timer():
	timer = GameController.current_phase.get_reward_timer()


func move_rewards(delta: float):
	for reward in rewards_parent.get_children():
		reward.position.x -= delta * wave_controller.speed


func check_positions():
	if not rewards_parent.get_children():
		return

	var first_child = rewards_parent.get_children()[0]

	if first_child.global_position.x < -20:
		first_child.queue_free()
