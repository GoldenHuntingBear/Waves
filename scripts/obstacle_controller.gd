extends Node2D
class_name ObstacleController

@export var obs_scene: PackedScene
@onready var wave_controller: WaveController = $"../WaveController"
@onready var timer: Timer = $Timer
@onready var spawn_position_default: Node2D = $SpawnPositionDefault
@onready var obs_parent: Node2D = $Obstacles

const OBSTACLE_MIN_TIME: float = 10
const OBSTACLE_MAX_TIME: float = 100


func _ready() -> void:
	timer.timeout.connect(spawn_obs)
	spawn_obs()


func _process(delta: float) -> void:
	move_obstacles(delta)


func spawn_obs():
	print("spawing")
	var obs = obs_scene.instantiate()
	obs.position = spawn_position_default.position
	obs_parent.add_child(obs)
	obs.size_and_position_setup()
	reset_timer()


func reset_timer():
	print("reset timer")
	timer.wait_time = randf_range(OBSTACLE_MIN_TIME, OBSTACLE_MAX_TIME) # / wave_controller.speed
	timer.start()


func move_obstacles(delta: float):
	for obs in obs_parent.get_children():
		obs.position.x -= delta * wave_controller.speed
