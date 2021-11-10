# K-MAX SUBROUTINE: INFO WINDOW TEXT
# ==================================
# Written for Praat 6.0.40

# script by Antoin Eoin Rodgers
# rodgeran@tcd.ie
# Phonetics and speech Laboratory, Trinity College Dublin

procedure infoLines
if not batch_process_directory
  appendInfoLine:
    ... 'nl$', "SOUND AND TEXTGRID WINDOW",
    ... 'nl$', " - Displays textgrid tiers relevant to analysis, along with",
    ... 'nl$', "   any others specified in the master menu.",
    ... 'nl$', " - Annotate salient points of maximum curvature in tonal tier.",
    ... 'nl$', "   NOTE: blank annotations in the tonal tier will be deleted.",
    ... 'nl$',
    ... 'nl$', "UI MENU",
    ... 'nl$', "   NB: YOU MUST CLICK ""PROCESS"" TO SAVE AND REVIEW CHANGES",
    ... 'nl$', " - Smoothing parameters can be changed on the fly .",
    ... 'nl$', " - Use ""Smooth"" recalculates max-K and ""Fix Pitch"" ",
    ... "to edit the contour.",
    ... 'nl$', " - Use "">"" to move to next contour or ""<"" to go back.",
    ... 'nl$', " - Change value in ""Next object"" to jump to another object.",
    ... 'nl$', " - Click ""Exit"" to exit the script cleanly.",
    ... 'nl$', " - Current object number and total are shown in the title bar.",
    ... 'nl$', " - A warning beep will signal any seious errors for correction",
    ... 'nl$',
    ... 'nl$', "FIX PITCH",
    ... 'nl$', " - Mark F0 regions to delete due to gross segmental effects.",
    ... 'nl$', " - in tier two of the fist window (then click ""continue"").",
    ... 'nl$', " - Correct any other errors (e.g. pitch halving or doubling)",
    ... 'nl$', "   in the second window (manipulation object).",
    ... 'nl$', " - Function is called automatically if no pitch object found.",
    ... 'nl$',
    ... 'nl$', "   NB: BE VERY JUDICIOUS WHEN USING THE FIX PITCH FUNCTION!",
    ... 'nl$'
endif
    appendInfo: 'nl$', "Started at:  ",  mid$(date$(), 12, 8)
    if batch_process_directory
        appendInfo: " ...this may take a while..."
    endif
endproc
