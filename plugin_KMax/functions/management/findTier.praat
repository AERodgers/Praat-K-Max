# TIER MANAGEMENT
procedure findTier: .outputVar$, .textgrid, .tier$, .type
    # Outputs the tier number of '.tier$' in '.textgrid' or returns 0.
        # .outputVar$ = string containing the name of the output variable.
        # .textgrid   = object number of TextGrid to be checked.
        # .tier$      = name of the tier being sought.
        # .type       = type of tier (0 = point, 1 = interval)
        #
        # If a tier name of the appropriate type is not found, 0 is returned.
        #
        # Antoin Eoin Rodgers
        # rodgeran@tcd.ie
        # Phonetics and speech Laboratory, Trinity College Dublin

    # check global error handling flag
    if not (variableExists ("global_EXCEPTION_HANDLING"))
        global_EXCEPTION_HANDLING = 0
    endif

    '.outputVar$' = 0
    selectObject: .textgrid
    .numTiers = Get number of tiers
    .i = 0
    while .i < .numTiers and '.outputVar$' = 0
        .i += 1
        .curTier$ = Get tier name: .i
        '.outputVar$' = .i * (.curTier$ == .tier$)
    endwhile

    # Check target tier is correct tier type.
    if '.outputVar$'
        .is_interval = Is interval tier: '.outputVar$'
        if (.is_interval != .type)
            '.outputVar$' = 0
        endif
    endif

    # Handle tier name and type exceptions.
    if ('.outputVar$' == 0 and global_EXCEPTION_HANDLING)
        if .is_interval
            .type$ = "Interval"
        else
            .type$ = "Point"
        endif
        .grid_name$  = selected$("TextGrid")
        beginPause: "Error"
            comment: "Error in @findTier."
            comment: .type$ + " tier called '" + .tier_name$ + "' not found"
            comment: "in TextGrid " + .textgrid, ": '" + .grid_name$ + "'."
            .end_pause = endPause: "Continue", 1, 1
        .valid = 0
    endif
endproc
