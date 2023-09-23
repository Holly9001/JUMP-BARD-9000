extends Node3D

@export var break_time:float = 1.0

@onready var children = self.get_children()

const destroy_time:float = 1.0

var child_meshes

func _ready():
	child_meshes = get_children_of_type(self, "MeshInstance3D")

func trigger():
	var tween = get_tree().create_tween()
	for i in child_meshes:
		var mat = i.mesh.material
		tween.tween_property(mat, "albedo_color", Color.RED, break_time)
	tween.tween_callback(self.queue_free)
	
func get_children_of_type(in_node, type, arr:=[]):
	if in_node.get_class() == type:
		arr.push_back(in_node)
	for child in in_node.get_children():
		arr = get_children_of_type(child, type, arr)
	return arr
