# K-MAX: DRAW IDEALIZATION
# ========================
# Written for Praat 6.0.40

# script by Antoin Eoin Rodgers
# rodgeran@tcd.ie
# Phonetics and speech Laboratory, Trinity College Dublin

procedure drawIdealization: .pitchObj, .minT, .maxT, .minF0, .maxF0,
        ... .colour$, .widthCoeff
    Select outer viewport: 0, 6.5, 0, 3.35
    Solid line
    Line width: 3 * .widthCoeff + 4
    selectObject: .pitchObj
    Colour: "White"
    Draw semitones (re 100 Hz): .minT, .maxT, .minF0, .maxF0, "no"

    Line width: 3 * .widthCoeff
    selectObject: .pitchObj
    Colour: .colour$
    Draw semitones (re 100 Hz): .minT, .maxT, .minF0, .maxF0, "no"
    Black
    Line width: 1
    Select outer viewport: 0, 6.5, 0, 4
endproc
