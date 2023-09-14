extends SpringArm3D

@onready var player :CharacterBody3D= get_parent()

@onready var location :Vector3= Vector3.ZERO

# Called when the node enters the scene tree for the first time.
func _ready():
	set_as_top_level(true)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	
	var player_pos = player.global_position
	
	## iterate through an ['x','y'] list and only set those if the z freaks its shit here
	
	var movement_offset = player.movement_vector + Vector2(7 * player.velocity.x/6,0) + Vector2(0,1) ## vector offsets cam a bit so player is in bottom
	
	
	location = Vector3(lerp(global_position.x,player_pos.x+movement_offset.x,0.02),lerp(global_position.y,player_pos.y + movement_offset.y,0.02),global_position.z)
	
	global_position = location
