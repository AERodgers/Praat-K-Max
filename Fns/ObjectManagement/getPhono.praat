### STH OBJECT AND VARIABLE MANAGEMENT FUNCTIONS
# ==============================================
# Written for Praat 6.0.40

# script by Antoin Eoin Rodgers
# rodgeran@tcd.ie
# Phonetics and speech Laboratory, Trinity College Dublin

procedure getPhono: .keepTiers#, .boundary$, .textgrid
    selectObject: .textgrid
    # create trimmed textgrid
    .trimmedGrid = Copy: "temp"
    .numTiers = Get number of tiers
    for .i to .numTiers
        .curTier = .numTiers + 1 - .i
        .deleteMe = 1
        for .j to size(.keepTiers#)
            if .curTier = .keepTiers#[.j]
                .deleteMe = 0
            endif
        endfor
        if .deleteMe
            Remove tier: .curTier
        endif
    endfor

    # get table
    .trimmedTable = Down to Table: "no", 3, "yes", "no"
    # convert table text to phonological string
    .text$ = ""
    .numRows = Get number of rows
    .initBoundary = 0
    for .i to .numRows
        .curTier$ = Get value: .i, "tier"
        .curElem$ = Get value: .i, "text"
        if .curTier$ = .boundary$ and .initBoundary = 0
            .curElem$ = "%" + .curElem$
            .initBoundary = 1
        elsif .curTier$ = .boundary$
            .curElem$ += "%"
            .initBoundary = 0
        endif
       .text$ += .curElem$
        if .i < .numRows and .curElem$ != ""
            .text$ += " "
        endif
    endfor
    .text$ = replace$ (.text$, "_ ", "_", 0)
    .text$ = replace$ (.text$, " _", "_", 0)
    .text$ = replace$ (.text$, " +", "+", 0)

    plusObject: .trimmedGrid
    Remove
endproc
