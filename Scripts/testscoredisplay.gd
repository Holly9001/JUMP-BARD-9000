extends Label

func _ready():
	GameState.life_changed.connect(update_value)
	
func update_value():
	self.text = str(GameState.life)
