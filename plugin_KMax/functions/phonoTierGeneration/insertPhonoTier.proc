procedure insertPhonoTier(.textgrid, .rhythm_table, .phon_tier_name$, .afterTier)
    # Insert a blank phonological tier using info from rhythmic tier.
        # .textgrid        = TextGrid ID
        # .rhythm_table    = ID of Rhythm Table
        # .phon_tier_name$ = name of new phonological tier
        # .after$          = name of tier after which new tier will appear.
        #
        # Antoin Eoin Rodgers
        # rodgeran@tcd.ie
        # Phonetics and speech Laboratory, Trinity College Dublin

    selectObject: .rhythm_table
    .rhy_table_rows = Get number of rows
    .phon_marker[1] = Get value: 1, "foot_start_t"
    # num_phon_markers = number of feet +  2 boundary markers
    .num_phon_markers = Get value: .rhy_table_rows, "foot"
    .num_phon_markers += 2
    .phon_marker[.num_phon_markers] = Get value: .rhy_table_rows, "foot_end_t"

    for .i from 2 to .rhy_table_rows
        .stress_start_t = Get value: .i, "foot_start_t"
        .stress_end_t = Get value: .i, "stress_end_t"
        .phon_marker[.i] = (.stress_start_t + .stress_end_t) / 2
    endfor

    # Find existing .phon_tier_name$ and remove it.
    @findTier: "insertPhonoTier.phonTier", .textgrid, .phon_tier_name$, 0
    if .phonTier
        Remove tier: .phonTier
    endif

    # Insert blank .phon_tier_name$ after rhytyhm tier.
    .phonTier = .afterTier + 1
    Insert point tier: .phonTier, .phon_tier_name$

    for .i to .num_phon_markers
        if (.i == 1 or .i == .num_phon_markers)
            .symbol$ = "%"
        else
            .symbol$ = "*"
        endif
        Insert point: .phonTier, .phon_marker[.i], .symbol$
    endfor
endproc
