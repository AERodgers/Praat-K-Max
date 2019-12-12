#THIS WON'T WORK


@physioConstraintsJ: 1016, 1015, 0.0125

### MODEL PHSYIOLOGICAL PITCH CONSTRAINTS
# =======================================
# Written for Praat 6.0.40

# script by Antoin Eoin Rodgers
# rodgeran@tcd.ie
# Phonetics and speech Laboratory, Trinity College Dublin

procedure physioConstraintsJ: .pointsTable, .f0Table, .timeStep
    selectObject: .pointsTable
    .table = Copy: "newIdeal"

    # convert F0 to ST re 100 Hz
    Formula: "F0", "12 * log2(self/100)"

    .numPoints = Get number of rows
    Append column: "Jerk"
    Set numeric value: 1, "Jerk", 0
    Set numeric value: .numPoints, "Jerk", 0

    # Convert table of ideal points to array of coordinate
    .undefined = 0
    for .i from 2 to .numPoints - 1
        selectObject: .table
        .x1 = Get value: .i, "Time"
        .y1 = Get value: .i, "F0"
		.slope0 = Get value: .i - 1, "Slope"
		.intercept0 = Get value: .i - 1, "Intercept"
		.slope2 = Get value: .i, "Slope"
		.intercept2 = Get value: .i, "Intercept"
		.x0 = .x1 - .timeStep
		.y0 = .x0 * .slope0 + .intercept0
		.x2 = .x1 + .timeStep
		.y2 = .x2 * .slope2 + .intercept2
		.jerk[.i] = (.y0 + .y2 - 2 * .y1) / .timeStep
		.x[.i] = .x1
		Set numeric value: .i, "Jerk", .jerk[.i]
		.undefined += (.jerk[.i] = undefined)
   endfor

   # check for undefined F0 values
   if .undefined
       comment$ += " Undefined values defected"
       if userInput
           beginPause: "ERROR"
           comment: "Current contour contains undefined F0"
           comment: "Most likely in boundary tier"
           endPause: "Check manually", 1
       endif
   endif

    # Smooth second derivative
    selectObject: .f0Table
    .f0TableNew = Copy: "newF0"
    Append column: "SmoothJerk"
    for .i from 1 to .numPoints - 1
        selectObject: .table
        .x1[.i] = Get value: .i, "Time"
        .x2[.i] = Get value: .i + 1, "Time"
        .y1[.i] = Get value: .i, "Jerk"
        .y2[.i] = Get value: .i + 1, "Jerk"
        #.xMid[.i] = .x1[.i] + (.x2[.i] - .x1[.i]) * .y1[.i] / (.y1[.i] + .y2[.i])
        .xMid[.i] = .x1[.i] + (.x2[.i] - .x1[.i])/2
        selectObject: .f0TableNew

        if .y1[.i]*.y2[.i] != 0
            Formula: "SmoothJerk", "if self[""Time""] >= .x1[.i] and "
                ... + "self[""Time""] <= .xMid[.i] then "
                ... + "((cos(pi/(.xMid[.i] - .x1[.i]) "
                ... + "* (self[""Time""] - .x1[.i])) + 1) / 2) "
                ... + "* .y1[.i] "
                ... + "else self endif"

            Formula: "SmoothJerk", "if self[""Time""] >= .xMid[.i] and "
                ... + "self[""Time""] <= .x2[.i] then "
                ... + "(1-(cos(pi/(.x2[.i] - .xMid[.i]) "
                ... + "* (self[""Time""] - .xMid[.i])) + 1) / 2) "
                ... + "* .y2[.i] "
                ... + "else self endif"
       
	   elsif .y1[.i]
            Formula: "SmoothJerk", "if self[""Time""] >= .x1[.i] and "
                ... + "self[""Time""] <= .x2[.i] then "
                ... + "((cos(pi/(.x2[.i] - .x1[.i]) "
                ... + "* (self[""Time""] - .x1[.i])) + 1) / 2) "
                ... + "* .y1[.i] "
                ... + "else self endif"
        else
            Formula: "SmoothJerk", "if self[""Time""] >= .x1[.i] and "
                ... + "self[""Time""] <= .x2[.i] then "
                ... + "(1-(cos(pi/(.x2[.i] - .x1[.i]) "
                ... + "* (self[""Time""] - .x1[.i])) + 1) / 2) "
                ... + "* .y2[.i] "
                ... + "else self endif"
        endif
    endfor
	Formula: "SmoothJerk", "if self = undefined then 0 else self endif"
pause
    .numRows = Get number of rows
    Append column: "SmoothAcc"
	.firstAcc = Get value: 1, "SmoothJerk"
	Set numeric value: 1, "SmoothAcc", .firstAcc
	for .i from 2 to .numRows
	    .curSum = Get value: .i - 1, "SmoothAcc"
		.curVal = Get value: .i, "SmoothJerk"
		.newSum = Set numeric value: .i, "SmoothAcc", .curSum + .curVal * .timeStep
	endfor

    Append column: "SmoothF0"
	.firstF0 = Get value: 1, "IdealF0"
	Set numeric value: 1, "SmoothF0", .firstF0
	for .i from 2 to .numRows
	    .curSum = Get value: .i - 1, "SmoothF0"
		.curVal = Get value: .i, "SmoothAcc"
		.newSum = Set numeric value: .i, "SmoothF0", .curSum + .curVal  * .timeStep
	endfor
	

    # remove surplus objects
    selectObject: .table
    #Remove
endproc
