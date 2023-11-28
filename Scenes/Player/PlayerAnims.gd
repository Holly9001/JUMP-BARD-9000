extends AnimatedSprite3D

@onready var player :CharacterBody3D= get_parent()

@onready var orig_scale : Vector3 = scale

var player_speed : float


# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	player_speed = snappedf(player.velocity.x,0.5)
	
	
	if player_speed == 0:
		animation = 'idle_1'
		speed_scale = 1
	else:
		scale.x = orig_scale.x * sign(player_speed)
		speed_scale = abs(player_speed)/3
		animation = 'run_1'
