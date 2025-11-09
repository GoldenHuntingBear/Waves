extends Node2D

@onready var body: Sprite2D = $Body
@onready var wave_controller: WaveController = $"../WaveController"


func _process(_delta: float) -> void:
	body.position.y = wave_controller.get_y(wave_controller.x)
	#print(wave_controller.get_tangent(wave_controller.x))
	body.rotation = 4*PI*wave_controller.get_tangent(wave_controller.x)/180
