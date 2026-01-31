extends Resource
class_name Phase

@export var rewards: bool = true
@export var reward_time: Vector2 = Vector2(50, 200)
@export var obstacle_time: Vector2 = Vector2(4, 9)
@export var obstacle_size: Vector2 = Vector2(0.2, 0.6)


func get_reward_timer():
	return randf_range(reward_time.x, reward_time.y)


func get_obstacle_timer():
	return randf_range(obstacle_time.x, obstacle_time.y) * 100


func get_obstacle_size():
	return randf_range(obstacle_size.x, obstacle_size.y)
