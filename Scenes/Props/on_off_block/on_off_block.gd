extends Node3D

@onready var block_collision = $StaticBody3D/CollisionShape3D

const SWITCH_TIME = 1.5

var time_until_switch = SWITCH_TIME

func _process(delta):
	print("test")
	# this won't be happening here once the music works. it's just a timer to test
	time_until_switch -= delta
	# below code will check the music status singleton instead
	if time_until_switch < 0:
		time_until_switch = SWITCH_TIME
		block_collision.disabled = !block_collision.disabled
		self.visible = !self.visible
