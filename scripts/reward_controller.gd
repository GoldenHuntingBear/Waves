extends Node2D
class_name RewardController

@export var coin_scene: PackedScene
@onready var timer: Timer = $Timer
@onready var rewards_parent: Node2D = $Rewards
@onready var wave_controller: WaveController = $"../WaveController"

const REWARD_MIN_TIME: float = 3
const REWARD_MAX_TIME: float = 4# 10


func _ready() -> void:
	timer.timeout.connect(spawn_reward)
	spawn_reward()


func _process(delta: float) -> void:
	move_rewards(delta)
	check_positions()


func spawn_reward():
	var coin: Node2D = coin_scene.instantiate()
	rewards_parent.add_child(coin)
	coin.position.y = randf_range(-640 + 100, 640 - 100)
	reset_timer()


func reset_timer():
	timer.wait_time = randf_range(REWARD_MIN_TIME, REWARD_MAX_TIME)
	timer.start()


func move_rewards(delta: float):
	for reward in rewards_parent.get_children():
		reward.position.x -= delta * wave_controller.speed


func check_positions():
	if not rewards_parent.get_children():
		return

	var first_child = rewards_parent.get_children()[0]

	if first_child.global_position.x < -20:
		first_child.queue_free()
