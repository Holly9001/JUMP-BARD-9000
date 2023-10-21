extends Node


var state_array := {
	'bass_1':false,
	'bass_2':false,
	'drum_1':false,
	'drum_2':false,
	'lead_1':false,
	'lead_2':false,
	'backing_1':false,
	'backing_2':false
}

signal value_changed(beat_type)

func val_changed(beat_type):
	value_changed.emit(beat_type)

## make a func that enables/disables certain music tracks, u can just go in player and check for changes and then
## change all of them and reset when ut happnes. or u dont gotta reset. depends ig.
##i think i fugured out how to enable/disable individual tracks idk we'll see - holly

func reset_states():
	for i in state_array:
		state_array[i] = false
