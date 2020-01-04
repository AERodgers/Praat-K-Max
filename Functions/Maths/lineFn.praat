# LINE FUNCTION
# =============
# Written for Praat 6.0.40

# script by Antoin Eoin Rodgers
# rodgeran@tcd.ie
# Phonetics and speech Laboratory, Trinity College Dublin
# November 11, 2019
#
# input arguments: @lineFn: "myVariable", x1, y1, x2, y2, .rounding
# outputs: slope     = myVariable.a
#          intercept = myVariable.b
#          equation  = myVariable.text$
#
#
#      y2 - y1
#  a = -------- ,    b = y1  - a * x1
#      x2 - x1

procedure lineFn: .ans$, .x1, .y1, .x2, .y2, .rounding
    '.ans$'.a = (.y2 - .y1) / (.x2 - .x1)
    '.ans$'.b = .y1 - '.ans$'.a * .x1

    if '.ans$'.a = 0
        .slope$ = ""
    else
        .slope$ = string$(round('.ans$'.a*10^.rounding)/10^.rounding) + "x"
    endif

    if '.ans$'.b = 0 or ('.ans$'.a = 0 and '.ans$'.b > 0)
        .sign$ = ""
    elsif '.ans$'.b > 0
         .sign$ = "+"
    else
         .sign$ = "-"
    endif

    if '.ans$'.b = 0
        .absIntercept$ = ""
    else
        .absIntercept$ = string$(round(abs('.ans$'.b)*10^.rounding)/10^.rounding)
    endif

    '.ans$'.text$ = "f(x) = "

    if '.ans$'.a * '.ans$'.b = undefined
        '.ans$'.text$ += "undefined"
    else
        '.ans$'.text$ += .slope$ + " " + .sign$ + " " + .absIntercept$
    endif
endproc
