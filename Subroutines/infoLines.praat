# Infolines for K-max
# ===================
# Written for Praat 6.0.40

# script by Antoin Eoin Rodgers
# rodgeran@tcd.ie
# Phonetics and speech Laboratory, Trinity College Dublin

procedure infoLines
    writeInfoLine: "MAX-Κ, v.1.0.0",
    ... newline$,  "==============",
    ... newline$, "A script for analysing and resynthesising pitch contours using",
    ... newline$, "estimated points of maximum curvature in the contour.",
    ... newline$,
    ... newline$, "Written for Praat 6.0.40",
    ... newline$,
    ... newline$, "by Antoin Eoin Rodgers",
    ... newline$, "   Phonetics and Speech Laboratory,",
    ... newline$, "   Trinity College Dublin",
    ... newline$, "   rodgeran@tcd.ie",
    ... newline$,
    ... newline$, "Started at:  ",  mid$(date$(), 12, 8)
    if batch_process_directory
        appendInfoLine: "... Be patient. This may take a while..."
    endif
endproc
