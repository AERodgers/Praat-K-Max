
procedure getMinPhonoString: .return_string$, .textgrid, .tier
    # Generates '.return_string$' containing the intonational phonology of
    # from a point tier named in .tier of .textgrid.
    selectObject: .textgrid
    .num_points = Get number of points: .tier
    '.return_string$' = ""
    for .i to .num_points
        .cur_phono$ = Get label of point: .tier, .i
        '.return_string$' += .cur_phono$
        if .i < .num_points
            '.return_string$' += tab$
        endif
    endfor
endproc
