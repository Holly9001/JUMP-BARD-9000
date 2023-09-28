extends Control

@onready var b_1_label :Label= $bass_1

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	
	b_1_label.text = str('bass_1: ',MusicStates.state_array['bass_1'])
