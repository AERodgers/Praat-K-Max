# MAX-K: GET IDEAL TONAL TARGETS
# ==============================
# Written for Praat 6.0.40

# script by Antoin Eoin Rodgers
# rodgeran@tcd.ie
# Phonetics and speech Laboratory, Trinity College Dublin

# Contour idealisation

# dependencies: @pitch2Table, @removeRowsWhereNum, @tableStats,
#               @physioConstraints[j/k], @dynamic_mpa, @calc_mpa

procedure idealise: .sound, .grid, .toneTier$, .pitchObj,
        ...  .minF0, .maxF0, .kMin, .smoothCoarse, .smoothFine

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
        if .curTier$ != .toneTier$
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
    .numMaxKpoints = Get number of rows
    for .i to .numMaxKpoints
        .maxKTime[.i] = Get value: .i, "Time"
        .maxKText$[.i] = Get value: .i, "text"
        if .i = 1
            .maxKText$[.i] = "%" + replace$(.maxKText$[.i], "0", "", 1)
        elsif .i = .numMaxKpoints
            .maxKText$[.i] = replace$(.maxKText$[.i], "0", "", 1) + "%"
        endif
    endfor
    # remove text column
    Remove column: "text"
    # remove temporary text grid
    selectObject: .tempGrid
    Remove

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
    Remove

    # prepare KMax Table for later
	selectObject: .tempKmax
	Set column label (label): "Time", "KTime"

    # Get start and end times for linear regression calculations
    # based on minK first after Max K(n) and last before MaxK(n+1)
    selectObject: .minMaxK
	.numSlopes = .numMaxKpoints - 1

    for .i to .numSlopes
        @find_nearest_table: .maxKTime[.i], .minMaxK, "Time"
        .firstKMinT = Get value: find_nearest_table.index + 1, "Time"
        .noKMins = Get value: find_nearest_table.index + 1, "MinMax"
        @find_nearest_table: .maxKTime[.i+1], .minMaxK, "Time"
        .lastKMinT = Get value: find_nearest_table.index - 1, "Time"

        #if no intervening MinK, use maxK time at linear regression start
		# and end points
        if .noKMins
            .firstKMinT = .maxKTime[.i]
            .lastKminT = .maxKTime[.i + 1]
        endif

        # if only one K min between Kmax points, treat it as inflexion point
        # and use nearest time points to kMin to calculate slope
        if .firstKMinT = .lastKMinT
            .firstKMinT -= .timeStep - 0.0001
            .lastKMinT += .timeStep + 0.0001
        endif

        # add first and last min K values to appropriate arrays
        .lineSt[.i] = .firstKMinT
        .lineNd[.i]  = .lastKMinT
    endfor

    # get slope and intercept of linear Fn between each lineStart and lineEnd
    for .i to .numSlopes
        selectObject: .pitchTable
        .tmpF0Tbl = Copy: "tmpF0Tbl"
        @removeRowsWhereNum: .tmpF0Tbl, "Time", "> idealise.lineNd[idealise.i]"
        @removeRowsWhereNum: .tmpF0Tbl, "Time", "< idealise.lineSt[idealise.i]"
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

    # calculate T and F0 intercepts of slopes
    .prevIdealTime = 0
	.idealT[1] = .maxKTime[1]
	.idealF0[1] = 0
    for .i to .numSlopes -1
        .idealT[.i + 1] = (.intercept[.i + 1] - .intercept[.i])/(.slope[.i]
		    ... - .slope[.i + 1])
        # error check: spurious ideal intercept points
        if .idealT[.i + 1] < .idealT[.i]
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
        .idealF0[.i + 1] = .slope[.i] * .idealT[.i + 1] + .intercept[.i]
    endfor

    # calculate ideal F0 of initial boundary (NB risky use of .i!)
    .idealF0[1] = .slope[1] * .idealT[1] + .intercept[1]
	.lastPt = .numMaxKpoints
	.idealT[.lastPt] = .maxKTime[.lastPt]
    .idealF0[.lastPt] = .slope[.numSlopes] * .idealT[.lastPt] +
	    ... .intercept[.numSlopes]
    # populate table of ideal targets
	selectObject: .tempKmax
	Append column: "Time"
	Append column: "F0"
	Append column: "Text"
	Append column: "Slope"
	Append column: "Intercept"
	Rename: "Elbows and Ideals"
    .table = .tempKmax
	Remove column: "MinMax"

    for .i to .numMaxKpoints
        # use elbow time and fo if slope intercept is undefined
        if .idealT[.i] = undefined
            .idealT[.i] = .maxKTime[.i + 1]
            selectObject: .pitchObj
            .idealF0[.i] = Get value at time: .idealT[.i],
                ... "semitones re 100 Hz", "Linear"
        endif
        selectObject: .table
        Set numeric value: .i, "Time", .idealT[.i]
        Set numeric value: .i, "F0", .idealF0[.i]
        Set string value: .i, "Text", .maxKText$[.i]
    endfor

	# add slope and intercept values
	selectObject: .table
    for .i to .numSlopes
        Set numeric value: .i, "Slope", .slope[.i]
        Set numeric value: .i, "Intercept", .intercept[.i]
    endfor
	# assume no slope and intercept of F0 for final point
	Set numeric value: .numMaxKpoints, "Slope", 0
    Set numeric value: .numMaxKpoints, "Intercept", .idealF0[.numMaxKpoints]

    # convert ST re 100 to Hz
    Formula: "F0", "100*2^(self/12)"

    ### Use dynamic smoothing to simulate physiological constraints
    # calculate dynamic smoothing parameters and populate F0 table
    @physioConstraintsJ: .table, .pitchTable, .timeStep, .smoothCoarse
    selectObject: .pitchTable
    Rename: "pitchTable"
    Set column label (label): "PhysioSmoothing", "Smoothing"
    Append column: "IdealF0"
    # create contour of ideal curve (i.e., linear curve with no constraints)
    for .i to .numMaxKpoints - 1
        selectObject: .table
        .curT = Get value: .i, "Time"
        .nextT = Get value: .i + 1, "Time"
        selectObject: .pitchTable
        Formula: "IdealF0",
		    ... "if self[""Time""] >=.curT and self[""Time""] <= .nextT "
            ... + "then .slope[.i] * self[""Time""] + .intercept[.i]"
            ... + "else self endif"
    endfor
    # create dynamically smoothed contour
    @dynamic_mpa: .pitchTable, "Smoothing", "IdealF0", "SmoothedIdealF0"
    # grained smoothing to remove artefacts from dynamic smoothing
    @calc_mpa: (.smoothFine) * 2 + 1, .pitchTable, "SmoothedIdealF0", "TempF0"
    selectObject: .pitchTable
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
    selectObject: .pitchTable
    .numRows = Get number of rows
    for .i to .numRows
        selectObject: .pitchTable
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
    plusObject: .minMaxK
    Remove
endproc
