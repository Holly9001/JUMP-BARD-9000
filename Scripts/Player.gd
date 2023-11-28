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
@onready var whoosh_sfx = $AudioStreamPlayer

@onready var dash_particle :GPUParticles3D= $DashParticle

const WALK_SPEED:float = 6.0

# Because of the division, this is how fast in seconds the player will take to
# accelerate to WALK_SPEED. However, this does not account for friction so
# the actual time will be a bit different.
const X_GROUND_ACCEL:float = WALK_SPEED / 0.1
const X_AIR_ACCEL:float = WALK_SPEED / 0.2

# How fast the player will go from velocity v = n to v = 0, with n being any
# constant. Obviously this is only true if the velocity isn't affected by
# something else.
const GROUND_FRICTION:float = 1 / 0.1
const AIR_FRICTION:float = 1 / 0.5

# Impulse forces applied when wall jumping
const WALLJUMP_FORCE_Y:float = 10.0
const WALLJUMP_FORCE_X:float = 8.0

# Impulse force applied when dashing. This is multiplied by the x and y of
# movement vector, so the diagonal magnitude is actually higher than
# vertical or horizontal alone. Maybe this should change? If you want to test,
# just add "normalize()" after the movement vector assignment in
# physics_process.
const DASH_FORCE:float = 20.0
const CHARGE_DASH_FORCE:float = 30.0

# Gravity force applied per second when the player is airborne.
const GRAVITY:float = 30.0

# JUMP_BOOST is the force applied per second during the jump_hold duration
# JUMP_IMPULSE is an impulse applied immediately.
const JUMP_BOOST :float= 50.0
const JUMP_IMPULSE:float = 10.0

# MAX_CLIMB_TIME is the time in seconds you can stay climbing assuming you
# don't jump. CLIMB_JUMP_PENALTY is a penalty applied to the climb time when
# you walljump.
const MAX_CLIMB_TIME:float = 3.5
const CLIMB_JUMP_PENALTY:float = 0.1

# Same as the normal accel and movement, but on a wall, see the top of this
# script.
const CLIMB_SPEED:float = 4.0
const CLIMB_ACCEL:float = CLIMB_SPEED / 0.05

# Dash cooldown is the time in seconds it takes for dash to reset
const DASH_COOLDOWN:float = 2

const EDGE_ADJUST_DIST:float = 0.03 

# If you keep the jump key held down, you will get JUMP_BOOST force per second
# added to velocity.y. This boost is available for MAX_JUMP_HOLD seconds after
# a jump is executed.
const MAX_JUMP_HOLD:float = 0.2

const DASH_BEAT_TYPE:String = "metronome"

const MAX_COYOTE_TIME:float = 0.075

const CLIMB_UP_Y_OFFSET:float = 0.05

const CLIMB_UP_X_FORCE:float = 2.0

const MAX_JUMP_BUFFER_TIME:float = 0.05

var can_dash:bool = false

var can_charge_dash:bool = false

var jump_hold:float = 0

var movement_vector :Vector2= Vector2.ZERO

var coyote_time:float = 0.0

var is_climbing:bool = false
var climb_time = 0

var attached

var climb_direction:float = -1

## ability booleans
# for double jump bools and shit, gonna make one for hold jump too.
var dash_unlocked:bool = true

var charge_dash_unlocked:bool = true

var jump_buffer_time:float = 0.0

var beats_to_charge_dash = 5 # Number of beats to wait for charge dash to trigger on key release

var beats_counter = beats_to_charge_dash # Number of beats remaining in charge dash timer

var is_charging = false 

@export var jump_curve:Curve

func _ready():
	var lam_enable_dash = func(type): if type == DASH_BEAT_TYPE: can_dash = true
	var lam_disable_dash = func(type): if type == DASH_BEAT_TYPE: can_dash = false
	MusicStates.pre_beat.connect(lam_enable_dash)
	MusicStates.post_beat.connect(lam_disable_dash)
	MusicStates.on_beat.connect(handle_on_beat)

func handle_on_beat(type):
	# Decreases counter for charge dash on each beat
	if is_charging && type == DASH_BEAT_TYPE:
		beats_counter -= 1
		print(beats_counter)

func handle_post_beat(type):
	print(type)

func reset_parent():
	var global_trans = self.global_transform
	self.get_parent().remove_child(self)
	initial_parent.add_child(self)
	self.set_owner(initial_parent)
	self.global_transform = global_trans

func jump():
	jump_hold = MAX_JUMP_HOLD
	coyote_time = 0
	velocity.y = JUMP_IMPULSE


