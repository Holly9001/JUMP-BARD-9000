extends CharacterBody3D
# this is the single greatest comment of all time no comment is better
# Get the gravity from the project settings to be synced with RigidBody nodes.

var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

@onready var HeadRayML :RayCast3D= $HeadBonkRayMidL
@onready var HeadRayMR :RayCast3D= $HeadBonkRayMidR
@onready var HeadRayR :RayCast3D= $HeadBonkRayR
@onready var HeadRayL :RayCast3D= $HeadBonkRayL
@onready var initial_parent = self.get_parent()
@onready var wall_check_arm = $wall_check_arm
@onready var wall_check_foot = $wall_check_foot
@onready var camera_arm = $SpringArm

const x_ground_accel:float = 12
const x_air_accel:float = 50

const y_accel:float = 12

const ground_friction:float = 4.8
const air_friction:float = 0.5

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
	
	var friction = ground_friction if on_floor else air_friction
	
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
	
	if wall_check_arm.is_colliding():
		attached = wall_check_arm.get_collider()
	elif wall_check_foot.is_colliding():
		attached = wall_check_foot.get_collider()
	
	if Input.is_action_pressed('climb') and (wall_check_arm.is_colliding() or wall_check_foot.is_colliding()) and climb_time > 0:
		x_velocity = 0
		y_velocity = 0
		velocity.y = 0
		climb_time -= 90 * delta
		if movement_vector.y >= 0:
			y_velocity = movement_vector.y * climb_speed - (1 - sign(climb_time))*4
		else:
			y_velocity = movement_vector.y * climb_speed * 2 
		if get_parent() != attached:
			var global_trans = self.global_transform
			self.get_parent().remove_child(self)
			attached.add_child(self)
			self.set_owner(attached)
			self.global_transform = global_trans
		if test_move(global_transform,Vector3.RIGHT * delta * 10):
			if Input.is_action_just_pressed('jump') and (!is_on_floor() and !on_floor):
				climb_time -= 16
				x_velocity = -jump_height/6 + (movement_vector.x/7)
				y_velocity = jump_height + abs(movement_vector.x)
				wall_check_arm.scale.x = -1
				wall_check_foot.scale.x = -1
		elif test_move(global_transform,Vector3.LEFT * delta * 10):
			if Input.is_action_just_pressed('jump') and (!is_on_floor() and !on_floor):
				climb_time -= 16
				x_velocity = jump_height/6 + (movement_vector.x/7)
				y_velocity = jump_height + abs(movement_vector.x)
				wall_check_arm.scale.x = 1
				wall_check_foot.scale.x = 1
	else:
		if self.get_parent() == attached:
			var global_trans = self.global_transform
			self.get_parent().remove_child(self)
			initial_parent.add_child(self)
			self.set_owner(initial_parent)
			self.global_transform = global_trans
		if velocity.x > 0:
			wall_check_arm.scale.x = 1
			wall_check_foot.scale.x = 1
		elif velocity.x < 0:
			wall_check_arm.scale.x = -1
			wall_check_foot.scale.x = -1

	if on_floor:
		velocity.x = lerp(velocity.x,(movement_vector.x + x_velocity) * horizontal_speed * delta * 60, delta * x_ground_accel)
	else:
		velocity.x = lerp(velocity.x, 0.0, delta * friction)
		if movement_vector.x != 0 and not (sign(velocity.x) == sign(movement_vector.x) and abs(velocity.x) > horizontal_speed):
			velocity.x = move_toward(velocity.x, movement_vector.x * horizontal_speed, x_air_accel * delta)
	velocity.y = lerp(velocity.y,y_velocity * vertical_speed * delta * 60, y_accel * delta)
	
	move_and_slide()
	camera_arm.player_pos = global_position

