### GET TABLE OF (NORMALISED) CURVATURE OF F0 CONTOUR
# ===================================================
# Written for Praat 6.0.40

# script by Antoin Eoin Rodgers
# rodgeran@tcd.ie
# Phonetics and speech Laboratory, Trinity College Dublin

# Dependencies: @norm2MeanD, @vectAngPlane, @normalise

procedure k: .pitchObj, .normalise
    # calculates table of curvatures (K) by treating fo@TPa->fo@TPb and fo@TPb->fo@TPc
    # as coordinate vectors and calculating the angle in radians between each vector.
    # This convered to a ratio. K = (pi - theta) / pi --> if .normalise flagged, K is
    # normalised to the utterance.

    # create pitch table
    selectObject: .pitchObj
    noprogress Down to PitchTier
    .pitchTier = selected()
    noprogress Down to TableOfReal: "Semitones"
    .tableOfReal = selected()
    .table = To Table: "Frame"
    Append column: "K"
    Append column: "toneLike"
    selectObject: .pitchTier
    plusObject: .tableOfReal
    Remove

    # normalize time and F0 parameters to mean = 1
    selectObject: .table
    .normPitchTable = Copy: "normTable"
    @norm2MeanD: .normPitchTable, "Time"
    .tNorm = norm2MeanD.deltaMean
    @norm2MeanD: .normPitchTable, "F0"
    .f0Norm = norm2MeanD.deltaMean
    .frames = Get number of rows
    # create time and F0 vectors
    .t# = zero# (.frames)
    .fo# = zero# (.frames)
    for .i to .frames
        .t#[.i] = Get value: .i, "Time"
        .fo#[.i] = Get value: .i, "F0"
    endfor
    Remove

    .k[1] = 0
    .toneLike$[1] = ""
    # calculate angle between coordinate vectors (and L or H-ness based on concavity)
    for .i from 2 to .frames - 1
        .curCoords## = {{.t#[.i-1],.fo#[.i-1]},{.t#[.i],.fo#[.i]},{.t#[.i+1],.fo#[.i+1]}}
        @vectAngPlane: .curCoords##
        .k[.i] = (pi - vectAngPlane.rad) / pi
        if vectAngPlane.convex
            .toneLike$[.i] = "H"
        elsif vectAngPlane.concave
            .toneLike$[.i] = "L"
        else
            .toneLike$[.i] = ""
        endif
    endfor
    .k[.frames] = 0
    .toneLike$[.frames] = "0"

    # populate k table
    selectObject: .table
    for .i to .frames
        Set numeric value: .i, "Frame", .i
        Set numeric value: .i, "Time", .t#[.i] * .tNorm
        Set numeric value: .i, "F0", .fo#[.i] * .f0Norm
        Set numeric value: .i, "K", .k[.i]
        Set string value: .i, "toneLike", .toneLike$[.i]
    endfor

    # normalise to utterance
    if .normalise
        @normalise: .table, "K"
    endif

    # create table of Max K
    .max = Copy: "maxK"
    Append column: "maxK"
    Formula: "maxK", "0"
    # find max K frames
    for .i from 2 to .frames - 1
        .prevRow = .frames - .i
        .curRow = .frames - .i + 1
        .nextRow = .frames - .i  + 2
        .prevK = Get value: .prevRow, "K"
        .curK = Get value: .curRow, "K"
        .nextK = Get value: .nextRow, "K"
        if .curK > .nextK and .curK > .prevK
            Set numeric value: .curRow, "maxK", 1
        endif
    endfor
    # remove non-max K frames
    for .i to .frames
        .curRow = .frames - .i + 1
        .keepMe = Get value: .curRow, "maxK"
        if not .keepMe
            Remove row: .curRow
        endif
    endfor
    Remove column: "maxK"

    # create K min table
    selectObject: .table
    .min = Copy: "minK"
    Append column: "keepMe"
    Formula: "keepMe", "0"
    # find min K frames
    for .i from 2 to .frames - 1
        .prevRow = .frames - .i
        .curRow = .frames - .i + 1
        .nextRow = .frames - .i  + 2
        .prevK = Get value: .prevRow, "K"
        .curK = Get value: .curRow, "K"
        .nextK = Get value: .nextRow, "K"
        # and .curK < 0.02 added to remove spurious min K values
        if .curK <= .nextK and .curK <= .prevK
            # and .curK < 0.02
            Set numeric value: .curRow, "keepMe", 1
        endif
    endfor
    # remove non-max K frames
    for .i to .frames
        .curRow = .frames - .i + 1
        .keepMe = Get value: .curRow, "keepMe"
        if not .keepMe
            Remove row: .curRow
        endif
    endfor

    # remove surplus columns from K table
    Remove column: "keepMe"
    Remove column: "Frame"
    Remove column: "K"
endproc
