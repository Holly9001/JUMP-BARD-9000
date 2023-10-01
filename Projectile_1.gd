extends Node3D

@onready var sprite = $AnimatedSprite3D

var spawn_offset : Vector3 = Vector3(1,0,0)
var speed : float

var despawn_timer = 60*30

# Called when the node enters the scene tree for the first time.
func _ready():
	if abs(global_rotation.z) > PI/2:
		sprite.rotation.z = -PI
		sprite.scale.x = -sprite.scale.x
	
	set_as_top_level(true)
	global_position += global_transform.basis*spawn_offset


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	if despawn_timer > 0:
		despawn_timer -= 1
	else: queue_free()
		
	
	global_position += (global_transform.basis.x) * speed * delta


func _on_hurt_box_body_entered(body):
	
	## so projectile should probb _die() if it hits player. but, like, u only have 1 life so i dont think it matters.
	## mb do it if we add more visual flair idk??
	
	if !body.is_in_group('projectile_passthrough'):
		_die()

func _die():
	## add a little animation for hitting the wall later, idk. or maybe add a like decal? idk.
	## or like a little sound? idk. little particle prob. maybe it becomes a dead bee that u can push around
	## on the ground 4 a sec b4 it despawns? idk.

	queue_free()
