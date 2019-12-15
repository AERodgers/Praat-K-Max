### GET TABLE OF (NORMALISED) CURVATURE OF F0 CONTOUR USING F0#(t)
# ================================================================
# Written for Praat 6.0.40

# script by Antoin Eoin Rodgers
# rodgeran@tcd.ie
# Phonetics and speech Laboratory, Trinity College Dublin

# Dependencies: @secondDerivative

procedure j: .table
    # calculates table of curvatures (K) via the second time derivative of fo [f0"(t)]

    selectObject: .table
    .numRows = Get number of rows
    .xn = Get value: .numRows, "Time"
    .x2 = Get value: 2, "Time"
    .x1 = Get value: 1, "Time"
    .dx = .x2 - .x1
    @secondDerivative: .table, "F0","K", .dx

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
    Rename: "maxK"
    Remove column: "MinMax"
    .numRows = Get number of rows
    .max1T = Get value: 1, "Time"
    .maxNT = Get value: .numRows, "Time"

    # add initial boundary to if no MaxK near onset
    if abs(.x1 - .max1T) > 0.02
        selectObject: .tempK
        .temp = Extract rows where column (number): "Time", "equal to", .x1
        Rename: "maxK"
        Remove column: "MinMax"
        plusObject: .max
        .newMax = Append
        selectObject: .temp
        plusObject: .max
        Remove
        .max = .newMax
        selectObject: .max
        Sort rows: "Time"
        .numRows += 1
    endif

    # add final boundary to if no maxK near offset
    if abs(.xn - .maxNT) > 0.02
        selectObject: .tempK
        .temp = Extract rows where column (number): "Time", "equal to", .maxNT
        Rename: "maxK"
        Remove column: "MinMax"
        plusObject: .max
        .newMax = Append
        selectObject: .temp
        plusObject: .max
        Remove
        .max = .newMax
        selectObject: .max
        Sort rows: "Time"
        .numRows += 1
    endif

    selectObject: .tempK
    .min = Extract rows where column (text): "MinMax", "is equal to", "Rootlike"
    Rename: "minK"
    Remove column: "MinMax"
    Remove column: "Frame"
    Remove column: "K"
    selectObject: .tempK
    Remove
endproc
