# GET TABLE OF CPP VALUES
# =======================
# Written for Praat 6.0.40

# script by Antoin Eoin Rodgers
# rodgeran@tcd.ie
# Phonetics and speech Laboratory, Trinity College Dublin

# dependencies: @removeRowsWhereNum

procedure cpp: .sound, .minF0, .maxF0, .pitchTable, .time$, .f0$
    # set arbitrary cut off value for within-utterance CPP
    .cppArbCutOff$ = "< cpp.mean - cpp.stDev * 1"

    selectObject: .sound
    noprogress To PowerCepstrogram: .minF0, 0.002, 5000, 75
    .powerCepstrogram = selected()

    selectObject: .pitchTable
    .table = Copy: "CPP"
    .numRows = Get number of rows
    Set column label (index): 2, .time$

    for .i to .numRows
        .time[.i] = Get value: .i, .time$
        .f0[.i] = Get value: .i, .f0$
    endfor

    for .i to .numRows
        selectObject: .powerCepstrogram
        noprogress To PowerCepstrum (slice): .time[.i]
        .powerCepstralSlice = selected()
        .cpp[.i] = Get peak prominence: .minF0, .maxF0, "Parabolic",
            ... 0.001, 0, "Straight", "Robust"
        Remove
    endfor

    selectObject: .table
    Append column: "value"
    for .i to .numRows
        Set numeric value: .i, "value", .cpp[.i]
    endfor
    .mean = Get mean: "value"
    .stDev = Get standard deviation: "value"
    @removeRowsWhereNum: .table, "value",
        ... .cppArbCutOff$

    selectObject: .powerCepstrogram
    Remove
endproc
