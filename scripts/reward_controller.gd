extends Node2D
class_name RewardController

@export var coin_scene: PackedScene
@onready var rewards_parent: Node2D = $Rewards
@onready var wave_controller: WaveController = $"../WaveController"

const REWARD_MIN_TIME: float = 50
const REWARD_MAX_TIME: float = 200

var timer = 1000


func _ready() -> void:
	spawn_reward()


func _process(delta: float) -> void:
	move_rewards(delta)
	check_positions()
	timer -= delta * wave_controller.speed

	if timer < 0:
		spawn_reward()


func spawn_reward():
	var coin: Node2D = coin_scene.instantiate()
	rewards_parent.add_child(coin)
	coin.position.y = randf_range(-640 + 150, 640 - 150)
	reset_timer()


func reset_timer():
	timer = randf_range(REWARD_MIN_TIME, REWARD_MAX_TIME)


func move_rewards(delta: float):
	for reward in rewards_parent.get_children():
		reward.position.x -= delta * wave_controller.speed


func check_positions():
	if not rewards_parent.get_children():
		return

	var first_child = rewards_parent.get_children()[0]

	if first_child.global_position.x < -20:
		first_child.queue_free()
