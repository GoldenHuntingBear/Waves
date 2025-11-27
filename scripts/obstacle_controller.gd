extends Node2D
class_name ObstacleController

@export var obs_scene: PackedScene
@onready var wave_controller: WaveController = $"../WaveController"
@onready var spawn_position_default: Node2D = $SpawnPositionDefault
@onready var obs_parent: Node2D = $Obstacles

const OBSTACLE_MIN_TIME: float = 400
const OBSTACLE_MAX_TIME: float = 900

var timer = 10000


func _ready() -> void:
	spawn_obs()


func _process(delta: float) -> void:
	move_obstacles(delta)
	check_positions()
	timer -= delta * wave_controller.speed

	if timer < 0:
		spawn_obs()


func spawn_obs():
	var obs = obs_scene.instantiate()
	obs.position = spawn_position_default.position
	obs_parent.add_child(obs)
	obs.size_and_position_setup()
	reset_timer()


func reset_timer():
	timer = randf_range(OBSTACLE_MIN_TIME, OBSTACLE_MAX_TIME) #/ wave_controller.speed


func move_obstacles(delta: float):
	for obs in obs_parent.get_children():
		obs.position.x -= delta * wave_controller.speed


func check_positions():
	if not obs_parent.get_children():
		return

	var first_child = obs_parent.get_children()[0]

	if first_child.position.x < -20:
		first_child.queue_free()
