extends CharacterBody3D
# this is the single greatest comment of all time no comment is better
# Get the gravity from the project settings to be synced with RigidBody nodes.

@onready var HeadRayML :RayCast3D= $HeadBonkRayMidL
@onready var HeadRayMR :RayCast3D= $HeadBonkRayMidR
@onready var HeadRayR :RayCast3D= $HeadBonkRayR
@onready var HeadRayL :RayCast3D= $HeadBonkRayL
@onready var initial_parent = self.get_parent()
@onready var wall_check_arm = $wall_check_arm
@onready var wall_check_foot = $wall_check_foot
@onready var camera_arm = $SpringArm

const WALK_SPEED:float = 6.0

const X_GROUND_ACCEL:float = WALK_SPEED / 0.1
const X_AIR_ACCEL:float = WALK_SPEED / 0.15

const Y_ACCEL:float = 12

const GROUND_FRICTION:float = 1 / 0.1
const AIR_FRICTION:float = 1 / 0.5

const X_VELOCITY_DECAY:float = 4.8

const WALLJUMP_FORCE_Y:float = 10.0
const WALLJUMP_FORCE_X:float = 8.0

const DASH_FORCE:float = 20.0

const GRAVITY:float = 30.0

const JUMP_BOOST :float= 50.0
const JUMP_IMPULSE:float = 10.0

const MAX_CLIMB_TIME:float = 3.5
const CLIMB_JUMP_PENALTY:float = 0.1

const CLIMB_SPEED:float = 2.0
const CLIMB_ACCEL:float = CLIMB_SPEED / 0.2

const DASH_COOLDOWN:float = 2
var dash_time:float = DASH_COOLDOWN

const MAX_JUMP_HOLD:float = 0.2
var jump_hold:float = 0

var movement_vector :Vector2= Vector2.ZERO

var max_coyote_frames := 32
var coyote_frames := 0

var is_climbing:bool = false
var climb_time = 0

var attached

## ability booleans
# for double jump bools and shit, gonna make one for hold jump too.
var can_dash:bool = true


@export var jump_curve:Curve

func reset_parent():
	var global_trans = self.global_transform
	self.get_parent().remove_child(self)
	initial_parent.add_child(self)
	self.set_owner(initial_parent)
	self.global_transform = global_trans

func jump():
	jump_hold = MAX_JUMP_HOLD
	coyote_frames = 0
	velocity.y = JUMP_IMPULSE


func _physics_process(delta):
	
	movement_vector = Input.get_vector("left", "right", "down", "up")
	handle_coyote_frames()
	
	if Input.is_action_just_pressed("restart"):
		get_tree().reload_current_scene()
	
	if is_on_ceiling():
		handle_ceiling_bump()
	
	if wall_check_arm.is_colliding():
		attached = wall_check_arm.get_collider()
	elif wall_check_foot.is_colliding():
		attached = wall_check_foot.get_collider()
	
	if Input.is_action_pressed('climb')\
	 and (wall_check_arm.is_colliding() or wall_check_foot.is_colliding())\
	 and climb_time > 0:
		handle_climbing(delta)
		is_climbing = true
	else:
		is_climbing = false
		detach()
	
	if !is_on_floor() and !is_climbing:
		velocity.y -= GRAVITY * delta
		
	# Friction goes before the other stuff so it doesn't affect impulses immediately
	handle_friction(delta)
	handle_movement_inputs(delta)
	handle_abilities(delta)
	move_and_slide()
	camera_arm.player_pos = global_position

func handle_abilities(delta):
	if can_dash:
		if Input.is_action_just_pressed("dash") and dash_time < 0:
			print(movement_vector.x)
			print(movement_vector.y)
			velocity.x = movement_vector.x * DASH_FORCE
			velocity.y = movement_vector.y * DASH_FORCE
			dash_time = DASH_COOLDOWN
		if dash_time > 0:
			dash_time -= delta

func handle_movement_inputs(delta):
	var x_accel = X_GROUND_ACCEL if is_on_floor() else X_AIR_ACCEL
	jump_hold -= delta
	if Input.is_action_pressed('jump') and jump_hold > 0:
		velocity.y += JUMP_BOOST * delta
	
	if is_on_floor():
		climb_time = MAX_CLIMB_TIME
		if Input.is_action_just_pressed("jump"):
			jump()
	
	var new_vel_x = velocity.x + movement_vector.x * x_accel * delta
	if abs(new_vel_x) < abs(velocity.x) or abs(new_vel_x) < WALK_SPEED:
		velocity.x += movement_vector.x * x_accel * delta
		
		
func handle_friction(delta):
	var friction = GROUND_FRICTION if is_on_floor() else AIR_FRICTION
	velocity.y = lerp(velocity.y, 0.0, friction * delta)
	velocity.x = lerp(velocity.x, 0.0, friction * delta)

func handle_climbing(delta):
	velocity.y = move_toward(velocity.y, CLIMB_SPEED, CLIMB_ACCEL * delta)
	climb_time -= delta
	if get_parent() != attached:
		if attached:
			var global_trans = self.global_transform
			self.get_parent().remove_child(self)
			attached.add_child(self)
			self.set_owner(attached)
			self.global_transform = global_trans
	if test_move(global_transform,Vector3.RIGHT * delta * 10):
		if Input.is_action_just_pressed('jump') and (!is_on_floor()):
			climb_time -= CLIMB_JUMP_PENALTY
			velocity.x = -WALLJUMP_FORCE_X
			velocity.y = WALLJUMP_FORCE_Y
			wall_check_arm.scale.x = -1
			wall_check_foot.scale.x = -1
	elif test_move(global_transform,Vector3.LEFT * delta * 10):
		if Input.is_action_just_pressed('jump') and (!is_on_floor()):
			climb_time -= CLIMB_JUMP_PENALTY
			velocity.x = WALLJUMP_FORCE_X
			velocity.y = WALLJUMP_FORCE_Y
			wall_check_arm.scale.x = 1
			wall_check_foot.scale.x = 1

func handle_ceiling_bump():
#	if HeadRayML.is_colliding() or HeadRayMR.is_colliding(): #this solution is fucking stupid but areas werent cooperating
#		y_velocity = 0
#		velocity.y = velocity.y/2
#		print('stop')
#	elif HeadRayR.is_colliding():
#		velocity.x += velocity.y
#		velocity.y +=1
#		print('move left')
#	elif HeadRayL.is_colliding():
#		print('move right')
#		velocity.x -= velocity.y
#		velocity.y +=1
	pass

func handle_coyote_frames():
#	if on_floor and jump_hold <= 0:  
#		coyote_frames = max_coyote_frames
#		climb_time = max_climb_time
#		jump_hold = 0
#		velocity.y = 0
#		if Input.is_action_just_pressed('jump'):
#			jump()
#	else:
#		if coyote_frames >= max_coyote_frames*0.9 and Input.is_action_just_pressed('jump'):
#			jump_hold = max_jump_hold
#			y_velocity = jump_height
#			coyote_frames = 0
#		coyote_frames = clamp(coyote_frames-1,0,max_coyote_frames)
	pass

func detach():
	if self.get_parent() == attached:
		reset_parent()
	if velocity.x > 0:
		wall_check_arm.scale.x = 1
		wall_check_foot.scale.x = 1
	elif velocity.x < 0:
		wall_check_arm.scale.x = -1
		wall_check_foot.scale.x = -1

func _on_hit_box_area_entered(area):
	if area.is_in_group('player_hurt'):
		GameState.restart()
