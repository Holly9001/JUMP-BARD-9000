from mido import MidiFile, tick2second, tempo2bpm
import csv
import sys
from os import walk

# MIDI FILES NEED TO BE 960 PPQ

def makeFile(name):
    mid = MidiFile(sys.path[0] + "/midis/" + name, clip=True)
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
                export_tracks[len(export_tracks) - 1].append(msg.name)
                print(msg.name)
            delta_time += msg.time
            if msg.type == 'note_on':
                export_tracks[len(export_tracks) - 1].append(tick2second(delta_time, 960, tempo))

    with open(sys.path[0] + '/' + name.replace(".mid", "") + '_keys.csv', 'w', newline='\n') as csvfile:
        spamwriter = csv.writer(csvfile, delimiter=' ',
                                quotechar='|', quoting=csv.QUOTE_MINIMAL)
        beat_time = 60 / tempo2bpm(tempo)
        metronome_row = []
        metronome_row.append("Metronome")
        for i in range(1, int(mid.length / beat_time) + 1):
            metronome_row.append(i * beat_time)
        
        spamwriter.writerow(metronome_row)
        print("metronome added")
        
        for export_track in export_tracks[1:]:
            spamwriter.writerow(export_track)
for (dirpath, dirnames, filenames) in walk(sys.path[0] + "/midis"):
    for filename in filenames:
        makeFile(filename)