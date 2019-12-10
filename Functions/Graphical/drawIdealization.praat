### DRAW IDEALIZATION
# ===================
# Written for Praat 6.0.40

# script by Antoin Eoin Rodgers
# rodgeran@tcd.ie
# Phonetics and speech Laboratory, Trinity College Dublin

procedure drawIdealization: .pitchObject, .minT, .maxT, .minF0, max.F0
    Select outer viewport: 0, 6.5, 0, 3.35
    Solid line
    Line width: 2
    selectObject: .pitchObject
    Lime
    Draw semitones (re 100 Hz): .minT, .maxT, .minF0, max.F0, "no"
    Black
    Line width: 1
    Select outer viewport: 0, 6.5, 0, 4
endproc
