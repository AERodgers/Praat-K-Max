# MAX-K: GET TABLE OF (NORMALISED) CURVATURE OF F0 CONTOUR USING F0"(t)
# =====================================================================
# Written for Praat 6.0.40

# script by Antoin Eoin Rodgers
# rodgeran@tcd.ie
# Phonetics and speech Laboratory, Trinity College Dublin

# Dependencies: @secondDerivative, .PitchTable with .time$ and .f0$ columns

# calculates table of curvatures (K) via second time derivative of fo [f0"(t)]

procedure k: .table, .time$, .f0$
    selectObject: .table
    .numRows = Get number of rows
    .xn = Get value: .numRows, .time$
    .x[2] = Get value: 2, .time$
    .x[1] = Get value: 1, .time$
    .dx = .x[2] - .x[1]
    @secondDerivative: .table, .time$, .f0$, "K"

    Formula: "toneLike", "if self[""K""] < 0 then ""H"" else ""L"" endif"
    Formula: "K", "if self[""K""] = undefined then 0 else self endif"

    .tempK = Copy: "tempK"
    Append column: "MinMax"
    for .i from 2 to .numRows - 1
        .prevK = Get value: .i - 1, "K"
        .curK = Get value: .i, "K"
        .nextK = Get value: .i + 1, "K"
        .extrema =  (.prevK < .curK and .nextK < .curK and .curK > 0)
           ... or (.prevK > .curK and .nextK > .curK and .curK < 0)
        .rootLike = (.prevK * .nextK < 0)
            ... or (.prevK < .curK and .nextK < .curK and .curK < 0)
           ... or (.prevK > .curK and .nextK > .curK and .curK > 0)
        if .extrema
            Set string value: .i, "MinMax", "Extreme"
        elsif .rootLike
            Set string value: .i, "MinMax", "Rootlike"
        endif
    endfor

    .max = Extract rows where column (text): "MinMax", "is equal to", "Extreme"
    Remove column: "MinMax"
    .numRows = Get number of rows
    .mT[1] = Get value: 1, .time$
    .mT[2] = Get value: .numRows, .time$
    .x[2] = .xn
    # add boundary to if no MaxK nearby
    for .i to 2
        if abs(.x[.i] - .mT[.i]) > 0.02
            selectObject: .tempK
            .temp = Extract rows where column (number):
                ... .time$, "equal to", .x[.i]
            Remove column: "MinMax"
            plusObject: .max
            .newMax = Append
            selectObject: .temp
            plusObject: .max
            Remove
            .max = .newMax
            selectObject: .max
            Sort rows: .time$
            .numRows += 1
        endif
    endfor
    Rename: "maxK"

    selectObject: .tempK
    .min = Extract rows where column (text): "MinMax", "is equal to", "Rootlike"
    Remove column: "MinMax"
    .numRows = Get number of rows
    .mT[1] = Get value: 1, .time$
    .mT[2] = Get value: .numRows, .time$
    .x[2] = .xn
    # add boundary to if no MaxK nearby
    for .i to 2
        if abs(.x[.i] - .mT[.i]) > 0.02
            selectObject: .tempK
            .temp = Extract rows where column (number):
                ... .time$, "equal to", .x[.i]
            Remove column: "MinMax"
            plusObject: .min
            .newMin = Append
            selectObject: .temp
            plusObject: .min
            Remove
            .min = .newMin
            selectObject: .min
            Sort rows: .time$
            .numRows += 1
        endif
    endfor
    Rename: "minK"
    Remove column: "Frame"
    Remove column: "K"
    selectObject: .tempK
    Remove
endproc
