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
    .x2 = Get value: 2, "Time"
    .x1 = Get value: 1, "Time"
    .dx = .x2 - .x1
    @secondDerivative: .table, "F0","K", .dx

    Formula: "toneLike", "if self[""K""] < 0 then ""H"" else ""L"" endif"
    Formula: "K", "if self[""K""] = undefined then 0 else self endif"

    .tempK = Copy: "tempK"
    Append column: "MinMax"
    .numRows = Get number of rows
    for .i from 2 to .numRows - 1
        .prevK = Get value: .i - 1, "K"
        .curK = Get value: .i, "K"
        .nextK = Get value: .i + 1, "K"
        .extrema =  (.prevK < .curK and .nextK < .curK and .curK > 0)
           ... or (.prevK > .curK and .nextK > .curK and .curK < 0)
        .root = .prevK * .nextK < 0
        if .extrema
            Set string value: .i, "MinMax", "Extreme"
        elsif .root
            Set string value: .i, "MinMax", "Root"
        endif
    endfor

    .max = Extract rows where column (text): "MinMax", "is equal to", "Extreme"
    Rename: "maxK"
    Remove column: "MinMax"
    selectObject: .tempK
    .min = Extract rows where column (text): "MinMax", "is equal to", "Root"
    Rename: "minK"
    Remove column: "MinMax"
    Remove column: "Frame"
    Remove column: "K"
    selectObject: .tempK
    Remove
endproc
