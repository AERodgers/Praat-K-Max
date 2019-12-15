# MAX-K SUBROUTINE: SAVE MAX-K MASTER UI MENU PARAMETERS
# ======================================================
# Written for Praat 6.0.40

# script by Antoin Eoin Rodgers
# rodgeran@tcd.ie
# Phonetics and speech Laboratory, Trinity College Dublin
procedure saveMenuVars
    if curvature_estimation = 1
        est$ = "Second derivative"
    else
        est$ ="Angle of curve on a normalised XY plane"
    endif
    writeFile: outputPath$ + "MAX-K_form_parameters.txt", "Parameter" + tab$ + "Value"
    ... + newline$ + "Minimum_F0" + tab$ + string$(minimum_F0)
    ... + newline$ + "Maximum_F0" + tab$ + string$(maximum_F0)
    ... + newline$ + "Pre_smoothing" + tab$ + string$(pre_smoothing)
    ... + newline$ + "Coarse_smoothing" + tab$ + string$(coarse_smoothing)
    ... + newline$ + "Fine_smoothing" + tab$ + string$(fine_smoothing)
    ... + newline$ + "Maximum_K_method" + tab$ + est$
endproc
