extends Node3D

@onready var moving_spike = $Path3D/checkpoint_moving_platform

# Called when the node enters the scene tree for the first time.
func _ready():
	MusicStates.on_beat.connect(handle_on_beat)
	
func handle_on_beat(type):
	if type == "drum_1":
		moving_spike.progress_ratio = 0.0
		moving_spike.enabled = true
