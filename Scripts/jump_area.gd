extends Area3D

@onready var player = get_tree().get_nodes_in_group("Player")[0]

var touching_player:bool = false

func _process(delta):
	if touching_player and Input.is_action_just_pressed('jump'):
		player.velocity.y = 0
		player.jump()

func _on_body_entered(body):
	if(body == player):
		touching_player = true


func _on_body_exited(body):
	if(body == player):
		touching_player = false
