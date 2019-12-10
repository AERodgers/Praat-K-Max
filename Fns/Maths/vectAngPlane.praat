## STH MATHS FUNCTIONS
# ====================
# Written for Praat 6.0.40

# script by Antoin Eoin Rodgers
# rodgeran@tcd.ie
# Phonetics and speech Laboratory, Trinity College Dublin

procedure vectAngPlane: .xy##
    .numCoords = numberOfRows(.xy##)
    if .numCoords = 3
        .a# = {.xy##[1, 1] - .xy##[2, 1], .xy##[1, 2] - .xy##[2, 2]}
        .b# = {.xy##[3, 1] - .xy##[2, 1], .xy##[3, 2] - .xy##[2, 2]}
    elsif .numCoords = 2
        .a# = {.xy##[1, 1], .xy##[1, 2]}
        .b# = {.xy##[2, 1], .xy##[2, 2]}
    else
        exitScript: "Your input vector to @vectAngPlane has ", .numCoords,
            ... " pairs(s) of co-ordinates. It must only contain two or three."
    endif
    .c# = .a# + .b#
    .convex = .c#[2] < 0
    .concave = .c#[2] > 0
    .cos = (.a#[1]*.b#[1]+.a#[2]*.b#[2])/((sum(.a#^2))^0.5*(sum(.b#^2))^0.5)
    .rad = arccos(.cos)
    .k = (pi - (.rad)) / pi
endproc
