procedure analyseRhythmTier(.textgrid, .tier_num)
    # Return a table of rhythmic tier data.
        # Returns a table with one row for anacrusis (even if anacrusis is
        # absent) and one row per foot.
        #
        # Input variables:
        #     - .textgrid   = object number of target TextGrid
        #     - .tier_num   = number of rhythmic tier.
        #
        # Output:
        #    - An output table with the following columns:
        #           foot         = foot number, where 0 = anacrusis
        #           foot_start_t = start time of foot (and stressed syllable)
        #           stress_end_t = end time of stressed syllable
        #           foot_end_t   = end time of foot
        #    - analyseRhythmTier.possPhonoEvents = maximum possible number of
        #                                          tonal event in IP.
        #
        # NB: 1. foot_start_t for foot 0 (row 1) is also the IP start time.
        #     2. foot_end_t in row N is the end time of the IP.
        #     3. The script does not adjust start times to zero!
        #
        # Antoin Eoin Rodgers
        # rodgeran@tcd.ie
        # Phonetics and speech Laboratory, Trinity College Dublin

    selectObject: .textgrid
    .name$ = selected$("TextGrid")
    .num_tiers = Get number of tiers
    .valid = 1

    # Convert Rhythmic tier to table.
    .temp_grid = Extract one tier: .tier_num
    .num_points = Get number of points: 1
    .temp_table = Down to Table: "no", .tier_num, "no", "no"
    Rename: .name$
    removeObject: .temp_grid

    # Analyse each character of rhythmic tier text into separate rows.
    @tableText2Char: .temp_table, "text", "<>%"
    # Validate rythmic tier.
    .num_rows = Get number of rows
    .valid = .valid * ((.num_rows / 2) == round(.num_rows / 2))
    # Check for '%' at start and end of sequence.
    .is_percent_1$ = Get value: 1, "text"
    .is_percent_2$ = Get value: .num_rows, "text"
    .valid = .valid * (.is_percent_1$ == "%" and .is_percent_1$ == "%")
    # Check for paired '<>'.
    .i = 1
    while (.valid and .i <= .num_rows - 2)
        .i += 1
        .is_open_angle$ = Get value: .i, "text"
        .i += 1
        .is_close_angle$ = Get value: .i, "text"
        .valid = .valid * (.is_open_angle$ == "<" and .is_close_angle$ == ">")
    endwhile
    .possPhonoEvents = (.num_rows / 2 + 1) * .valid

    # Create and population valid rhythm table.
    .rhythm_table = Create Table with column names: .name$ + "_rhythm", 0,
    ... { "foot", "foot_start_t", "stress_end_t", "foot_end_t" }
    if .valid
        .cur_foot = 0
        .rhythm_char = 1
        .num_chars = .num_rows

        # add potential anacrusis.
        selectObject: .temp_table
        .foot_start_t = Get value: 1, "tmin"
        .foot_end_t = Get value: 2, "tmin"
        .stress_end_t = .foot_start_t

        selectObject: .rhythm_table
        Append row
        Set numeric value: .cur_foot + 1, "foot", .cur_foot
        Set numeric value: .cur_foot + 1, "foot_start_t", .foot_start_t
        Set numeric value: .cur_foot + 1, "stress_end_t", .stress_end_t
        Set numeric value: .cur_foot + 1, "foot_end_t", .foot_end_t
        .cur_foot += 1

        # Add foot and stress.
        while (.rhythm_char < (.num_chars - 1))

            selectObject: .temp_table
            .rhythm_char += 1
            .stress_t_start = Get value: .rhythm_char, "tmin"
            .foot_start_t = .stress_t_start
            .rhythm_char += 1
            .stress_end_t = Get value: .rhythm_char, "tmin"
            .foot_end_t = Get value: .rhythm_char + 1, "tmin"

            selectObject: .rhythm_table
            Append row
            Set numeric value: .cur_foot + 1, "foot", .cur_foot
            Set numeric value: .cur_foot + 1, "foot_start_t", .foot_start_t
            Set numeric value: .cur_foot + 1, "stress_end_t", .stress_end_t
            Set numeric value: .cur_foot + 1, "foot_end_t", .foot_end_t
            .cur_foot += 1


        endwhile
        removeObject: .temp_table
        selectObject: .rhythm_table
    endif
endproc
