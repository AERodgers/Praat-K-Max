# MAX-Κ
# =====
# A set of scripts for analysing and resynthesising pitch contours
# using estimated points of maximum curvature in the contour.
#
# Written for Praat 6.0.40

# script by Antoin Eoin Rodgers
# rodgeran@tcd.ie
# Phonetics and speech Laboratory, Trinity College Dublin
# October 10 - December 16, 2019

# SEE "Instruction_Guide.txt" for details on how to use the script

# INPUT FORM
form MAX-K: Master UI Menu
    comment Directory Information
    sentence Directory
    sentence Pitch_directory pitch
    sentence Output_directory output
    sentence Image_directory image
    sentence Resynth_directory resynth
    sentence Backup_directory backup
    sentence Manipulation_directory manipulation

    comment Tier names
    word Reference_tier syllable
    word Tonal_tier STHtone
    sentence Other_tiers_to_show phono boundary comments

    comment File format
    word Pitch_prefix PF_
    word Resynthesis_prefix RS_
    word Sound_suffix .wav

    comment Pitch Processing Parameters
    natural Minimum_F0 55
    natural Maximum_F0 400
    natural Praat_smooothing_bandwidth 10

    comment Post idealisation smoothing parameters (moving point average)
    natural Physiological_constraints 1
    natural Fine_grained_smoothing 1
    comment
    boolean Batch_process_directory
endform

# CALL SUBROUTINES
@versionCheck
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
include Subroutines/errorBeep.praat
include Subroutines/infoLines.praat
include Subroutines/main.praat
include Subroutines/setUpDirsAndFiles.praat
include Subroutines/setVars.praat
include Subroutines/getSoundGridInfo.praat
include Subroutines/drawStuffForEditing.praat
include Subroutines/createLegendTable.praat
include Subroutines/saveMenuVars.praat
include Subroutines/saveAndRemoveFiles.praat
include Subroutines/saveReportAndTidy.praat

# Functions take arguments and are designed to be adaptable for other scripts
include Functions/ContourProcessing.praat
include Functions/Graphical.praat
include Functions/Idealisation.praat
include Functions/Maths.praat
include Functions/Management.praat
