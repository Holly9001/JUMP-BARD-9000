extends Node3D

const SWITCH_TIME = 1.5

var child_collisions
var children
var time_until_switch = SWITCH_TIME

func _ready():
	child_collisions = get_children_of_type(self, "CollisionShape3D")
	children = get_children()

func _process(delta):
	# this won't be happening here once the music works. it's just a timer to test
	time_until_switch -= delta
	# below code will check the music status singleton instead
	if time_until_switch < 0:
		time_until_switch = SWITCH_TIME
		
		for i in child_collisions:
			i.disabled = !i.disabled
		
		for i in children:
			i.visible = !i.visible

func get_children_of_type(in_node, type, arr:=[]):
	if in_node.get_class() == type:
		arr.push_back(in_node)
	for child in in_node.get_children():
		arr = get_children_of_type(child, type, arr)
	return arr
