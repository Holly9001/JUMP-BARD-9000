extends Node

@export var levels: Array[PackedScene] = []
@export var music_controller:AnimationPlayer

var current_level:int

func load_level(idx):
	current_level = idx
	music_controller.seek(0, true) 
	GameState.reset_life()
	for c in get_children():
		c.queue_free()
	var scene = levels[idx].instantiate()
	add_child(scene)
	
func reload_level():
	load_level(current_level)

func _ready():
	load_level(0)
	GameState.reset_level.connect(reload_level)
	
func _process(delta):
	if Input.is_action_just_pressed("debug_level_0"):
		load_level(0)
	if Input.is_action_just_pressed("debug_level_1"):
		load_level(1)
		
