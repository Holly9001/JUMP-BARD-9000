extends Node3D


func _on_area_3d_body_entered(body):
	if body.get_class() == "CharacterBody3D":
		GameState.increase_score()
		self.queue_free()
