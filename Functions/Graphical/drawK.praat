# MAX-K: DRAW CURVATURE
# =====================
# Written for Praat 6.0.40

# script by Antoin Eoin Rodgers
# rodgeran@tcd.ie
# Phonetics and speech Laboratory, Trinity College Dublin

# dependency: @draw_table_line

procedure drawK: .kMaxTable, .kTable, .normalise, .minT, .maxT, .jk$, .col$
    if .jk$ = "k"
        .rightText$ = "Curvature [(\pi - \tf)/\pi] normalised to utterance"
        if .normalise
            .yAxisMin = 0
            .yAxisMax = 1.1
        else
            .yAxisMin = 0
            .yAxisMax = pi * 1.1
        endif
    else
        .rightText$ = "Curvature [%F_0''(t)]"
        selectObject: .kTable
            .yAxisMin = Get maximum: "K"
            .yAxisMax = Get minimum: "K"
            .yAxisMin += 1
            .yAxisMax -= 1
    endif

    #Draw maxK points and magnitudes
    selectObject: .kMaxTable
    .numRows = Get number of rows
    Axes: .minT, .maxT, .yAxisMin, .yAxisMax
    Solid line
    Line width: 2
    Colour: .col$

    for .i to .numRows
        .tempVal = Get value: .i, "Time"
        .tempK = Get value: .i, "K"
        Line width: 1
        Solid line
        Draw line: .tempVal, 0, .tempVal, .tempK
    endfor

    # Draw horizontal line at 0 if k = fo"(t)
    if .jk$ = "j"
        Draw line: .minT, 0, .maxT, 0
    endif

    #Draw K contour
    @draw_table_line: .kTable, "Time", "K", .minT, .maxT, 0
    Marks right every: 1, (.jk$ = "j") * ceiling((.yAxisMin - .yAxisMax)/12)
        ...  + (.jk$ = "k") * 0.1,
        ...  "yes", "yes", "no"
    Text right: "yes", .rightText$

    Select outer viewport: 0, 6.5, 0, 4
endproc
