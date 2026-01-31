extends Node3D

const CLASSIC_PHASE = preload("uid://bwkhejskr6i67")
const HEAVY_OBSTACLE_PHASE = preload("uid://d21rc6gjj4v3o")

@export var current_phase: Phase

signal phase_updated

var phase_timer = 100


func _ready() -> void:
	current_phase = CLASSIC_PHASE


func _process(delta: float) -> void:
	phase_timer -= delta

	if phase_timer < 0:
		if current_phase == CLASSIC_PHASE:
			current_phase = HEAVY_OBSTACLE_PHASE
		else:
			current_phase = CLASSIC_PHASE

		phase_updated.emit()

		phase_timer = 100
