# EDIT/ANALYSE SOUNDS USING SECONDARY TONE HYPOTHESIS (STH)  V.0.2.2.0
# ====================================================================
# Written for Praat 6.0.40

# script by Antoin Eoin Rodgers
# rodgeran@tcd.ie
# Phonetics and speech Laboratory, Trinity College Dublin
# October 10 -  December 8,  2019

# Opens sound files and texgrid pairs in directory for editing and analyis in
# "STH" style. Only displays tiers relevant to tone marking.
    # REQUIREMENTS
    #   1. sound file (.wav)
    #   2. textgrid with at minimum an interval tier showing start and end of utterance.
    #   3. pitch object (.Pitch) [if does not exist @fixPitch will be called]
    #
    # RUNNING THE SCRIPT
    # When the script is run, enter the appropriate info in the UI form.
    #
    # When viewing the textgrid and sound files, the user can:
    #     1. Stop the script (praat exitScript).
    #     2. Resmooth the contour (using smoothing factor in the smoothing textbox)
    #     3. correct the pitch (run @FixPitch) to remove micro-perturbations and
    #        segmental effects.
    #     4. Process and save the sound using annotated tonal tiers.
    #        This also displays the resynthesised manipulation for auditory comparision.
    #     6. Go to the next object without saving ("next object" text box changes this).
    #     7. Go back without saving ("<").
    #     8. exit the script (clears all temporary objects and completes report)
    #     9. Change the smoothing parameters on the fly and add an additions comment.
    #        This is done using the input boxes above
    #
    # OUTPUT
    #     1. updated TextGrids (if saved)
    #     2. resynthesised sounds and associated manipulation objects
    #        (if resynth option selected)
    #     3. report showing smoothing parameters, phonological analysis, and comments
    #     3. Figure with spectrogram, and F0 contour with CPP indicated by magnitude and
    #        colour intensity of dots. By default also includes resynthesised contour,
    #        idealised tonal targets, and phonology.
    #        Can also display curvature contour and corrected pitch contour
    #        (This can be changed in the UI main routine menu for each sound.)
    #
    # FAILSAFES / ERROR HANDLING
    #     1. for manual editing, a backup directory is created which contains:
    #            - backup of each TextGrid as it was before script was run
    #            - a report listing all texgrids changed
    #     2. Resynth finds first defined F0 nearest to annotated tonal targets
    #        and adjusts textgrid accordingly. If no nearby defined F0 found,
    #        error warning displayed.
    #     3. Error windows when idealisation functions break down
    #        (shown in report during batch processing)

### INPUT FORM
form Text grid editor: Choose Directory
    sentence Directory
    comment Directory Information
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
    optionmenu Elbow_estimation 1
        option Angle on a normalised plane
        option Second derivative
    natural Minimum_F0 55
    natural Maximum_F0 400
    integer Initial_praat_smooothing_bandwidth 10

    comment Post-idealisation smoothing (moving point average)
    optionmenu Physiological_smoothing 1
        option Angle on a normalised plane
        option Second derivative
    integer physiological_constraints_smoothing_parameter 8
    integer Fine_grained_smoothing 1

    comment
    word phonology_colour Navy
    boolean Batch_process_directory
endform

### COMPATABILITY CHECK
version$ = praatVersion$
if number(left$(version$, 1)) < 6
    echo You are running Praat 'praatVersion$'.
    ... 'newline$'This script runs on Praat version 6.0.40 or later.
    ... 'newline$'To run this script, update to the latest
    ... version at praat.org
    exit
endif

writeInfoLine: "MAX-Κ"
appendInfoLine: "====="
appendInfoLine: newline$, "A script for analysing and resynthesising pitch contours using"
appendInfoLine: "estimated points of maximum curvature in the pitch contour."
appendInfoLine: ""
appendInfoLine: "All assoiated scripts published under GNU General Public License, V.3."
appendInfoLine: newline$, "by Antoin Eoin Rodgers"
appendInfoLine: "   Phonetics and speech Laboratory,"
appendInfoLine: "   Trinity College Dublin"
appendInfoLine: "   rodgeran@tcd.ie"

appendInfoLine: newline$, "Started:  ",  date$()
if batch_process_directory
    appendInfoLine: "Be patient. This may take a while..."
endif

### RUN MAIN ROUTINE
@main

### Task completion Info
appendInfoLine: "Finished: ", date$()

### INCLUDE SUBROUTINES AND FUNCTION LIBRARIES
### Subroutines take no arguments are written specifically for this set of scripts
include Subroutines/main.praat
include Subroutines/setUpDirsFiles.praat
include Subroutines/shortenVars.praat
include Subroutines/getSoundGridInfo.praat
include Subroutines/drawStuffForEditing.praat
include Subroutines/createLegendTable.praat
include Subroutines/updateReport.praat

### Fuctions arguments and are (generally) designed to be adaptable to any script
include Functions/ContourAnalysis.praat
include Functions/Graphical.praat
include Functions/FixPitch.praat
include Functions/Idealisation.praat
include Functions/Maths.praat
include Functions/ObjectManagement.praat
