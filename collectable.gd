extends Node3D


func _on_area_3d_body_entered(body):
	GameState.set_points(GameState.points + 1)
	self.queue_free()
