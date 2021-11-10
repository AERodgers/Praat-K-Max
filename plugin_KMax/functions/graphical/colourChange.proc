procedure colourChange: .curCol$, .newCol$, .change$
    .newCol# = '.curCol$' '.change$'
    for .i to 3
        if .newCol#[.i] > 1
            .newCol#[.i] = 1
        elsif .newCol#[.i] < 0
            .newCol#[.i] = 0
        endif
    endfor
    '.newCol$' = "{" + string$(.newCol#[1])
        ... + ", " + string$(.newCol#[2])
        ... + ", " + string$(.newCol#[3]) + "}"
endproc
