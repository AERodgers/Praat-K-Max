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
    r_tier$ = reference_tier$
    keepTiers$ = other_tiers_to_show$
    maxF0 = maximum_F0
    minF0 = minimum_F0

    maxlen = length(string$(numSounds))

    edit_choice = 0
    show_RS = 0

    userInput = not batch_process_directory
	pre_smoothing = initial_praat_smooothing_bandwidth
	coarse_smoothing = physiological_constraints_smoothing_parameter
	fine_smoothing = fine_grained_smoothing


    if elbow_estimation = 1
        elbowEst$ = "k"
    else
        elbowEst$ ="j"
    endif

    if physiological_smoothing = 1
        physSmooth$ = "k"
    else
        physSmooth$ ="j"
    endif
    #set physiological smoothing method (J = 2nd derivative, K = angle of vector on a
    # normalized XY plane)

endproc
