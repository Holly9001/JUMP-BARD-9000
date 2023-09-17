extends CharacterBody3D
# this is the single greatest comment of all time no comment is better
# Get the gravity from the project settings to be synced with RigidBody nodes.

var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

@onready var HeadRayML :RayCast3D= $HeadBonkRayMidL
@onready var HeadRayMR :RayCast3D= $HeadBonkRayMidR
@onready var HeadRayR :RayCast3D= $HeadBonkRayR
@onready var HeadRayL :RayCast3D= $HeadBonkRayL
@onready var initial_parent = self.get_parent()

const ground_accel:float = 12
const air_accel:float = 3

const ground_friction:float = 4.8
const air_friction:float = 2.4

var movement_vector :Vector2= Vector2.ZERO

var max_horizontal_speed :float= 3
var max_vertical_speed :float= 1.3

var jump_height :float= 12

var horizontal_speed :float= 6
var vertical_speed :float= 2

var y_velocity :float= 0
var x_velocity :float= 0

var max_coyote_frames := 32
var coyote_frames := 0

var max_jump_hold := 10
var jump_hold := 0

var climb_speed := 6

var max_climb_time = 60*3.5
var climb_time = 0

var attached

## ability booleans
# for double jump bools and shit, gonna make one for hold jump too.



@export var jump_curve:Curve

func _physics_process(delta):
	
	movement_vector = Input.get_vector("left", "right", "down", "up")# normalized()
#	for i in ['x','y']:
#		movement_vector[i] = round(movement_vector[i])
	
	
	## FUCK THIS SHIT I QUIT!! BASIC PLATFORMER MOVEMENT IS TOO HATRD IM DROPPING OUT OF COLLEGE FUCK!!!
	
	## OK THIS IS CODE I WANNA KEEP YAYAYAYAYYAYAY! THIS SHOULD REMAIN
	
	## is_on_floor() is jank as fuck sometimes lol, this is better.
	var on_floor = test_move(global_transform,Vector3.DOWN * delta * 10)
	
	var friction = ground_friction if on_floor else air_accel
	
	###
	
	###
	
	if on_floor and jump_hold <= 0:  
		coyote_frames = max_coyote_frames
		climb_time = max_climb_time
		jump_hold = 0
		velocity.y = 0
		if Input.is_action_just_pressed('jump'):
			jump_hold = max_jump_hold
			
			y_velocity = jump_height
			coyote_frames = 0
#	elif is_on_ceiling():
#		y_velocity = 0
#		velocity.y = velocity.y/2
##	elif is_on_wall():
##		pass
	else:
		if coyote_frames >= max_coyote_frames*0.9 and Input.is_action_just_pressed('jump'):
			jump_hold = max_jump_hold
			y_velocity = jump_height     ## THIS IS SO FUCKING SCUFFED ALL THESE IFS THIS CODE IS SO UGLY IM SORRY FUCK
			coyote_frames = 0
		
		
		if Input.is_action_pressed('jump') and jump_hold > 0:
			jump_hold -= 1
			y_velocity = jump_height
		else: jump_hold = 0
#		if Input.is_action_just_released('jump'): jump_hold = 0
		
		coyote_frames = clamp(coyote_frames-1,0,max_coyote_frames)
		velocity.y = lerp(velocity.y,-max_vertical_speed * vertical_speed * delta * 60,0.15)
	
	if Input.is_action_just_pressed("restart"):
		get_tree().reload_current_scene()
	
	if y_velocity > -max_vertical_speed * gravity:
		
		y_velocity = lerp(y_velocity,-max_vertical_speed*gravity,jump_curve.sample(velocity.y+1.8)+0.015-coyote_frames*0.0008)
	
	if x_velocity != 0:
		x_velocity = lerp(x_velocity,0.0, friction * delta)
	
	
	## climbing/jumoing here
	
	$DebugUI/ClimbTime.text = str('climb_time: ',climb_time) ## using $ in code is horrible practice but this is just a debug test
	
#		if is_on_wall():
#			velocity.y = 0 ## kind of a placeholder, this wouldnt b needed if we made a state machine
#			climb_time -= 90 * delta
#			y_velocity = movement_vector.y * climb_speed 
#			#print(movement_vector.y)
#
#			if movement_vector.y >= 0:
#					y_velocity = movement_vector.y * climb_speed - (1 - sign(climb_time))*4
#			else:
#				y_velocity = movement_vector.y * climb_speed * 2 
#
#		## so technically if u only jump ine the jump buffer range, u dont lose climb time. bug? feature? idk
#
#		if test_move(global_transform,Vector3.RIGHT * delta * 10):
#			if Input.is_action_just_pressed('jump'):
#				climb_time -= 16
#				x_velocity = -jump_height/7 + (movement_vector.x/7)
#				y_velocity = jump_height + abs(movement_vector.x)
#		elif test_move(global_transform,Vector3.LEFT * delta * 2):
#			if Input.is_action_just_pressed('jump'):
#				climb_time -= 16
#				x_velocity = jump_height/7 + (movement_vector.x/7)
#				y_velocity = jump_height + abs(movement_vector.x)

	
	if is_on_ceiling():
		if HeadRayML.is_colliding() or HeadRayMR.is_colliding(): #this solution is fucking stupid but areas werent cooperating
			y_velocity = 0
			velocity.y = velocity.y/2
			print('stop')
		elif HeadRayR.is_colliding():
			velocity.x += velocity.y
			velocity.y +=1
			print('move left')
		elif HeadRayL.is_colliding():
			print('move right')
			velocity.x -= velocity.y
			velocity.y +=1
			
	if on_floor:
		velocity.x = lerp(velocity.x,(movement_vector.x + x_velocity) * horizontal_speed * delta * 60, delta * ground_accel)
	else:
		velocity.x = lerp(velocity.x,(movement_vector.x + x_velocity) * horizontal_speed * delta * 60, delta * air_accel)
		
	velocity.y = lerp(velocity.y,y_velocity * vertical_speed * delta * 60,0.2)
	
	if Input.is_action_pressed('climb') and $wall_check.is_colliding():
		var global_pos = self.global_position
		attached = $wall_check.get_collider()
		self.get_parent().remove_child(self)
		attached.add_child(self)
		self.set_owner(attached)
		self.global_position = global_pos
	else:
		if self.get_parent() == attached:
			var global_pos = self.global_position
			self.get_parent().remove_child(self)
			initial_parent.add_child(self)
			self.set_owner(initial_parent)
			self.global_position = global_pos
		#set_as_top_level(true)
		move_and_slide()


