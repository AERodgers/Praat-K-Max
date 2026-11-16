procedure addPhonTiers: .textgrid, .rhy_tier, .sth_tier
    # generates an intermediate & minimal phonological point tier on a TextgGrid.
        #
        # Input arguments:
        #    .textGrid       = the numerical ID of the TextGrid object;
        #    .rhy_tier = the number of the rhythmic tier;
        #    .sth_tier = the number of the tonal tier.
        #
        # Antoin Eoin Rodgers
        # rodgeran@tcd.ie
        # Phonetics and speech Laboratory, Trinity College Dublin

    # get TextGrid info for later checks
    selectObject: .textgrid
    .sth_name$ = Get tier name: .sth_tier
    .rhy_name$ = Get tier name: .rhy_tier

    # Analyse structure of Rhythmic tier
    @analyseRhythmTier(.textgrid, .rhy_tier, 0)
    .rhythm_table = selected()
    .possPhonoEvents = analyseRhythmTier.possPhonoEvents

    # Create empty phonological tier
    @insertPhonoTier: .textgrid, .rhythm_table, "intPhono", .rhy_tier
    .i_phon_tier = insertPhonoTier.phonTier
    .potentialEventCores = insertPhonoTier.num_phon_markers

    # Check if .sth_tier or .rhy_tier has moved and correct number
    selectObject: .textgrid
    .name_check$ = Get tier name: .sth_tier
    if (.name_check$ != .sth_name$)
        @findTier:  "addPhonTiers.sth_tier", .textgrid, .sth_name$, 0
    endif
    .name_check$ = Get tier name: .rhy_tier
    if (.name_check$ != .rhy_name$)
        @findTier:  "addPhonTiers.rhy_tier", .textgrid, .rhy_name$, 0
    endif

    # Convert STH tone tier content to array of PA and boundary events.
    @getToneString: {.sth_tier}, .textgrid
    .tone_str$ = getToneString.text$

    selectObject: .textgrid

    @list2array: .tone_str$, "addPhonTiers.event_array$"

    # Find boundary and starred tones times in STH tone tier.
    @findEventCores: .textgrid, .sth_tier

    # Create array of .nearestPhonStar[i:findEventCores.n]
    for .i to findEventCores.n
        .nearestPhonStar[.i] = -1
    endfor

    # Bearing in mind that core event [1] and core event [n] are associated
    # with the boundaries, place the first and last events seperatell
    .nearestPhonStar[1] = 1
    Set point text: .i_phon_tier, .nearestPhonStar[1], .event_array$[1]

    # Match event cores with *s in intermediate Phonological tier.
    for .i from 2 to findEventCores.n - 1
        .nearestPhonStar[.i] = Get nearest index from time:
        ... .i_phon_tier, findEventCores.t[.i]
        # Ensure starred tones are not accidentally placed at boundaries.
        if .nearestPhonStar[.i] == 1 and index(.event_array$[.i], "*")
            .nearestPhonStar[.i] +=1
        elsif .nearestPhonStar[.i] == .possPhonoEvents
        ... and index(.event_array$[.i], "*")

            .nearestPhonStar[.i] -=1
        endif
    endfor

    # Check that two consecutive starred events have not been assigned the same
    # point index on the intermediate phonological tier.
    for .i from 2 to findEventCores.n - 2
        # Correct index error bases on whether the nearestPhonStar[i-1]
        # is at least two indices away. If that is th case, the value
        # nearestPhonStar[i] can be decremented. Otherswise, the value
        # of the next one should be incremented.
        if .nearestPhonStar[.i] = .nearestPhonStar[.i + 1]
            if .nearestPhonStar[.i - 1] == .nearestPhonStar[.i] - 2
                .nearestPhonStar[.i] -= 1
            elsif .nearestPhonStar[.i + 2] == .nearestPhonStar[.i] + 2
                .nearestPhonStar[.i + 1] += 1
            endif
        endif
    endfor

    # populate intermediate phonological tier
    for .i from 2 to findEventCores.n - 1
        Set point text: .i_phon_tier, .nearestPhonStar[.i], .event_array$[.i]
    endfor

    .nearestPhonStar[findEventCores.n] = .potentialEventCores
    Set point text: .i_phon_tier,
    ... .nearestPhonStar[findEventCores.n],
    ... .event_array$[findEventCores.n]

    .m_phon_tier = 1
    while .m_phon_tier
        @findTier: "addPhonTiers.m_phon_tier", .textgrid, "minPhono", 0
        if .m_phon_tier
            Remove tier: .m_phon_tier
        endif
    endwhile

    @findTier: "addPhonTiers.i_phon_tier", .textgrid, "intPhono", 0
    Duplicate tier: .i_phon_tier, .i_phon_tier, "minPhono"
    .m_phon_tier = .i_phon_tier
    .i_phon_tier += 1
    # Populate minimal phonological tier.
    .num_points = Get number of points: .m_phon_tier

    for .i to .num_points
        cur_i_phono$ = Get label of point: .m_phon_tier, .i
        @asIViEPhon: cur_i_phono$
        if .i = 1
            asIViEPhon.text$ = "%" + asIViEPhon.text$
        elsif .i = .num_points
            asIViEPhon.text$ += "%"
        endif
        Set point text: .m_phon_tier, .i, asIViEPhon.text$
    endfor

    removeObject: .rhythm_table
endproc
