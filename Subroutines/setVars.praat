# Set variables for K-max
# =======================
# Written for Praat 6.0.40

# script by Antoin Eoin Rodgers
# rodgeran@tcd.ie
# Phonetics and speech Laboratory, Trinity College Dublin
# October 10 -  December 8,  2019

procedure setVars

    # shorten UI input variables
    t_tier$ = tonal_tier$
    r_tier$ = reference_tier$
    keepTiers$ = other_tiers_to_show$
    maxF0 = maximum_F0
    minF0 = minimum_F0
        userInput = not batch_process_directory
    pre_smoothing = initial_praat_smooothing_bandwidth
    coarse_smoothing = physiological_constraints
    fine_smoothing = fine_grained_smoothing

    # set physiological smoothing method
    if curvature_estimation = 1
        curveEst$ = "j"
    else
        curveEst$ ="k"
    endif

    # set flags
    edit_choice = 0
    show_RS = 0
    alreadyOpened# = zero# (numSounds)
    pitchSaved# = zero# (numSounds)
    draw_f0_corrected = 1
    draw_K = 1
    draw_resynth = 1
    draw_phono = 1

    #colour variables
    idealCol$ = "{0.2, 1, 1}"
    fixedF0Col$ = "{1,0.5,0}"
    phonoCol$ = "Navy"
    kCol$ = "Red"

endproc
