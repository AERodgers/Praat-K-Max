# K-MAX
# =====
# Version 0.2.0
#
# A set of scripts for analysing and resynthesising pitch contours
# using estimated points of maximum curvature in the contour. These are calcul-
# ated from the second time derivative of F0.
#
# Written for Praat 6.0.40

# script by Antoin Eoin Rodgers
# rodgeran@tcd.ie
# Phonetics and speech Laboratory, Trinity College Dublin
# October 10 - December 18, 2019

# SEE "Instruction_Guide.txt" for details on how to use the script

# INPUT FORM
form K-MAX: Master UI Menu
    comment Directory and file Information
    sentence Directory Example
    sentence Pitch_directory pitch
    sentence Output_directory output
    sentence Image_directory image
    sentence Resynth_directory resynth
    sentence Backup_directory backup
    sentence Manipulation_directory manipulation
    word Pitch_suffix _PF
    word Resynthesis_suffix _RS
    comment Tier names
    word Reference_tier syllable
    word Tonal_tier tones
    sentence Other_tiers_to_show phono rhythm
    comment Pitch Processing Parameters
    natural Minimum_F0 100
    natural Maximum_F0 350
    natural Praat_smooothing_bandwidth 10
    boolean Call_detailed_pitch_parameter_menu 0
    comment Post-idealisation smoothing parameters
    natural Physiological_constraints 10
    boolean Batch_process_directory 1
    boolean Post_instructions_in_Info_window 0
endform

@versionCheck
@updateFormLiterals("main_K-Max.praat")

if call_detailed_pitch_parameter_menu
    @toPitchVars
endif

nl$ = "newline$"
    writeInfoLine: "K-MAX, v.0.2.0",
    ... 'nl$', "==============",
    ... 'nl$', "by Antoin Eoin Rodgers (rodgeran@tcd.ie)",
    ... 'nl$', "   Phonetics and Speech Laboratory, Trinity College, Dublin."

if post_instructions_in_Info_window
    @infoLines
endif

# Set up and define variables.
@setUpDirsAndFiles
@getSoundGridInfo
@errorBeep
@setVars
@saveMenuVars

# Run main script.
@mainKMaxLoop

# Tidy up and exit
@saveReportAndTidy

# INCLUDE subroutines AND FUNCTION LIBRARIES

# subroutines take no arguments, written specifically for this set of scripts
include subroutines/toPitchVars.proc
include subroutines/infoLines.proc
include subroutines/setUpDirsAndFiles.proc
include subroutines/errorBeep.proc
include subroutines/setVars.proc
include subroutines/saveMenuVars.proc
include subroutines/mainKMaxLoop.proc

include subroutines/mainKMaxBatchUI.proc
include subroutines/mainKMaxUI.proc
include subroutines/getSoundGridInfo.proc
include subroutines/drawStuffForEditing.proc
include subroutines/createLegendTable.proc
include subroutines/saveAndRemoveFiles.proc
include subroutines/saveReportAndTidy.proc

# functions Libraries
# These procedures take arguments and can largely be used in other scripts

include functions/contourProcessing.praat
include functions/graphical.praat
include functions/maths.praat
include functions/management.praat
