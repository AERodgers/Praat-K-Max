# K-MAX
# =====
# Version 0.1.2
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
    word Pitch_prefix PF_
    word Resynthesis_prefix RS_
    comment Tier names
    word Reference_tier syllable
    word Tonal_tier tones
    sentence Other_tiers_to_show phono rhythm
    comment Pitch Processing Parameters
    natural Minimum_F0 50
    natural Maximum_F0 300
    natural Praat_smooothing_bandwidth 10
    boolean Call_detailed_pitch_parameter_menu 0
    comment Post-idealisation smoothing parameters
    natural Physiological_constraints 1
    boolean Batch_process_directory 0
endform

# CALL SUBROUTINES
@versionCheck
if call_detailed_pitch_parameter_menu
    @toPitchVars
endif
@infoLines
@setUpDirsAndFiles
@getSoundGridInfo
@errorBeep
@setVars
@saveMenuVars
@main
@saveReportAndTidy

# INCLUDE SUBROUTINES AND FUNCTION LIBRARIES

# Subroutines take no arguments, written specifically for this set of scripts
include Subroutines/toPitchVars.proc
include Subroutines/infoLines.proc
include Subroutines/setUpDirsAndFiles.proc
include Subroutines/errorBeep.proc
include Subroutines/setVars.proc
include Subroutines/saveMenuVars.proc
include Subroutines/main.proc

include Subroutines/mainUIBatch.proc
include Subroutines/mainUI.proc
include Subroutines/getSoundGridInfo.proc
include Subroutines/drawStuffForEditing.proc
include Subroutines/createLegendTable.proc
include Subroutines/saveAndRemoveFiles.proc
include Subroutines/saveReportAndTidy.proc

# Functions take arguments and can largely be used in other scripts
#     (17/12/19 - I will add better annotations to functions later to make
#     them easier to incorporate into other scripts easier - AER)

include Functions/ContourProcessing.praat
include Functions/Graphical.praat
include Functions/Maths.praat
include Functions/Management.praat
