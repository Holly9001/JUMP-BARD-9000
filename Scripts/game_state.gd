extends Node

signal life_changed

signal reset_level

const max_life:float = 3.0

var life:float = max_life

func reset_life():
	life = max_life
	life_changed.emit()


# maybe make this update slower for performance?
func _process(delta):
	if delta > life:
		life = max_life
		reset_level.emit()
	life -= delta
	life_changed.emit()
