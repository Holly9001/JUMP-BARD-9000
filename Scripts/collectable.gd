extends Node3D


func _on_area_3d_body_entered(body):
	if body.get_class() == "CharacterBody3D":
		GameState.reset_life()
		self.queue_free()
