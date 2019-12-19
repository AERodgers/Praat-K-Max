# MAX-K: MODEL PHSYIOLOGICAL PITCH CONSTRAINTS
# ============================================
# Written for Praat 6.0.40

# script by Antoin Eoin Rodgers
# rodgeran@tcd.ie
# Phonetics and speech Laboratory, Trinity College Dublin

# calculates the physiological smoothing parameter using smoothing factor
# and fo"(t) of the ideal contour at each turning point.

procedure physioConstraints: .idealTable, .f0Table, .tOrig$, .smFac, .t$, .f0$
    # get .dx from first pair of defined values in .tOrig$ of .f0Table
    selectObject: .f0Table
    .curX = 1
    .x2 = Get value: 2, .tOrig$
    .x1 = Get value: 1, .tOrig$
    .dx = .x2 - .x1
    while .dx = undefined
        .curX += 1
        .x2 = Get value: .curX + 1, .tOrig$
        .x1 = Get value: .curX, .tOrig$
        .dx = .x2 - .x1
    endwhile

    selectObject: .idealTable
    .table = Copy: "newIdeal"
    # convert F0 to ST re 100 Hz
    Formula: .f0$, "12 * log2(self/100)"

    .numPoints = Get number of rows

    # Convert table of ideal points to array of coordinate
    .undefined = 0
    for .i from 2 to .numPoints - 1
        selectObject: .table
        .x[.i] = Get value: .i, .t$
        .x0 = Get value: .i - 1, .t$
        .x2 = Get value: .i + 1, .t$
        .xLeft[.i] = (.x[.i] + .x0) / 2
        .xRight[.i] = (.x[.i] + .x2) / 2
        .y1 = Get value: .i, .f0$
        .slope0 = Get value: .i - 1, "Slope"
        .intercept0 = Get value: .i - 1, "Intercept"
        .slope2 = Get value: .i, "Slope"
        .intercept2 = Get value: .i, "Intercept"
        .y0 = .x0 * .slope0 + .intercept0
        .y2 = .x2 * .slope2 + .intercept2
        .dxdy2[.i] = (.y0 + .y2 - 2 * .y1) / .dx ^ 2
        .undefined += (.dxdy2[.i] = undefined)
   endfor

   # check for undefined F0 values
   if .undefined
       feedback += 1
       warning = 1
       feedback$[feedback] =
           ... " Undefined value detected, probably at boundary. Please check."
   endif

    # create rectangular K with same area as K or stylization
    selectObject: .f0Table
    Append column: "Smoothing"
    for .i from 2 to .numPoints - 1
        Formula: "Smoothing", "if self[""Time""] >= .xLeft[.i] and "
            ... + "self[""Time""] <= .xRight[.i] then "
            ... + ".dxdy2[.i] / (.xRight[.i] - .xLeft[.i]) "
            ... + "else self[""Smoothing""] endif"
    endfor

    # incorporate smoothing factor, and calculate odd numbers for MPA
    Formula: "Smoothing", "2 * floor((.smFac + log10(abs(self))) / 2) + 1"
    Formula: "Smoothing", "if self = undefined then self = 1 else self endif"

    # remove surplus objects
    selectObject: .table
    Remove
endproc
