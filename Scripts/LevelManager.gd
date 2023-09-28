extends Node

@export var levels: Array[PackedScene] = []

func load_level(idx):
	for c in get_children():
		c.queue_free()
	var scene = levels[idx].instantiate()
	add_child(scene)

func _ready():
	load_level(0)
	
func _process(delta):
	if Input.is_action_just_pressed("debug_level_0"):
		load_level(0)
	if Input.is_action_just_pressed("debug_level_1"):
		load_level(1)
		
