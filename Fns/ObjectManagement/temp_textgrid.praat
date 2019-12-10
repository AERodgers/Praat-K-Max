### STH OBJECT AND VARIABLE MANAGEMENT FUNCTIONS
# ==============================================
# Written for Praat 6.0.40

# script by Antoin Eoin Rodgers
# rodgeran@tcd.ie
# Phonetics and speech Laboratory, Trinity College Dublin

procedure temp_textgrid: .original$, .delete_list$
    # convert .delete_list$ to array of tiers to be deleted
    # (.delete$[.n] with .n elements)
    .list_length = length(.delete_list$)
    .n = 1
    .prev_start = 1
    for .i to .list_length
        .char$ = mid$(.delete_list$, .i, 1)
        if .char$ = " "
            .delete$[.n] = mid$(.delete_list$, .prev_start, .i - .prev_start)
            .n += 1
            .prev_start = .i + 1
        endif

        if .n = 1
            .delete$[.n] = .delete_list$
        else
            .delete$[.n] = mid$
                ... (.delete_list$, .prev_start, .list_length - .prev_start + 1)
        endif
    endfor

    # create a copy of '.original$' and delete target tiers
    selectObject: '.original$'
    .num_tiers = Get number of tiers
    .name$ = selected$("TextGrid")
    .name$ += "_temp"
    .object = Copy: .name$

    for .i to .num_tiers
        .cur_tier = .num_tiers + 1 - .i
        .name_cur$ = Get tier name: .cur_tier
        for .j to .n
            if .delete$[.j] = .name_cur$
                Remove tier: .cur_tier
            endif
        endfor
    endfor
endproc
