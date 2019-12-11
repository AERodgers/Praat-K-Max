## STH MATHS FUNCTIONS
# ====================
# Written for Praat 6.0.40

# script by Antoin Eoin Rodgers
# rodgeran@tcd.ie
# Phonetics and speech Laboratory, Trinity College Dublin

procedure norm2MeanD: .table, .col$
    selectObject: .table
    .tempTable = Copy: "TempTable"
    Append column: "Delta"
    .numRows = Get number of rows
    for .i from 2 to .numRows
        .prevRow = Get value: .i - 1, .col$
        .curRow = Get value: .i, .col$
        Set numeric value: .i, "Delta", abs(.curRow - .prevRow)
    endfor
    Remove row: 1
    .deltaMean = Get mean: "Delta"
    Remove
    selectObject: .table
    Formula: .col$, "self[.col$]/.deltaMean"
endproc
