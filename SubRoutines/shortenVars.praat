# STH Analysis sub-routine: shortenVars
# ====================================================================
# Written for Praat 6.0.40

# script by Antoin Eoin Rodgers
# rodgeran@tcd.ie
# Phonetics and speech Laboratory, Trinity College Dublin
# October 10 -  December 8,  2019

procedure shortenVars
    phonoCol$ = phonology_colour$
    t_tier$ = tonal_tier$
    b_tier$ = boundary_tier$
    r_tier$ = reference_tier$
    maxF0 = maximum_F0
    minF0 = minimum_F0
    maxlen = length(string$(numSounds))
    edit_choice = 0
    show_RS = 0
    userInput = not batch_process_directory
endproc
