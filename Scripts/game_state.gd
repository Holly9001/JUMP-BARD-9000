extends Node

signal points_changed

var points:int = 0

func set_points(pts):
	points = pts
	points_changed.emit()
