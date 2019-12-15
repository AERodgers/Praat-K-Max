# MAX-K: MODEL PHSYIOLOGICAL PITCH CONSTRAINTS
# ============================================
# Written for Praat 6.0.40

# script by Antoin Eoin Rodgers
# rodgeran@tcd.ie
# Phonetics and speech Laboratory, Trinity College Dublin

procedure physioConstraintsK: .pointsTable, .f0Table, .timeStep,
    ... .smoothingFactor
    
	selectObject: .pointsTable
    .table = Copy: "newIdeal"

    # convert F0 to ST re 100 Hz
    Formula: "F0", "12 * log2(self/100)"

    .numPoints = Get number of rows
    Append column: "K"
    Set numeric value: 1, "K", 0
    Set numeric value: .numPoints, "K", 0

    # Convert table of ideal points to array of coordinate
    .absY = 0
    for .i to .numPoints - 1
        selectObject: .table
        .x1[.i] = Get value: .i, "Time"
        .x2[.i] = Get value: .i + 1, "Time"
        .y1[.i] = Get value: .i, "F0"
        .y2[.i] = Get value: .i + 1, "F0"
        .absY += abs(.y2[.i] - .y1[.i])
   endfor

   # check for undefined F0 values
   if .absY = undefined
       comment$ += " Contour contains undefined F0 "
       if userInput
           beginPause: "ERROR"
           comment: "Current contour contains undefined F0"
           comment: "Most likely in boundary tier"
           endPause: "Check manually", 1
       endif
   endif

   # calculate mean absolute delta of F0 pairs across linear stylized contour
   .tMin = Get value: 1, "Time"
   .tMax = Get value: .numPoints, "Time"
   .frames = (.tMax - .tMin) / .timeStep
   .meanDofF0 = .absY / .frames

    # calculate K of each angle at ideal points
    for .i to .numPoints - 2
        .curCoords## = {{.x1[.i] / .timeStep, .y1[.i] / .meanDofF0},
            ... {.x2[.i]  / .timeStep, .y2[.i] / .meanDofF0},
            ... {.x2[.i + 1] / .timeStep,.y2[.i + 1] / .meanDofF0}}
        @vectAngPlane: .curCoords##
        Set numeric value: .i + 1, "K", vectAngPlane.k
    endfor

    # calculate intertia smoothing parameter (for triangular mean point avera smoothing)
    selectObject: .f0Table
    Append column: "PhysioSmoothing"
    for .i to .numPoints - 1
        selectObject: .table
        .x1[.i] = Get value: .i, "Time"
        .x2[.i] = Get value: .i + 1, "Time"
        .y1[.i] = Get value: .i, "K"
        .y2[.i] = Get value: .i + 1, "K"
        #.xMid[.i] = .x1[.i] + (.x2[.i] - .x1[.i]) * .y1[.i] / (.y1[.i] + .y2[.i])
        .xMid[.i] = .x1[.i] + (.x2[.i] - .x1[.i])/2
        selectObject: .f0Table
        Formula: "PhysioSmoothing", "if self[""Time""] >= .x1[.i] and "
            ... + "self[""Time""] <= .xMid[.i] then "
            ... + ".y1[.i] "
            ... + "else self endif"
        Formula: "PhysioSmoothing", "if self[""Time""] >= .xMid[.i] and "
            ... + "self[""Time""] <= .x2[.i] then "
            ... + ".y2[.i] "
            ... + "else self endif"
    endfor

    Formula: "PhysioSmoothing", "(1 + floor(.smoothingFactor * self))*2+1"
    Formula: "PhysioSmoothing", "if self = undefined then self = 1 else self endif"
    # remove surplus objects
    selectObject: .table
    Remove
endproc
