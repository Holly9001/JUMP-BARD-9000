extends Label

func _ready():
	GameState.score_changed.connect(update_value)
	
func update_value():
	self.text = str(GameState.score)