func _physics_process(delta):
	$DebugUI/ClimbTime.text = str(can_dash)
	movement_vector = Input.get_vector("left", "right", "down", "up")
	
	if Input.is_action_just_pressed("restart"):
		GameState.restart()
	
	if is_on_ceiling():
		handle_ceiling_bump(delta)
	
	if wall_check_arm.is_colliding():
		attached = wall_check_arm.get_collider()
	elif wall_check_foot.is_colliding():
		attached = wall_check_foot.get_collider()
	
	if Input.is_action_pressed('climb')\
	 and (wall_check_arm.is_colliding() or wall_check_foot.is_colliding())\
	 and climb_time > 0:
		is_climbing = true
		handle_climbing(delta)
	else:
		if is_climbing and sign(movement_vector.x) == sign(climb_direction):
			move_and_collide(Vector3(0, CLIMB_UP_Y_OFFSET, 0))
			velocity.x = CLIMB_UP_X_FORCE * climb_direction
		is_climbing = false
		detach()
	if !is_on_floor() and !is_climbing:
		velocity.y -= GRAVITY * delta
		
	# Friction goes before the other stuff so it doesn't affect impulses immediately
	handle_friction(delta)
	handle_movement_inputs(delta)
	handle_abilities(delta)
	handle_ceiling_bump(delta)
	move_and_slide()
	camera_arm.player_pos = global_position

func handle_abilities(delta):
	if dash_unlocked:
		if Input.is_action_just_pressed("dash"):
			is_charging = true
			
		if Input.is_action_just_released("dash"):
			if beats_counter == 0:
				velocity.x = movement_vector.x * CHARGE_DASH_FORCE
				velocity.y = movement_vector.y * CHARGE_DASH_FORCE
				dash_particle.emitting = true
				whoosh_sfx.pitch_scale = randf_range(0.87,0.92)
				whoosh_sfx.play()
				
				
				can_dash = false 
			is_charging = false
			beats_counter = beats_to_charge_dash
				

func handle_movement_inputs(delta):
	var x_accel = X_GROUND_ACCEL if is_on_floor() else X_AIR_ACCEL
	jump_hold -= delta
	if Input.is_action_pressed('jump') and jump_hold > 0:
		velocity.y += JUMP_BOOST * delta
	
	if Input.is_action_just_pressed("jump"):
		jump_buffer_time = MAX_JUMP_BUFFER_TIME
	else:
		jump_buffer_time -= delta
	
	if is_on_floor() or coyote_time > 0.0:
		if is_on_floor():
			coyote_time = MAX_COYOTE_TIME
			climb_time = MAX_CLIMB_TIME
		else:
			coyote_time -= delta
		if jump_buffer_time > 0.0:
			jump()
	
	var new_vel_x = velocity.x + movement_vector.x * x_accel * delta
	if abs(new_vel_x) < abs(velocity.x) or abs(new_vel_x) < WALK_SPEED:
		velocity.x += movement_vector.x * x_accel * delta
		
		
func handle_friction(delta):
	var friction = GROUND_FRICTION if is_on_floor() else AIR_FRICTION
	velocity.y = lerp(velocity.y, 0.0, friction * delta)
	velocity.x = lerp(velocity.x, 0.0, friction * delta)

func handle_climbing(delta):
	velocity.y = move_toward(velocity.y, CLIMB_SPEED * movement_vector.y, CLIMB_ACCEL * delta)
	climb_time -= delta
	if get_parent() != attached:
		if attached:
			var global_trans = self.global_transform
			self.get_parent().remove_child(self)
			attached.add_child(self)
			self.set_owner(attached)
			self.global_transform = global_trans
	if test_move(global_transform,Vector3.RIGHT * delta * 10):
		climb_direction = 1.0
	elif test_move(global_transform,Vector3.LEFT * delta * 10):
		climb_direction = -1.0
	if Input.is_action_just_pressed('jump') and (!is_on_floor()):
		is_climbing = false
		climb_time -= CLIMB_JUMP_PENALTY
		velocity.x = -WALLJUMP_FORCE_X * climb_direction
		velocity.y = WALLJUMP_FORCE_Y
		wall_check_arm.scale.x = climb_direction
		wall_check_foot.scale.x = climb_direction

func handle_ceiling_bump(delta):
	if HeadRayML.is_colliding() or HeadRayMR.is_colliding(): #this solution is fucking stupid but areas werent cooperating
		velocity.y = -GRAVITY * delta
	elif HeadRayR.is_colliding():
		move_and_collide(Vector3(-EDGE_ADJUST_DIST, 0, 0))
		jump_hold += delta
	elif HeadRayL.is_colliding():
		move_and_collide(Vector3(EDGE_ADJUST_DIST, 0, 0))
		jump_hold += delta

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
