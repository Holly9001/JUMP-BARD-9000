extends AnimatedSprite3D

### using separate script so we dont bloat the player script
@onready var player :CharacterBody3D= get_parent()

var default_scale : Vector3

# Called when the node enters the scene tree for the first time.
func _ready():
	default_scale = scale


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	var x_direction = snapped(player.velocity.x,0.001)
	var y_direction = snapped(player.velocity.y,0.001)
	
	
	if x_direction != 0:
		animation = 'run_1'
		print("run")
		scale.x = sign(player.velocity.x) * default_scale.x
		
		speed_scale = clamp(abs(x_direction)/3,1,3)
	else:
		animation = 'idle_1'
	
	print(x_direction)
