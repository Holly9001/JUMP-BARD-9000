extends Node

signal life_changed
signal reset_level

const max_life:float = 3.0

var life:float = max_life


func reset_life():
	life = max_life
	
func _process(delta):
	if delta > life:
		reset_level.emit()
	else:
		life -= delta
		life_changed.emit()

func restart():
	reset_level.emit()
