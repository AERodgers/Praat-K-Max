# K-MAX SUBROUTINE: SAVE K-MAX MASTER UI MENU PARAMETERS
# ======================================================
# Written for Praat 6.0.40

# script by Antoin Eoin Rodgers
# rodgeran@tcd.ie
# Phonetics and speech Laboratory, Trinity College Dublin
procedure saveMenuVars
    writeFile: outputPath$ + "K-MAX_form_parameters.txt",
        ...  "Parameter" + tab$ + "Value"
        ... + newline$ + "Minimum_F0" + tab$ + string$(minimum_F0)
        ... + newline$ + "Maximum_F0" + tab$ + string$(maximum_F0)
        ... + newline$ + "Pre_smoothing" + tab$ + string$(pre_smoothing)
        ... + newline$ + "Coarse_smoothing" + tab$ + string$(coarse_smoothing)
endproc
