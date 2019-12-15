# MERGE TEMPORARY TEXTGRID WITH ORIGINAL
# ======================================
# Written for Praat 6.0.40

# script by Antoin Eoin Rodgers
# rodgeran@tcd.ie
# Phonetics and speech Laboratory, Trinity College Dublin
#
# works in conjunction with @temp_textgrid

### STH OBJECT AND VARIABLE MANAGEMENT FUNCTIONS
# ==============================================
# Written for Praat 6.0.40

# script by Antoin Eoin Rodgers
# rodgeran@tcd.ie
# Phonetics and speech Laboratory, Trinity College Dublin

# dependency: temp_textgrid.object

procedure merge_textgrids
    # get number of and list of original and temporary tiers
    selectObject: temp_textgrid.object
    .temp_n_tiers = Get number of tiers
    for .i to .temp_n_tiers
        .temp_tier$[.i] = Get tier name: .i
    endfor
    selectObject: 'temp_textgrid.original$'
    .orig_n_tiers = Get number of tiers
    .name$ = selected$("TextGrid")
    for .i to .orig_n_tiers
        .orig_tier$[.i] = Get tier name: .i
    endfor

    # create 1st tier of merged tier
    selectObject: 'temp_textgrid.original$'
    Extract one tier: 1
    .new = selected()
    if .orig_tier$[1] = .temp_tier$[1]
        selectObject: temp_textgrid.object
        Extract one tier: 1
        .temp_single_tier = selected ()
        plusObject: .new
        Merge
        .newNew =selected()
        Remove tier: 1
        selectObject: .temp_single_tier
        plusObject: .new
        Remove
        .new = .newNew
    endif

    # merge tiers 2 to .orig_n_tiers
    for .i from 2 to .orig_n_tiers
        .useTemp = 0
        for .j to .temp_n_tiers
            if .orig_tier$[.i] =  .temp_tier$[.j]
                .useTemp = .j
            endif
        endfor
        if .useTemp
            selectObject: temp_textgrid.object
            Extract one tier: .useTemp
        else
            selectObject: 'temp_textgrid.original$'
            Extract one tier: .i
        endif
        .temp_single_tier = selected ()
        plusObject: .new
        Merge
        .newNew =selected()
        selectObject: .temp_single_tier
        plusObject: .new
        Remove
        .new = .newNew
    endfor
    selectObject: 'temp_textgrid.original$'
    plusObject: temp_textgrid.object
    Remove
    'temp_textgrid.original$' = .new
    selectObject: 'temp_textgrid.original$'
    Rename: .name$
endproc
