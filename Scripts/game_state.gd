extends Node

signal score_changed()
signal reset_level
signal next_level

var score = 0

func reset_score():
	score = 0
	score_changed.emit()

func increase_score():
	score += 1
	score_changed.emit()

func restart():
	reset_level.emit()

func level_progress():
	next_level.emit()
