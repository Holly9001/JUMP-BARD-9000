extends Control

@onready var dash_bar :ProgressBar= $DashBar

@onready var player := get_parent()

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if player.beats_counter > -1:
		dash_bar.value = lerp(dash_bar.value,float(player.beats_to_charge_dash - player.beats_counter)/float(player.beats_to_charge_dash) * 100,0.6)
		print(dash_bar.value)
	else: dash_bar.value = lerp(dash_bar.value,0.0,0.2)
		
