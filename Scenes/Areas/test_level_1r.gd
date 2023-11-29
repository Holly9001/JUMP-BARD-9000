extends Node3D

@export var moving_spikes: Array[Node3D]

func _ready():
	MusicStates.on_beat.connect(handle_on_beat)
	
func handle_on_beat(type):
	if type == "drum_1":
		for i in moving_spikes:
			i.progress_ratio = 0.0
			i.enabled = true
