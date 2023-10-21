extends Node3D

@onready var root = get_tree().root.get_child(0)

@export var projectile : PackedScene

@export var projectile_speed :float= 5

@export var beat_type : String = 'bass_1'

## IF WE ADD MORE PROJECTILES, ALLOW U TO EXPORT PROJECTILE SCENE.

# Called when the node enters the scene tree for the first time.
func _ready():
	MusicStates.value_changed.connect(on_beat)

func on_beat(type):
	if beat_type == type:
		_shoot()

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#
#	if MusicStates.state_array[beat_type] != prev_beat:
#
#		_shoot()
#
#		prev_beat = MusicStates.state_array[beat_type]


func _shoot():
	var projectile_instance = projectile.instantiate()
	projectile_instance.speed = projectile_speed
	add_child(projectile_instance)
#	projectile_instance.global_positon = global_position + Vector3(0,0,-1)
#	projectile_instance.global_rotation = global_rotation
	
