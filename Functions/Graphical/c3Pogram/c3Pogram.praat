# C3POGRAM (MAIN )
# ================
# Written for Praat 6.0.40

# script by Antoin Eoin Rodgers
# rodgeran@tcd.ie
# Phonetics and speech Laboratory, Trinity College Dublin

# dependencies: @pitch2Table, @cpp, @find_nearest_table,
#               @c3po1stDraw, @drawC3pogram, @c3po2ndDraw

# NB Redundant procedures removed from current script.
procedure c3pogram: .param2, .pitch_scale, .paintSpect, .title$, .subtitle$,
         ... .grid, .sound, .tier, .minF0, .maxF0
     # arbitrary cut off values (below which pink in output graph)

    .type = .param2
    selectObject: .grid
    .refTier = Extract one tier: .tier
    .gridTable = Down to Table: "no", 3, "no", "no"
    .num_rows = Get number of rows
    .minT = Get value: 1, "tmin"
    .maxT = Get value: .num_rows, "tmax"
    Remove
    selectObject: .sound
    Scale intensity: 70

    @c3po1stDraw: .sound, .paintSpect, .minT, .maxT, .refTier

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
        ... .type, .pitch_scale
    @c3po2ndDraw: .type, .pitch_scale, .title$, .subtitle$
    selectObject: .vqTable
    plusObject: pitch2Table.table
    plusObject: .pitchobj
    plusObject: .refTier
    Remove
endproc
