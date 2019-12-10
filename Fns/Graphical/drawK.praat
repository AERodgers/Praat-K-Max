### DRAW CURVATURE
# ================
# Written for Praat 6.0.40

# script by Antoin Eoin Rodgers
# rodgeran@tcd.ie
# Phonetics and speech Laboratory, Trinity College Dublin

# dependency: @draw_table_line

procedure drawK: .kMaxTable, .kTable, .normalise, .minT, .maxT
    if .normalise
        .yAxisMax = 1.1
    else
        .yAxisMax = pi * 1.1
    endif

    #Draw maxK points and magnitudes
    selectObject: .kMaxTable
    .numRows = Get number of rows
    Axes: .minT, .maxT, 0, .yAxisMax
    Solid line
    Line width: 2
    Red
    for .i to .numRows
        .tempVal = Get value: .i, "Time"
        .tempK = Get value: .i, "K"
        Line width: 1
        Solid line
        Draw line: .tempVal, 0, .tempVal, .yAxisMax
    endfor
    Solid line

    #Draw K contour
    Line width: 1
    Axes: .minT, .maxT, 0, .yAxisMax
    @draw_table_line: .kTable, "Time", "K", .minT, .maxT, 0
    Marks right every: 1, 0.1, "yes", "yes", "no"
    Text right: "yes", "K score [(\pi - \tf)/\pi] normalised to utterance"
    Select outer viewport: 0, 6.5, 0, 4
endproc
