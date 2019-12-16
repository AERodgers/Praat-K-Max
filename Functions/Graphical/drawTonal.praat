# MAX-K: DRAW TONAL TIER INFORMATION
# ==================================
# Written for Praat 6.0.40

# script by Antoin Eoin Rodgers
# rodgeran@tcd.ie
# Phonetics and speech Laboratory, Trinity College Dublin

procedure drawTonal: .table, .tMin, .tMax, .f0MinST, .f0MaxSt, .colour$
    # set picture window
    Line width: 1
    Solid line

    Select outer viewport: 0, 6.5, 0, 3.35

    selectObject: .table
    .idealTable = Copy: "TempIdeal"
    .offset = (.f0MaxSt - .f0MinST)/15
    Formula: "ideal_F0", "12*log2(self/100) + .offset"

    Colour: .colour$
    .textExists = Get column index: "Text"
    if .textExists
        Formula: "Text", "replace$(self$, ""%"", ""\% "", 0)"
        Formula: "Text", "replace$(self$, ""_"", ""\_ "", 0)"
        Formula: "Text", """##"" + self$"
        Scatter plot: "ideal_T", .tMin, .tMax, "ideal_F0",
            ... .f0MinST, .f0MaxSt, "Text", 12, "no"
    endif

    Formula: "ideal_F0", "self - .offset"
    Line width: 2
    Scatter plot (mark): "ideal_T", .tMin, .tMax, "ideal_F0",
        ... .f0MinST, .f0MaxSt, 2, "no", "x"
    Remove

    # return picture window to default state
    Select outer viewport: 0, 6.5, 0, 4
    Line width: 1
    Select outer viewport: 0, 6.5, 0, 4
endproc
