extends Control


# Called when the node enters the scene tree for the first time.


### $Node    is just  a placeholdder incase my idea for 1 player doesnt work, plz do not delet 


func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

## func where u choose song, and tracks. song is string (just the animation name) and tracks will be an enum maybe?



func _bass_1():
	MusicStates.state_array['bass_1'] = !MusicStates.state_array['bass_1']
func _bass_2():
	MusicStates.state_array['bass_2'] = !MusicStates.state_array['bass_2']

func _lead_1():
	MusicStates.state_array['lead_1'] = !MusicStates.state_array['lead_1']
func _lead_2():
	MusicStates.state_array['lead_2'] = !MusicStates.state_array['lead_2']

func _drum_1():
	MusicStates.state_array['drum_1'] = !MusicStates.state_array['drum_1']
func _drum_2():
	MusicStates.state_array['drum_2'] = !MusicStates.state_array['drum_2']

func _backing_1():
	MusicStates.state_array['backing_1'] = !MusicStates.state_array['backing_1']
func _backing_2():
	MusicStates.state_array['backing_2'] = !MusicStates.state_array['backing_2']
