# SECOND DERIVATIVE OF A CONTINUOUS CONTOUR
# =========================================
# Written for Praat 6.0.40

# script by Antoin Eoin Rodgers
# rodgeran@tcd.ie
# Phonetics and speech Laboratory, Trinity College Dublin
# October 10 - December 16, 2019

# Calculates the second time derivative of a continous contour
# assuming that the x axis has a constant delta of .dx.
# Note: 1st and last rows columns will be undefined

procedure secondDerivative: .table, .yCol$, .dxdy2Col$, .dx
    selectObject: .table
    Append row
    Insert row: 1
    .y0$ = .yCol$ + "0"
    .y2$ = .yCol$ + "2"
    Append column: .y0$
    Append column: .y2$

    .dxdy2Exists = Get column index: .dxdy2Col$
    if not .dxdy2Exists
        Append column: .dxdy2Col$
    endif
    numRows = Get number of rows
    for  .i from 2 to numRows - 1
        .curY = Get value: .i, .yCol$
        Set numeric value: .i + 1, .y0$ , .curY
        Set numeric value: .i - 1, .y2$ , .curY
    endfor
    Remove row: 1
    Remove row: numRows - 1
    Formula: .dxdy2Col$, "(self[.y0$] + self[.y2$] - 2 * self[.yCol$]) / .dx"
    Remove column: .y0$
    Remove column: .y2$
endproc
