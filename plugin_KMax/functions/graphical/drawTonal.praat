# K-MAX: DRAW TONAL TIER INFORMATION
# ==================================
# Written for Praat 6.0.40

# script by Antoin Eoin Rodgers
# rodgeran@tcd.ie
# Phonetics and speech Laboratory, Trinity College Dublin

procedure drawTonal: .table, .tMin, .tMax, .f0MinST, .f0MaxST, .t$, .f0$,
        ... .col$, .widthCoeff
    # set picture window
    Line width: 1
    Solid line

    Select outer viewport: 0, 6.5, 0, 3.35
    Axes: .tMin, .tMax, .f0MinST, .f0MaxST
    selectObject: .table
    .idealTable = Copy: "TempIdeal"
    .offset = Vertical mm to world coordinates: 5
    Formula: .f0$, "12*log2(self/100) + .offset"

    .tShadow = Horizontal mm to world coordinates: 0.2
    .f0Shadow = Vertical mm to world coordinates: 0.2
    Append column: "T_shadow"
    Append column: "F0_shadow"
    Formula: "T_shadow", "self[.t$] + .tShadow"
    Formula: "F0_shadow", "self[.f0$]  - .f0Shadow"

    Colour: .col$
    .textExists = Get column index: "Text"
    if .textExists
        Formula: "Text", "replace$(self$, ""%"", ""\% "", 0)"
        Formula: "Text", "replace$(self$, ""_"", ""\_ "", 0)"
        Formula: "Text", """##"" + self$"
        Colour: "White"
        Scatter plot: "T_shadow", .tMin, .tMax, "F0_shadow",
            ... .f0MinST, .f0MaxST, "Text", 12, "no"
        Colour: .col$
        Scatter plot: .t$, .tMin, .tMax, .f0$,
            ... .f0MinST, .f0MaxST, "Text", 12, "no"
    endif

    Formula: .f0$, "self - .offset"
    Formula: "T_shadow", "self[.t$] + .tShadow"
    Formula: "F0_shadow", "self[.f0$]  - .f0Shadow"
    Line width: 2 * .widthCoeff
    Colour: "White"
    Scatter plot (mark): "T_shadow", .tMin, .tMax, "F0_shadow",
        ... .f0MinST, .f0MaxST, 2 + (.widthCoeff/2), "no", "x"
    Colour: .col$
    Line width: 2 * .widthCoeff
    Scatter plot (mark): .t$, .tMin, .tMax, .f0$,
        ... .f0MinST, .f0MaxST, 2 + (.widthCoeff/2), "no", "x"
    Remove

    # return picture window to default state
    Select outer viewport: 0, 6.5, 0, 4
    Line width: 1
    Select outer viewport: 0, 6.5, 0, 4
endproc
