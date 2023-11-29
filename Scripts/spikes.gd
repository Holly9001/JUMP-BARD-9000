extends Node3D

@onready var mesh = $"../Cube"

const ROTATION_SPEED = 10

# Called when the node enters the scene tree for the first time.
func trigger():
	GameState.restart()

func _process(delta):
	mesh.rotate_z(ROTATION_SPEED * delta)
