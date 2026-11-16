# C3POGRAM (MAIN )
# ================
# Written for Praat 6.0.40

# script by Antoin Eoin Rodgers
# rodgeran@tcd.ie
# Phonetics and speech Laboratory, Trinity College Dublin

# dependencies: @pitch2Table, @cpp, @findNearestTable,
#               @c3Po1stDraw, @drawC3pogram, @c3Po2ndDraw

# NB Redundant procedures removed from current script.
procedure c3Pogram: .param2, .pitch_scale, .paintSpect, .title$, .subtitle$,
         ... .grid, .sound, .tier, .minF0, .maxF0, .widthCoeff
     # arbitrary cut off values (below which pink in output graph)

    .type = .param2
    selectObject: .grid
    if .tier
        .refTier = Extract one tier: .tier
    else
        .refTier = 0
    endif
    .gridTable = Down to Table: "no", 3, "no", "no"
    .num_rows = Get number of rows
    .minT = Get value: 1, "tmin"
    .maxT = Get value: .num_rows, "tmax"
    Remove
    selectObject: .sound
    Scale intensity: 70

    @c3Po1stDraw: .sound, .paintSpect, .minT, .maxT, .refTier

    # get pitch table
    selectObject: .sound
    noprogress To Pitch (ac): 0.75/.minF0, .minF0, 15, "no",
        ... 0.03, 0.45, 0.01, 0.35, 0.14, .maxF0
    .pitchobj = selected()

    @pitch2Table: .pitchobj, 0
    selectObject: pitch2Table.table
    Rename: "pitch"

    # get second VQ table (only cpp implemented in the STH version)
    @cpp: .sound, .minF0, .maxF0, pitch2Table.table, "Time", "F0"
    .vqTable = cpp.table

    # draw cp3ogram
    @drawC3pogram: pitch2Table.table, .vqTable, .minT, .maxT, .minF0, .maxF0,
        ... .type, .pitch_scale, .widthCoeff
    @c3Po2ndDraw: .type, .pitch_scale, .title$, .subtitle$
    selectObject: .vqTable
    plusObject: pitch2Table.table
    plusObject: .pitchobj
    if .refTier
        plusObject: .refTier
    endif
    Remove
endproc
