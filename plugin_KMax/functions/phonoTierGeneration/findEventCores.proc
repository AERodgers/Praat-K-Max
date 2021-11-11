procedure findEventCores: .textgrid, .tone_tier
    # Returns an array of times of boundaries and starred tones.
        # input argments:
        #     .textgrid      = TextGrid ID
        #     .tone_tier     = number of tonal tier.
        #
        # output:
        #     findEventCores.t  = array of tonal event times.
        #     findEventCores.n = array size.
        #
        # This procedure assumes that pitch accents have a starred tone (*)
        # and that the first and last annotated points represent the boundaries.
        #
        # Antoin Eoin Rodgers
        # rodgeran@tcd.ie
        # Phonetics and speech Laboratory, Trinity College Dublin

    selectObject: .textgrid
    .num_points = Get number of points: .tone_tier

    # Get the first tone annotation in tone tier. Assume it is associated with
    # the left boundary.
    .num_events = 1
    .t[1] = Get time of point: .tone_tier, 1

    for .i from 2 to .num_points - 1
        .cur_label$ = Get label of point: .tone_tier, .i
        if index(.cur_label$, "*")
            .num_events += 1
            .t[.num_events] = Get time of point: .tone_tier, .i
        endif
    endfor

    # Get the last tone annotation in tone tier. Assume it is associated with
    # the right boundary.
    .num_events += 1
    .t[.num_events] = Get time of point: .tone_tier, .num_points
    .n = .num_events
endproc
