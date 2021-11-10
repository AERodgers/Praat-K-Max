# GET TABLE STATS
# ===============
# Written for Praat 6.0.40

# script by Antoin Eoin Rodgers
# rodgeran@tcd.ie
# Phonetics and speech Laboratory, Trinity College Dublin

# dependencies: @keepCols

procedure tableStats: .table, .colX$, .colY$
    @keepCols: .table, "'.colX$' '.colY$'", "tableStats.shortTable"

    .numRows = Get number of rows
    .factor$ = Get column label: 1
    if .colX$ != .factor$
        @table2array: .shortTable, .colY$, "tableStats.colTemp$"
        Remove column: .colY$
        Append column: .colY$
        for .i to table2array.n
            Set string value: .i, .colY$, .colTemp$[.i]
        endfor
    endif

    if .numRows > 1
        .stDevY = Get standard deviation: .colY$
        .stDevY = number(fixed$(.stDevY, 3))
        .stDevX = Get standard deviation: .colX$
        noprogress To linear regression
        .linear_regression = selected()
        .linear_regression$ = Info
        .slope = extractNumber (.linear_regression$,
            ... "Coefficient of factor '.colX$': ")
        .slope = number(fixed$(.slope, 3))
        .intercept = extractNumber (.linear_regression$, "Intercept: ")
        .intercept = number(fixed$(.intercept, 3))
        .r = number(fixed$(.slope * .stDevX / .stDevY, 3))
        selectObject: .linear_regression
        .info$ = Info
        Remove
    else
        .stDevY = undefined
        .stDevX = undefined
        .linear_regression = undefined
        .linear_regression$ = "N/A"
        .slope = undefined
        .intercept = Get value: 1, .colY$
        .r = undefined
        .info$ = "N/A"
    endif

    selectObject: .shortTable
    .xMean = Get mean: .colX$
    .xMed = Get quantile: .colX$, 0.5
    .yMean = Get mean: .colY$
    .yMed = Get quantile: .colY$, 0.5
    Remove
endproc
