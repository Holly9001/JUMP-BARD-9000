extends Node3D

@export var beat_type : String

@export var beat_interval : int

var interval_count = 0

var temp_beat : bool

var children : Array

# Called when the node enters the scene tree for the first time.
func _ready():
	for i in get_child_count():
		children[i] = get_child(i)
	
	temp_beat = MusicStates[beat_type]


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	
	if MusicStates[beat_type] != temp_beat:
		interval_count += 1
		
		if interval_count >= beat_interval:
			_beat_action()
		
		temp_beat = MusicStates[beat_type]

func _beat_action():
	print('d-d-d-dd dddjjj sorrowww, laughing all the way to helllll')
