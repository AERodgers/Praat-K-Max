# DYNAMIC TRIANGULAR M.P.A. USING WINDOW SIZE SPECFIED IN REFERENCE COLUMN
# ========================================================================
# Written for Praat 6.0.40

# script by Antoin Eoin Rodgers
# rodgeran@tcd.ie
# Phonetics and speech Laboratory, Trinity College Dublin

procedure dynamic_mpa: .table_object, .dynamic_col$,.input_col$, .output_col$
    selectObject: .table_object
    .total_points = Get number of rows

    .colExists = Get column index: .output_col$
    if not .colExists
        Append column: .output_col$
    endif

    for .current_point to .total_points
        .mpa_size = Get value: .current_point,  .dynamic_col$
        .mpa_lr = floor (.mpa_size/2)
        # ensure MPA window size does not exceed the number of frames
        if .current_point <= .mpa_lr
            .cur_mpa_lr = .current_point - 1
        elsif .total_points - .current_point < .mpa_lr
            .cur_mpa_lr = .total_points - .current_point
        else
            .cur_mpa_lr = .mpa_lr
        endif
        .total = 0
        .n = 0
        .cur_centre = Get value: .current_point, .input_col$
        for .add_these from (.current_point - .cur_mpa_lr)
            ... to (.current_point + .cur_mpa_lr)
            if .add_these >= 1 and .add_these <= .total_points
                .cur_fo = Get value: .add_these, .input_col$
                if .cur_fo  <> undefined
                    .total = .total + .cur_fo
                    .n = .n + 1
                endif
            endif
        endfor
        if .cur_centre <> undefined
            Set numeric value: .current_point, .output_col$, .total/.n
        endif
    endfor
endproc
