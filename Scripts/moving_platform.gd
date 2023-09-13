extends Node3D

@export var MOVE_SPEED:float

const SWITCH_TIME = 4

var targets = []
var time_until_switch = SWITCH_TIME
var target_position:Vector3

@onready var platform = $platform

# again, time_until_switch and switch time just create a fake rythym
# they should be replaced once the music state is implemented

func _ready():
	for i in self.get_children():
		if i.get_class() == "Marker3D":
			targets.push_front(i)
	target_position = targets[targets.size() - 1].position

func _process(delta):

	time_until_switch -= delta
	if time_until_switch < 0:
		time_until_switch = SWITCH_TIME
		var temp_marker:Node3D = targets.pop_front()
		targets.push_back(temp_marker)
		target_position = temp_marker.position
	
	platform.position = platform.position.move_toward(target_position, MOVE_SPEED * delta)
