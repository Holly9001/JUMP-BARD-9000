extends Node3D

const SWITCH_TIME = 1.5

@export var beat_type:String

@export var beat_interval : int
@export var on_beats : Array
@export var off_beats : Array

var beat_count :int= 0


var child_collisions
var children
var prev_state

func _ready():
	child_collisions = Utils.get_children_of_type(self, "CollisionShape3D")
	children = get_children()
	prev_state = MusicStates[beat_type]
	

func _process(_delta):
	if MusicStates[beat_type] != prev_state:
		prev_state = MusicStates[beat_type]
		
		beat_count += 1
		
		for b in on_beats:
			if beat_count == b:
				for i in child_collisions:
					i.disabled = false
			
				for i in children:
					i.visible = true
		
		for v in off_beats:
			if beat_count == v:
				for i in child_collisions:
					i.disabled = true
			
				for i in children:
					i.visible = false
		
		
		if beat_count >= beat_interval:
			beat_count = 0
		
	
	$BeatLabel.text = str(beat_count,' / ',beat_interval)
