# MAX-K SUBROUTINE: SET VARIABLES
# ===============================
# Written for Praat 6.0.40

# script by Antoin Eoin Rodgers
# rodgeran@tcd.ie
# Phonetics and speech Laboratory, Trinity College Dublin
# October 10 -  December 8,  2019

procedure setVars

    # shorten UI input variables
    rsPrefix$ = resynthesis_prefix$
    t_tier$ = tonal_tier$
    r_tier$ = reference_tier$
    keepTiers$ = other_tiers_to_show$
    maxF0 = maximum_F0
    minF0 = minimum_F0
    userInput = not batch_process_directory
    pre_smoothing = praat_smooothing_bandwidth
    coarse_smoothing = physiological_constraints
    fine_smoothing = fine_grained_smoothing

    # shorten beep variable
    errorBeep = errorBeep.sound
    # set flags and counters
    feedback = 0
    warning = 0
    edit_choice = 0
    show_RS = 0
    alreadyOpened# = zero# (numSounds)
    pitchSaved# = zero# (numSounds)
    draw_f0_corrected = 1
    draw_K = 1
    draw_resynth = 1
    draw_tonal = 1

    # set j variables
    fixPitch.candidates = 15
    fixPitch.s_threshold = 0.03
    fixPitch.v_threshold = 0.45
    fixPitch.oct_cost = 0.01
    fixPitch.oct_j_cost = 0.35
    fixPitch.vuv_cost = 0.14

    #colour variables
    # cyan = "{0.2, 1, 1}"
    #orange = "{1,0.5,0}"
    fixedF0Col$ = "Black"
    idealCol$ = "Lime"
    tonalCol$ = "Navy"
    kCol$ = "Red"

    # flag to add tiers for script author only [NOT FOR PUBLIC VERSION]
    justForAER = 1

endproc
