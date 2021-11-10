# K-MAX: DRAW SECOND TIME DERIVATIVE OF F0
# ========================================
# Written for Praat 6.0.40

# script by Antoin Eoin Rodgers
# rodgeran@tcd.ie
# Phonetics and speech Laboratory, Trinity College Dublin

# dependency: @drawTableLine

procedure drawK: .kMaxTable, .kTable, .normalise, .minT, .maxT, .t$, .k$,
        ... .col$, .widthCoeff
    .yAxisMin = 0
    .yAxisMax = pi * 1.1
    .rightText$ = "%f_0\""p(t)"
    selectObject: .kTable
    .yAxisMin = Get maximum: .k$
    .yAxisMax = Get minimum: .k$
    .yAxisMin = .yAxisMin * 1.1
    .yAxisMax = .yAxisMax * 1.1

    #Draw maxK points and magnitudes
    selectObject: .kMaxTable
    .numRows = Get number of rows
    Axes: .minT, .maxT, .yAxisMax, .yAxisMin
    Solid line
    Line width: 1 * .widthCoeff
    Colour: .col$
    for .i to .numRows
        .tempVal = Get value: .i, .t$
        .tempK = Get value: .i, .k$
        if .tempVal >= .minT and .tempVal <= .maxT
            Line width: 1
            Solid line
            Draw line: .tempVal, 0, .tempVal, .tempK
        endif
    endfor

    # Draw horizontal line at 0
    Draw line: .minT, 0, .maxT, 0

    #Draw K contour
    Line width: 1 * .widthCoeff
    @drawTableLine: .kTable, .t$, .k$, .minT, .maxT, 0
    Line width: 2
    Marks right every: 1, ceiling((.yAxisMin - .yAxisMax)/12),
        ...  "yes", "yes", "no"
    Text right: "yes", .rightText$
    Line width: 1
    Select outer viewport: 0, 6.5, 0, 4
endproc
