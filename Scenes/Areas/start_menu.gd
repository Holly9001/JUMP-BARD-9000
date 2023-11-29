extends Control


func load_first():
	self.hide()
	$"../LevelManager".load_level(0)
	
