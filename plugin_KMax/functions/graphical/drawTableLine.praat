# DRAW TABLE LINE
# ===============
# Written for Praat 6.0.40

# script by Antoin Eoin Rodgers
# rodgeran@tcd.ie
# Phonetics and speech Laboratory, Trinity College Dublin

# other graphical functions
procedure drawTableLine: .tableObj, .xCol$, .yCol$,
        ... .x_axis_min, .x_axis_max, .ignore_zeros
    selectObject: .tableObj
    .rows_tot = Get number of rows
    for .i to .rows_tot - 1
        .x  = Get value: .i, .xCol$
        .y = Get value: .i, .yCol$
        .x_next  = Get value: .i+1, .xCol$
        .y_next = Get value: .i+1, .yCol$
        allDefined = .x != undefined and .x_next != undefined
             ... and .y != undefined and .y_next != undefined
        if not .ignore_zeros or (.y != 0 and .y_next != 0)
            if .x >= .x_axis_min and .x_next <= .x_axis_max
                    ... and allDefined
                 Draw line: .x, .y, .x_next, .y_next
            endif
        endif
    endfor
endproc
