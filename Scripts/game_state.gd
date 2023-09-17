extends Node

signal points_changed

var test_points:int = 0

func set_points(pts):
	points_changed.emit()
	test_points = pts
