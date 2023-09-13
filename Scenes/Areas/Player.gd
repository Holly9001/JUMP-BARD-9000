extends CharacterBody3D
# this is the single greatest comment of all time no comment is better
# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

var movement_vector :Vector2= Vector2.ZERO

var max_horizontal_speed :float= 3
var max_vertical_speed :float= 1.3

var jump_height :float= 12

var horizontal_speed :float= 6
var vertical_speed :float= 2

var y_velocity :float= 0

var max_coyote_frames = 32
var coyote_frames = 0

@export var jump_curve:Curve

func _physics_process(delta):
	
	movement_vector = Input.get_vector("left", "right", "down", "up").normalized()
	
	## FUCK THIS SHIT I QUIT!! BASIC PLATFORMER MOVEMENT IS TOO HATRD IM DROPPING OUT OF COLLEGE FUCK!!!
	
	## OK THIS IS CODE I WANNA KEEP YAYAYAYAYYAYAY! THIS SHOULD REMAIN
	
	if is_on_floor():
		coyote_frames = max_coyote_frames
		velocity.y = 0
		if Input.is_action_just_pressed('jump'):
			y_velocity = jump_height
			coyote_frames = 0
	elif is_on_ceiling():
		y_velocity = 0
	elif is_on_wall():
		pass
	else:
		coyote_frames = clamp(coyote_frames-1,0,max_coyote_frames)
		velocity.y = lerp(velocity.y,-max_vertical_speed * vertical_speed * delta * 60,0.2)
	
	print(coyote_frames)
	
	if y_velocity > -max_vertical_speed * gravity:
		
		y_velocity = lerp(y_velocity,-max_vertical_speed*gravity,jump_curve.sample(velocity.y+1.8)+0.01-coyote_frames*0.001)
	
	
	
	velocity.x = lerp(velocity.x,movement_vector.x * horizontal_speed * delta * 60,0.1)
	velocity.y = lerp(velocity.y,y_velocity * vertical_speed * delta * 60,0.2)
	
	
	move_and_slide()
