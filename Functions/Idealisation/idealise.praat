### STH GET IDEAL TONAL TARGETS
# =============================
# Written for Praat 6.0.40

# script by Antoin Eoin Rodgers
# rodgeran@tcd.ie
# Phonetics and speech Laboratory, Trinity College Dublin

# Contour idealisation
procedure idealise: .sound, .grid, .pitchObj, .minF0, .maxF0, .kTable, .kMin,
        ... .smoothCoarse, .smoothFine
    .tiersToKeep$[1] = t_tier$
    .tiersToKeep$[2] = b_tier$

    # process pitch object
    selectObject: .pitchObj
    .timeStep = Get time step
    @pitch2Table: .pitchObj, 0
    .pitchTable  = pitch2Table.table

    # process tiers (get array of elbow and boundary times)
    selectObject: .grid
    .sound$ = selected$ ("TextGrid")
    .tempGrid = Copy: "tempGrid"
    .numTiers = Get number of tiers
    for .i to .numTiers
        .curTier =  .numTiers - .i + 1
        .curTier$ = Get tier name: .curTier
        if .curTier$ != .tiersToKeep$[1] and .curTier$ != .tiersToKeep$[2]
            Remove tier: .curTier
        endif
    endfor

    # Get time array from trimmed .tempGrid
    .tempKmax = Down to Table: "yes", 3, "yes", "no"
    # remove duplicate time points
    Sort rows: "tmin"
    .numRows = Get number of rows
    for .i to .numRows - 1
        .curRow =  .numRows - .i + 1
        .curT = Get value: .curRow, "tmin"
        .prevT = Get value: .curRow - 1, "tmin"
        if .curT = .prevT
            Remove row: .curRow
        endif
    endfor
    # Remove surplus Columns
    Remove column: "line"
    Remove column: "tmax"
    Remove column: "tier"
    Set column label (index): 1, "Time"
    Append column: "MinMax"
    # get array of boundary and elbow times
    .numElbows = Get number of rows
    for .i to .numElbows
        .elbow[.i] = Get value: .i, "Time"
        .text$[.i] = Get value: .i, "text"

        if .i = 1
            .boundaryTime[1] = .elbow[.i]
            .text$[.i] = "%" + replace$(.text$[.i], "0", "", 1)
        elsif .i = .numElbows
            .boundaryTime[2] = .elbow[.i]
            .text$[.i] = replace$(.text$[.i], "0", "", 1) + "%"
        endif
    endfor
    # remove text column
    Remove column: "text"

    # remove temporary text grid
    selectObject: .tempGrid
    Remove

    # get T and F0 of boundaries, add start and end value to .kMin table
    for .i to 2
        selectObject: .pitchObj
        .boundaryF0[.i] = Get value at time: .boundaryTime[.i],
            ... "semitones re 100 Hz", "Linear"
        selectObject: .kMin
        Insert row: 1
        Set numeric value: 1,  "Time", .boundaryTime[.i]
        Set numeric value: 1,  "F0", .boundaryF0[.i]
    endfor
    Sort rows: "Time"

    # merge min and max tiers
    selectObject: .kMin
    .tempKmin = Copy: "MinMaxKmin"
    Remove column: "toneLike"
    Remove column: "F0"
    Append column: "MinMax"
    selectObject: .tempKmax
    Formula: "MinMax", "1"
    selectObject: .tempKmin
    Formula: "MinMax", "0"
    plusObject: .tempKmax
    .minMaxK = Append
    Rename: "MinMax"
    Sort rows: "Time"

    # remove rows with same Time point (prioritize keeping minK)
    .numRows = Get number of rows
    for .i to .numRows - 1
        .curRow = .numRows - .i + 1
        .curT = Get value: .curRow, "Time"
        .lastT = Get value: .curRow - 1, "Time"
        .curMinMax = Get value: .curRow, "MinMax"
        if .curT = .lastT and .curMinMax = 0
            Remove row: .curRow
        elsif .curT = .lastT and .curMinMax = 1
            Remove row: .curRow - 1
        endif
    endfor
    # Remove temporary tables
    selectObject: .tempKmin
    plusObject: .tempKmax
    Remove

    # Get start and end times for linear regression calculations
    # based on minK first after Max K(n) and last before MaxK(n+1)
    selectObject: .minMaxK
    for .i to .numElbows - 1
        @find_nearest_table: .elbow[.i], .minMaxK, "Time"
        .firstKMinT = Get value: find_nearest_table.index + 1, "Time"
        .noKMins = Get value: find_nearest_table.index + 1, "MinMax"
        @find_nearest_table: .elbow[.i+1], .minMaxK, "Time"
        .lastKMinT = Get value: find_nearest_table.index - 1, "Time"

        #if no intervening MinK, use elbow time at linear regression start and end points
        if .noKMins
            .firstKMinT = .elbow[.i]
            .lastKminT = .elbow[.i + 1]
        endif

        # if only one K min between Kmax points, treat it as inflexion point and
        # use nearest time points to kMin to calculate slope
        if .firstKMinT = .lastKMinT
            .firstKMinT -= .timeStep - 0.0001
            .lastKMinT += .timeStep + 0.0001
        endif

        # add first and last min K values to appropriate arrays
        .lineStart[.i] = .firstKMinT
        .lineEnd[.i]  = .lastKMinT
    endfor

    # get slope and intercept of linear Fn between each lineStart and lineEnd pair
    for .i to .numElbows - 1
        selectObject: .pitchTable
        .tmpF0Tbl = Copy: "tmpF0Tbl"
        @removeRowsWhereNum: .tmpF0Tbl, "Time", "> idealise.lineEnd[idealise.i]"
        @removeRowsWhereNum: .tmpF0Tbl, "Time", "< idealise.lineStart[idealise.i]"
        Formula: "F0", "12*log2(self/100)"
        @tableStats: .tmpF0Tbl, "Time", "F0"
        .slope[.i] = tableStats.slope
        .intercept[.i] = tableStats.intercept

        # error check
        if .slope[.i] = undefined
            selectObject: .tmpF0Tbl
            .intercept[.i] = Get mean: "F0"
            .slope[.i] = 0
            comment$ += " slope " + string$(.i) + "-> 0, "
                ... + "intercept -> " + fixed$(.intercept[.i], 1) + "."
            if userInput
                beginPause: "WARNING"
                comment: "Undefined slope at point " + string$(.i)
                comment: "changing slope to 0 and F0 to mean of section."
                endPause: "Continue", 1
            endif
        endif

        # Remove surplus objects
        selectObject: .tmpF0Tbl
        Remove
    endfor

    # calculate intercepts of slopes
    .prevIdealTime = 0
    for .i to .numElbows - 2
        .idealT[.i] = (.intercept[.i + 1] - .intercept[.i])/(.slope[.i] - .slope[.i + 1])

        # error check: spurious ideal intercept points
        if .idealT[.i] < .prevIdealTime
            comment$ += " Error at TP " + string$(.i) +
                ... " (" + fixed$(.idealT[.i], 3) + ")"
            if userInput
                beginPause: "ERROR"
                comment: "The idealised contour will contain an error."
                comment: "Problem with "
                    ... + .sound$ + " at tone point point " + string$(.i)
                endPause: "Check manually", 1
            endif
        endif
        .prevIdealTime = .idealT[.i]
        .idealF0[.i] = .slope[.i] * .idealT[.i] + .intercept[.i]
    endfor

    # populate table of ideal targets
    .table = Create Table with column names: "IdealTargets", 0, "Time F0 Text"
    .points = 0
    for .i to .numElbows - 2
        # use elbow time and fo if slope intercept is undefined
        if .idealT[.i] = undefined
            .idealT[.i] = .elbow[.i + 1]
            selectObject: .pitchObj
            .idealF0[.i] = Get value at time: .idealT[.i],
                ... "semitones re 100 Hz", "Linear"
        endif
        selectObject: .table
        .points += 1
        Append row
        Set numeric value: .points, "Time", .idealT[.i]
        Set numeric value: .points, "F0", .idealF0[.i]
        Set string value: .points, "Text", .text$[.i]
    endfor
    # add boundaries
    for .i to 2
        .points += 1
        Append row
        Set numeric value: .points, "Time", .boundaryTime[.i]
        Set numeric value: .points, "F0", .boundaryF0[.i]
    endfor
    Sort rows: "Time"
    Formula: "F0", "100*2^(self/12)"

    for .i to .points
        Set string value: .i, "Text", .text$[.i]
    endfor

    ### Use dynamic smoothing to simulate physiological constraints
    # calculate dynamic smoothing parameters and populate F0 table
    @physioConstraints: .table, .pitchTable, .timeStep
    .allF0Contours = physioConstraints.f0TableNew
    selectObject: .allF0Contours
    Rename: "allF0Contours"
    Set column label (label): "intertiaSmoothing", "Smoothing"
    Formula: "Smoothing", "(1 + floor(.smoothCoarse * self))*2+1"
    Formula: "Smoothing", "if self = undefined then self = 1 else self endif"
    Append column: "IdealF0"
    # create contour of ideal curve (i.e., linear curve with no constraints)
    for .i to .points - 1
        selectObject: .table
        .curT = Get value: .i, "Time"
        .nextT = Get value: .i + 1, "Time"
        selectObject: .allF0Contours
        Formula: "IdealF0", "if self[""Time""] >=.curT and self[""Time""] <= .nextT "
            ... + "then .slope[.i] * self[""Time""] + .intercept[.i]"
            ... + "else self endif"
    endfor
    # create dynamically smoothed contour
    @dynamic_mpa: .allF0Contours, "Smoothing","IdealF0", "SmoothedIdealF0"
    # do fine grained smoothing to remove artefacts from dynamic smoothing
    @calc_mpa: .smoothFine, .allF0Contours, "SmoothedIdealF0", "TempF0"
    selectObject: .allF0Contours
    Remove column: "Smoothing"
    Remove column: "SmoothedIdealF0"
    Set column label (label): "TempF0", "SmoothedIdealF0"

    ### resynthise
    selectObject: .sound
    .sound$ = selected$ ("Sound")
    .timeS = Get start time
    .timeE = Get end time
    selectObject: .sound
    noprogress To Manipulation: 0.01, .minF0, .maxF0
    .manip = selected()
    # create pitch tier
    noprogress Extract pitch tier
    .pitchTier =  selected()
    Remove points between: .timeS, .timeE
    # add smoothed ideal contour to pitch tier
    selectObject: .allF0Contours
    .numRows = Get number of rows
    for .i to .numRows
        selectObject: .allF0Contours
        .curT = Get value: .i, "Time"
        .curF0 = Get value: .i, "SmoothedIdealF0"
        selectObject: .pitchTier
        if .curF0 != undefined
            Add point: .curT, 100 * 2^(.curF0/12)
        endif
    endfor
    # upate manipulation
    selectObject: .pitchTier
    plusObject: .manip
    Replace pitch tier
    selectObject: .pitchTier
    plusObject: .pitchObj
    .pitch = To Pitch
    # create resynthesis
    selectObject: .manip
    .wav = Get resynthesis (overlap-add)
    .new_name$ = resynthesis_prefix$ + .sound$
    Rename: .new_name$

    #remove remaining objects
    selectObject: .pitchTier
    plusObject: .pitchTable
    plusObject: .minMaxK
    Remove
endproc
