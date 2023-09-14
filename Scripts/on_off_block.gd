extends Node3D

const SWITCH_TIME = 1.5

var child_collisions
var children
var prev_base_state = false

func _ready():
	child_collisions = get_children_of_type(self, "CollisionShape3D")
	children = get_children()

func _process(_delta):
	# eventually this shouldn't be hardcoded for bass
	if MusicStates.bass_1 != prev_base_state:
		prev_base_state = MusicStates.bass_1
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
