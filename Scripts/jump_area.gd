extends Area3D

@onready var player = get_tree().get_nodes_in_group("Player")[0]

@export var beat_multiplier:float = 1.0
@export var allow_off_beat:bool = true
@export var beat_type:String

var touching_player:bool = false

func _process(delta):
	if touching_player and Input.is_action_just_pressed('jump'):
		player.velocity.y = 0
		if MusicStates[beat_type]:
			player.jump(beat_multiplier)
		elif allow_off_beat:
			player.jump(0)

func _on_body_entered(body):
	if(body == player):
		touching_player = true


func _on_body_exited(body):
	if(body == player):
		touching_player = false
