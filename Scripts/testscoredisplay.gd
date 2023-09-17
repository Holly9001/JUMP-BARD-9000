extends Label

func _ready():
	GameState.points_changed.connect(update_value)
	
func update_value():
	self.text = str(GameState.test_points)
