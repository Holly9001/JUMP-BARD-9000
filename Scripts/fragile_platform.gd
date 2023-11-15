extends Node3D

@export var break_time:float = 1
 
@onready var children = self.get_children()

var child_meshes
var player
var tween:Tween
var node = self 

func _ready():
	child_meshes = Utils.get_children_of_type(self, "MeshInstance3D")
	player = get_tree().get_nodes_in_group("Player")
	for i in child_meshes:
		var mat = i.mesh.material
		if mat == null:
			mat = i.mesh.surface_get_material(0)
		mat.albedo_color = Color.WHITE
 # Commented out to support tilset meshes

func _exit_tree():
	if tween != null:
		tween.kill()

func trigger():
	tween = get_tree().create_tween()
	for i in child_meshes:
		var mat = i.mesh.material 
		if mat == null:
			mat = i.mesh.surface_get_material(0)
		
		tween.tween_property(mat, "albedo_color", Color.RED, break_time)
	tween.tween_callback(destroy)
	
	print("triggered")

func reform():
	add_child(node)
	
func destroy():
#	if player != null:
#		player.reset_parent() #Resets player parent to avoid crashing while climbing
	self.queue_free()
	tween = get_tree().create_tween()
	for i in child_meshes:
		var mat = i.mesh.material 
		if mat == null:
			mat = i.mesh.surface_get_material(0)

	# wip: adding reform capacbility
	tween.tween_callback(reform)
