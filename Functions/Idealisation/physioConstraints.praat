# MAX-K: MODEL PHSYIOLOGICAL PITCH CONSTRAINTS
# ============================================
# Written for Praat 6.0.40

# script by Antoin Eoin Rodgers
# rodgeran@tcd.ie
# Phonetics and speech Laboratory, Trinity College Dublin

# calculates the physiological smoothing parameter using fo"(t) of the ideal
# contour at each turning point, i, (as elsewhere it is equal to zero). The
# smoothing factor is applied as log2(fo"(t[i])) between local turning points.

procedure physioConstraints: .pointsTable, .f0Table, .dx, .smoothVal
    selectObject: .pointsTable
    .table = Copy: "newIdeal"

    # convert F0 to ST re 100 Hz
    Formula: "ideal_F0", "12 * log2(self/100)"

    .numPoints = Get number of rows

    # Convert table of ideal points to array of coordinate
    .undefined = 0
    for .i from 2 to .numPoints - 1
        selectObject: .table
        .x[.i] = Get value: .i, "ideal_T"
        .x0 = Get value: .i - 1, "ideal_T"
        .x2 = Get value: .i + 1, "ideal_T"
        .xLeft[.i] = (.x[.i] + .x0) / 2
        .xRight[.i] = (.x[.i] + .x2) / 2
        .y1 = Get value: .i, "ideal_F0"
        .slope0 = Get value: .i - 1, "Slope"
        .intercept0 = Get value: .i - 1, "Intercept"
        .slope2 = Get value: .i, "Slope"
        .intercept2 = Get value: .i, "Intercept"
        .y0 = .x0 * .slope0 + .intercept0
        .y2 = .x2 * .slope2 + .intercept2
        .dxdy2[.i] = (.y0 + .y2 - 2 * .y1) / .dx
        .undefined += (.dxdy2[.i] = undefined)
   endfor

   # check for undefined F0 values
   if .undefined
       feedback += 1
       warning = 1
       feedback$[feedback] =
           ... " Undefined value detected, probably at boundary. Please check."
   endif

    selectObject: .f0Table
    Append column: "Smoothing"
    for .i from 2 to .numPoints - 1
        Formula: "Smoothing", "if self[""Time""] >= .xLeft[.i] and "
            ... + "self[""Time""] <= .xRight[.i] then "
            ... + "0.5 * .smoothVal * log10(abs(.dx * .dxdy2[.i] / "
            ... + "(.xRight[.i] - .xLeft[.i]))) "
            ... + "else self[""Smoothing""] endif"
    endfor

    # convert Smoothing to array of odd numbers
    Formula: "Smoothing", "2 * floor(self / 2) + 1"
    Formula: "Smoothing", "if self=undefined then self=1 else self endif"

    # remove surplus objects
    selectObject: .table
    Remove
endproc
