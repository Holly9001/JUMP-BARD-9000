extends Node

signal points_changed

const initial_life:float = 5.0
var life:float = initial_life

func reset_life():
	life = initial_life
	points_changed.emit()
	
func _process(delta):
	if delta > life:
		reset_life()
		get_tree().reload_current_scene()
	life -= delta
	points_changed.emit()
