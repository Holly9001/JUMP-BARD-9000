extends Node

@export var levels: Array[PackedScene] = []
@export var music_controller:Node

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
	MusicStates.reset_states()
	load_level(current_level)

func _ready():
	music_controller = music_controller.get_child(0)
	load_level(0)
	GameState.reset_level.connect(reload_level)
	GameState.next_level.connect(load_next)

func load_next():
	load_level(current_level + 1)
	
func _process(delta):
	if Input.is_action_just_pressed("debug_lvl_0"):
		load_level(0)
	if Input.is_action_just_pressed("debug_lvl_1"):
		load_level(1)
	if Input.is_action_just_pressed("debug_lvl_2"):
		load_next()
		
