### STH OBJECT AND VARIABLE MANAGEMENT FUNCTIONS
# ==============================================
# Written for Praat 6.0.40

# script by Antoin Eoin Rodgers
# rodgeran@tcd.ie
# Phonetics and speech Laboratory, Trinity College Dublin

procedure temp_textgrid: .original$, .keep_list$
    # convert .keep_list$ to array of tiers to be kept
    # (.keep$[.n] with .n elements)
    .list_length = length(.keep_list$)
    .n = 1
    .prev_start = 1
    for .i to .list_length
        .char$ = mid$(.keep_list$, .i, 1)
        if .char$ = " "
            .keep$[.n] = mid$(.keep_list$, .prev_start, .i - .prev_start)
            .n += 1
            .prev_start = .i + 1
        endif

        if .n = 1
            .keep$[.n] = .keep_list$
        else
            .keep$[.n] = mid$
                ... (.keep_list$, .prev_start, .list_length - .prev_start + 1)
        endif
    endfor

    # create a copy of '.original$' and keep target tiers
    selectObject: '.original$'
    .num_tiers = Get number of tiers
    .name$ = selected$("TextGrid")
    .name$ += "_temp"
    .object = Copy: .name$
    for .i to .num_tiers
        .cur_tier = .num_tiers + 1 - .i
        .tiersInTemp = Get number of tiers
        .name_cur$ = Get tier name: .cur_tier
        .keepMe = 0
        for .j to .n
            if .keep$[.j] = .name_cur$
                .keepMe = 1
            endif
        endfor
        if not .keepMe
            Remove tier: .cur_tier
        endif
    endfor
endproc
