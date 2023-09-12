extends CharacterBody3D

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

var movement_vector :Vector2= Vector2.ZERO

var max_horizontal_speed :float= 3
var max_vertical_speed :float= 1.3

var jump_height :float= 12

var horizontal_speed :float= 6
var vertical_speed :float= 2

var y_velocity :float= 0

@export var jump_curve:Curve

func _physics_process(delta):
	
	movement_vector = Input.get_vector("left", "right", "down", "up").normalized()
	
	#movement_vector = Vector2(int(Input.is_action_pressed("right"))-int(Input.is_action_pressed('left')),int(Input.is_action_pressed('up'))-int(Input.is_action_pressed('down'))).normalized()
	
	
	
	if is_on_floor():
		velocity.y = 0
		if Input.is_action_just_pressed('jump'): y_velocity = jump_height
	elif is_on_ceiling():
		y_velocity = 0
	elif is_on_wall():
		pass
#	else:
#		velocity.y = lerp(velocity.y,-max_vertical_speed * vertical_speed * delta * 60,0.2)
	
	if y_velocity > -max_vertical_speed * gravity:
		y_velocity = lerp(y_velocity,-max_vertical_speed*gravity,jump_curve.sample(velocity.y)+0.01)
	
	
	velocity.x = lerp(velocity.x,movement_vector.x * horizontal_speed * delta * 60,0.1)
	velocity.y = lerp(velocity.y,y_velocity * vertical_speed * delta * 60,0.2)
	
	print(y_velocity)
	
	move_and_slide()
