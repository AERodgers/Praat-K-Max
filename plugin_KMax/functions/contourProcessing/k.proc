# K-MAX: USE F0"(t) TO ESTIMATE POINTS OF MINIMUM AND MAXIMUM CURVATURE
# =====================================================================
# Written for Praat 6.0.40

# script by Antoin Eoin Rodgers
# rodgeran@tcd.ie
# Phonetics and speech Laboratory, Trinity College Dublin

# Dependencies: @secondDerivative, .PitchTable with .time$ and .f0$ columns

procedure k: .table, .time$, .f0$

    # Get basic parameters and calculate second time derivative of f0 contour.
    selectObject: .table
    .numRows = Get number of rows
    .xn = Get value: .numRows, .time$
    .x[2] = Get value: 2, .time$
    .x[1] = Get value: 1, .time$
    .dx = .x[2] - .x[1]
    # K column = f0''
    @secondDerivative: .table, .time$, .f0$, "K"

    # Mark negative f0'' as potential H and positive fo'' as L
    Formula: "toneLike", "if self[""K""] < 0 then ""H"" else ""L"" endif"
    Formula: "K", "if self[""K""] = undefined then 0 else self endif"

    # Mark f0'' peaks in pos. space and troughs in neg. space as extrema.
    # Calculate near roots (f0'' peaks in neg. space and valleys pos. space)
    # and time points on either side  of true roots (i.e., where the next fo''
    # value changes sign), then mark each as "RootLike".
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

    # create table of f0'' extrema (MaxK table).
    .max = Extract rows where column (text): "MinMax", "is equal to", "Extreme"
    Remove column: "MinMax"
    .numRows = Get number of rows
    .mT[1] = Get value: 1, .time$
    .mT[2] = Get value: .numRows, .time$
    .x[2] = .xn
    # Add boundary time point if there is no MaxK near first or final time point
    # on the curve.
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
    # Add boundary time point if there is no RootLike near first or final time
    # point on the curve.
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
