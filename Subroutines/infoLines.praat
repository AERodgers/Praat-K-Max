# MAX-K SUBROUTINE: INFO WINDOW TEXT
# ==================================
# Written for Praat 6.0.40

# script by Antoin Eoin Rodgers
# rodgeran@tcd.ie
# Phonetics and speech Laboratory, Trinity College Dublin

procedure infoLines
    writeInfoLine: "MAX-Κ, v.1.0.0",
    ... newline$, "==============",
    ... newline$, "by Antoin Eoin Rodgers (rodgeran@tcd.ie)",
    ... newline$, "   Phonetics and Speech Laboratory, Trinity College, Dublin."
if not batch_process_directory
    appendInfoLine:
    ... newline$,
    ... newline$, "SOUND AND TEXTGRID WINDOW",
    ... newline$, " - Displays only textgrid tiers relevant to analysis, along with any",
    ... newline$, "   others specified in the master menu.",
    ... newline$, " - Annotate salient points of maximum curvature the tonal tier.",
    ... newline$, "   NOTE: blank annotations in the tonal tier will be deleted.",
    ... newline$,
    ... newline$, "UI MENU",
    ... newline$, "   NB: YOU MUST CLICK ""PROCESS"" TO SAVE AND REVIEW CHANGES",
    ... newline$, " - Smoothing parameters can be changed on the fly .",
    ... newline$, " - Use ""Smooth"" recalculates max-K and ""Fix Pitch"" ",
    ... "edit the contour.",
    ... newline$, " - Use ""Next"" to move to the next contour or ""<"" to go back one.",
    ... newline$, " - Change the value in ""Next object"" to jump to a different object.",
    ... newline$, " - Click ""Exit"" to exit the script cleanly.",
    ... newline$, " - Current number object and total number are shown in the title bar.",
    ... newline$,
    ... newline$, "FIX PITCH",
    ... newline$, " - Annotate F0 stretches to be deleted due to gross segmental effects ",
    ... newline$, " - in the fist window (then click ""continue"").",
    ... newline$, " - Correct any other erros (e.g. pitch halving an or doubling) in the",
    ... newline$, "   second window (manipulation object).",
    ... newline$, " - Function is called automatically if no pitch object found.",
    ... newline$,
    ... newline$, "   NB: BE VERY JUDICIOUS WHEN USING THE FIX PITCH FUNCTION!",
    ... newline$
endif
    appendInfo: newline$, newline$, "Started at:  ",  mid$(date$(), 12, 8)
    if batch_process_directory
        appendInfo: " ...this may take a while..."
    endif
endproc
