extends Control

@onready var anim_player := $AnimationPlayer

const beat_offset:float = 0.1

func read_csv(name):
	var csv = []
	var file = FileAccess.open("res://keys/" + name + ".csv", FileAccess.READ)
	while !file.eof_reached():
		var csv_rows = file.get_csv_line(" ")
		csv.append(csv_rows)
	file.close()
	return csv


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func _bass_1(timing = 0):
	#print("bass 1")
	MusicStates.state_array['bass_1'] = !MusicStates.state_array['bass_1']
	MusicStates.beat_trigger('bass_1', timing)
func _bass_2(timing = 0):
	MusicStates.state_array['bass_2'] = !MusicStates.state_array['bass_2']
	MusicStates.beat_trigger('bass_2', timing)

func _lead_1(timing = 0):
	MusicStates.state_array['lead_1'] = !MusicStates.state_array['lead_1']
	MusicStates.beat_trigger('lead_1', timing)
func _lead_2(timing = 0):
	MusicStates.state_array['lead_2'] = !MusicStates.state_array['lead_2']
	MusicStates.beat_trigger('lead_2', timing)

func _drum_1(timing = 0): 
	MusicStates.state_array['drum_1'] = !MusicStates.state_array['drum_1']
	MusicStates.beat_trigger('drum_1', timing)
		
func _drum_2(timing = 0):
	MusicStates.state_array['drum_2'] = !MusicStates.state_array['drum_2']
	MusicStates.beat_trigger('drum_2', timing)

func _backing_1(timing = 0):
	MusicStates.state_array['backing_1'] = !MusicStates.state_array['backing_1']
	MusicStates.beat_trigger('backing_1', timing)

func _metronome(timing = 0):
	MusicStates.beat_trigger('metronome', timing)
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
		
		

func load_song(name):
	var keys = read_csv(name)
	var animation: Animation = anim_player.get_animation(name)
	generate_keys(keys, 0, animation, '_metronome')
	generate_keys(keys, 1, animation, '_lead_1')
	generate_keys(keys, 2, animation, '_lead_2')
	generate_keys(keys, 3, animation, '_bass_1')
	generate_keys(keys, 4, animation, '_bass_2')
	generate_keys(keys, 5, animation, '_backing_1')
	generate_keys(keys, 6, animation, '_drum_1')
	generate_keys(keys, 7, animation, '_drum_2')

func _ready():
	for i in anim_player.get_animation_list():
		load_song(i)
