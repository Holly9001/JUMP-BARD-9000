extends Control

@onready var anim_player := $AnimationPlayer

@onready var track_reference :Dictionary={
	'lead_1':'AnimationPlayer/Lead_1_Player',
	'lead_2':'AnimationPlayer/Lead_2_Player',
	'bass_1':'AnimationPlayer/Bass_1_Player',
	'bass_2':'AnimationPlayer/Bass_2_Player',
	'drum_1':'AnimationPlayer/Drum_1_Player',
	'drum_2':'AnimationPlayer/Drum_2_Player',
	'backing_1':'AnimationPlayer/Backing_1_Player',
	'backing_2':'AnimationPlayer/Backing_2_Player'
}

@onready var l_1_p :AudioStreamPlayer= $AnimationPlayer/Lead_1_Player
@onready var l_2_p :AudioStreamPlayer= $AnimationPlayer/Lead_2_Player
@onready var bs_1_p :AudioStreamPlayer= $AnimationPlayer/Bass_1_Player
@onready var bs_2_p :AudioStreamPlayer= $AnimationPlayer/Bass_2_Player
@onready var d_1_p :AudioStreamPlayer= $AnimationPlayer/Drum_1_Player
@onready var d_2_p :AudioStreamPlayer= $AnimationPlayer/Drum_2_Player
@onready var bk_1_p :AudioStreamPlayer= $AnimationPlayer/Backing_1_Player
@onready var bk_2_p :AudioStreamPlayer= $AnimationPlayer/Backing_2_Player

const beat_offset:float = 0.1

func read_csv():
	var csv = []
	var file = FileAccess.open("res://keys/keys.csv", FileAccess.READ)
	while !file.eof_reached():
		var csv_rows = file.get_csv_line(" ")
		csv.append(csv_rows)
	file.close()
	return csv


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

## func where u choose song, and tracks. song is string (just the animation name) and tracks will be an enum maybe?

func _set_song(song, instruments):
	anim_player.current_animation = song
	
	# VERY SORRY IF THIS BREAKS SOMETHING I NEED IT  TO GO AWAY FOR NOW
#	var track :Animation= anim_player.get_animation(anim_player.get_current_animation())
#
#	for i in track_reference:
#		var track_id = track.find_track(track_reference[i],7)
#		track.track_set_enabled(track_id,0)
#
#	for i in instruments:
#		var track_id = track.find_track(track_reference[i],7)
#		track.track_set_enabled(track_id,1)
#
#		print(track.track_get_path(1))

## KEYFRAME CHECKS CHANGE VISIBILITY OF AUDIO NODES, WHEN VIS CHANGES, SIGNAL EMITTED!! EZ!!

func _bass_1(timing = 0):
	#print("bass 1")
	MusicStates.state_array['bass_1'] = !MusicStates.state_array['bass_1']
	MusicStates.beat_trigger('bass_1', timing)
func _bass_2(timing = 0):
	MusicStates.state_array['bass_2'] = !MusicStates.state_array['bass_2']
	MusicStates.beat_trigger('bass_2', timing)

func _lead_1():
	MusicStates.state_array['lead_1'] = !MusicStates.state_array['lead_1']
	MusicStates.beat_trigger('lead_1', 0)
func _lead_2():
	MusicStates.state_array['lead_2'] = !MusicStates.state_array['lead_2']
	MusicStates.beat_trigger('lead_2', 0)

func _drum_1(timing = 0): 
	MusicStates.state_array['drum_1'] = !MusicStates.state_array['drum_1']
	MusicStates.beat_trigger('drum_1', timing)
		
func _drum_2():
	MusicStates.state_array['drum_2'] = !MusicStates.state_array['drum_2']
	MusicStates.beat_trigger('drum_2', 0)

func _backing_1():
	MusicStates.state_array['backing_1'] = !MusicStates.state_array['backing_1']
	MusicStates.beat_trigger('backing_1', 0)

func _metronome(timing = 0):
	MusicStates.beat_trigger('metronome', 0)
	#print("we gnomin")

func generate_keys(keys, idx, animation, method):
	animation.add_track(Animation.TYPE_METHOD, 0)
	animation.track_set_path(0, ".")

	# Adds every keystamp from keys csv to an animation keyframe except for i = 0 which is the instrment name
	for i in range(keys[idx].size()):
		if i > 0:
			animation.track_insert_key(0, float(keys[idx][i]), {"method": method,"args": []})
		
	var key_index = animation.track_get_key_count(0) - 1
	var last_key_time = animation.track_get_key_time(0, key_index)
	while key_index > 0:
		var key_time = animation.track_get_key_time(0, key_index)
		var key_value = animation.track_get_key_value(0, key_index)
		if key_value and key_time - beat_offset > 0:
			key_value.args = [-1]
			animation.track_insert_key(0, key_time - beat_offset, key_value)
			print("test")
			#if key_time + beat_offset < last_key_time:
			key_value.args = [1]
			animation.track_insert_key(0, key_time + beat_offset, key_value)
			last_key_time = animation.track_get_key_time(0, key_index)
			key_index -= 1
		
		

func _ready():
	var keys = read_csv()
	var animation: Animation = anim_player.get_animation("Forest1")
	generate_keys(keys, 0, animation, '_metronome')
	#generate_keys(keys, 5, animation, '_backing_1')
	#generate_keys(keys, 6, animation, '_drum_1')
	#generate_keys(keys, 3, animation, '_bass_1')
	#for i in range(animation.get_track_count()):
		#print(animation.track_get_key_count(i))

	#_set_song('Forest1',['bass_1', 'drum_1'])
