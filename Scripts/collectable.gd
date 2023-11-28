extends Node3D

const ROTATION_SPEED = 1.0
const BOB_MAGNITUDE = 0.5

var bob_progress = -1.0

func _on_area_3d_body_entered(body):
	if body.get_class() == "CharacterBody3D":
		GameState.increase_score()
		$MeshInstance3D.hide()
		$AudioStreamPlayer.play()
		$AudioStreamPlayer.connect("finished", func(): self.queue_free())

func _process(delta):
	$MeshInstance3D.rotate_y(delta * ROTATION_SPEED)
	bob_progress += delta
	if bob_progress > 1.0:
		bob_progress -= 2.0
	$MeshInstance3D.position.y = sin(bob_progress * PI) * BOB_MAGNITUDE
	
