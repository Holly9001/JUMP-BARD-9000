from mido import MidiFile, tick2second, tempo2bpm
import csv

# MIDI FILES NEED TO BE 960 PPQ

mid = MidiFile('track.mid', clip=True)

tempo = 0
ccp = 0

for i in mid.tracks:
    for m in i:
        if m.type == 'time_signature':
            ccp = m.clocks_per_click
        if m.type == 'set_tempo':
            tempo = m.tempo
        if m.type != 'note_on' and m.type != 'note_off':
            print(m)
export_tracks = []

for track in mid.tracks:
    export_tracks.append([])
    delta_time = 0
    for msg in track:
        if msg.type == 'track_name':
            print(msg.name)
        delta_time += msg.time
        if msg.type == 'note_on':
            export_tracks[len(export_tracks) - 1].append(tick2second(delta_time, 960, tempo))

with open('keys.csv', 'w', newline='\n') as csvfile:
    spamwriter = csv.writer(csvfile, delimiter=' ',
                            quotechar='|', quoting=csv.QUOTE_MINIMAL)
    beat_time = 60 / tempo2bpm(tempo)
    metronome_row = []
    for i in range(1, int(mid.length / beat_time) + 1):
        metronome_row.append(i * beat_time)
    
    spamwriter.writerow(metronome_row)
    
    for export_track in export_tracks[1:]:
        spamwriter.writerow(export_track)