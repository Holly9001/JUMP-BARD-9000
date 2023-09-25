extends Node3D

@export var break_time:float = 1.0

@onready var children = self.get_children()
@onready var player = get_tree().get_nodes_in_group("Player")[0]

const destroy_time:float = 1.0

var child_meshes

func _ready():
	child_meshes = Utils.get_children_of_type(self, "MeshInstance3D")

func trigger():
	var tween = get_tree().create_tween()
	for i in child_meshes:
		var mat = i.mesh.material
		tween.tween_property(mat, "albedo_color", Color.RED, break_time)
	tween.tween_callback(destroy)
	
func destroy():
	player.reset_parent()
	self.queue_free()
