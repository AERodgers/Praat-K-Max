# MAX-K SUBROUTINE: SAVE MAX-K MASTER UI MENU PARAMETERS
# ======================================================
# Written for Praat 6.0.40

# script by Antoin Eoin Rodgers
# rodgeran@tcd.ie
# Phonetics and speech Laboratory, Trinity College Dublin
procedure saveMenuVars
    writeFile: outputPath$ + "MAX-K_form_parameters.txt",
		...  "Parameter" + tab$ + "Value"
		... + newline$ + "Minimum_F0" + tab$ + string$(minimum_F0)
		... + newline$ + "Maximum_F0" + tab$ + string$(maximum_F0)
		... + newline$ + "Pre_smoothing" + tab$ + string$(pre_smoothing)
		... + newline$ + "Coarse_smoothing" + tab$ + string$(coarse_smoothing)
		... + newline$ + "Fine_smoothing" + tab$ + string$(fine_smoothing)
endproc
