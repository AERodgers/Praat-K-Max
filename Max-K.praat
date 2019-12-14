# MAX-Κ
# =====
# A script for analysing and resynthesising pitch contours
# using estimated points of maximum curvature in the contour.
#
# Written for Praat 6.0.40

# script by Antoin Eoin Rodgers
# rodgeran@tcd.ie
# Phonetics and speech Laboratory, Trinity College Dublin
# October 10 -  December 8,  2019

# Opens sound files and texgrid pairs in a specified directory for editing and analyis.
    #
    # A. REQUIREMENTS
    #    1. sound file (.wav)
    #    2. textgrid with at minimum an interval tier showing start and end of utterance.
    #    3. all textgrid files must share the same name as the associated sound file.
    #
    # B. OPTIONAL
    # 1. pitch object (.Pitch) [if does not exist @fixPitch will be called]
    #
    # C. MASTER UI MENU
    #    1. Directory: path to directory contain files to be analysed.
    #    2. Directory Information: names of sub-directories for loading and saving
    #           files. (Leave blank if all files to be stored in the main directory.)
    #    3. Tier names: Name of the reference (default "syllable") and tonal tiers.
    #           Other tiers to display can also be listed in "Other tiers to show".
    #    4. File format: prefixes (if any) for pitch and resynthesised sound files.
    #           suffix for sound file (default ".wav").
    #    5. Pitch processing parameters: choose curve estimation (Second derivative
    #           recommended); set minimum and maximum F0, and pitch smoothing parameter
    #           bandwidth for Praat Smooth function, which is performed on the pitch
    #           object before curvature estimation (10 default: higher = less smoothing)
    #    6. Post idealisation smoothing parameters (moving point average)
    #           a. Physiological constraints: (default: 8. lower = less smoothing)
    #                  Smoothes the "ideal curve" to simulate the effects of
    #                  physhiological constraints on pitch movement
    #           b. Fine-grained smoothing: (default: 1. higher = more smoothing)
    #                  runs an MPA smoothing function over the final contour to remove
    #                  any remaining artefacts.
    #    7. Batch process directory: runs through whole directory and processes all
    #           files automatically. This assumes the user has already run the process.
    #           Manually (LARGELY REDUNDANT IN RELEASE VERSION).
    #
    # D. RUNNING THE MAIN ANALYSIS PROCEDURE
    #    The following events occur for each textrid and sound file in the directory.
    #    1. The first time a textgrid is opened, it is backed up.
    #    2. If a pitch object is not found, @fixPitch will be called. This
    #       first promts the user to annotate a textgrid to show sections of the contour
    #       to be ignored dur to gross segmental effects. It then creates a manipulation
    #       object in which the user can correct errors such as pitch double and pitch
    #       halving.
    #    4. The pitch contour is smoothed using and points of maximum curvature are
    #       identified.
    #    3. The script draws a spectrogram of the sound object, the refer-
    #       ence tier, and the pitch contour.
    #       The pitch contour is drawn using @c3Pogram, and shows F0 contour on the
    #       y-axis with the colour intensity and dot size indicating estimated Cepstral
    #       Peak Prominence at that time. (Red dots indicate CPP values more than one SD
    #       below the utterance mean.)
    #       The figure also can display other values derived from the script (see D.3.b.)
    #       NOTE: A legend is drawn before the image is saved but not earlier.
    #    4. The script will display the sound and a textgrid for the current object. The
    #       textgrid only displays the reference, tonal, and maxK tiers, along with any
    #       tiers listed in the "Other tiers to show" master menu.
    #       MaxK marks estimated locations of maximum curvature.
    #       THE USER SHOULD ANNOTATE THE TONAL TIER USING TIME POINTS INDICATED IN MAXK.
    #    5. A menu window will appear.
    #           a. The user can change the following parameters on the fly:
    #                  1. Initial Praat smoothing bandwidth
    #                  2. Physiological constraints
    #                  3. Fine-grained smoothing
    #           b. The user can select / deselect the following graphical output options:
    #                  1. Draw corrected contour (contour used in calculating curvature)
    #                  2. Draw curvature contour (y axis will be drawn on the right)
    #                  3. Draw resynthesised contour (calculated from @idealise and
    #                     @physioconstraintsJ/K functions)
    #                  4. Draw tonal tier annotations and ideal targets
    #           c. The user can add a "Comment" to the report file
    #           d. Change the "Next object" value to jump to a different file in the
    #              directory.
    #           e. The options buttons, allow the user to:
    #                  1. Smooth: re-Smooth the contour using Praat smoothing factor in
    #                     the textbox. (Note: this will delete the current MaxK and Tonal
    #                     annotation tier)
    #                  2. "Fix F0": runs @FixPitch (see D.1. above)
    #                  2. "Process": PROCESS, SAVE, AND REVIEW ANNOTATIONS AND RESYNTHESIS
    #                  3. "<": Go back one object without saving .
    #                  4. "Next": Go to the "Next object" without saving.
    #                  5. "Exit": exit script (clears all temporary objects and
    #                     completes report)
    #                  7. "Revert" and "Stop" are default Praat UI menu options.
    #              NOTE: PROCESS MUST BE SELECTED IN ORDER TO SAVE CHANGES!!!
    #
    # E. OUTPUT FOR EACH FILE PROCESSED
    #     1. main folder: updated TextGrids (if saved)
    #     2. pitch folder: updated pitch objects
    #     2. resynth folder: resynthesised pitch object and sound file
    #     3. manipulation folder:
    #            a. resynthesised sound manipulation object: "[soundName].Manipulation"
    #            b. table showing time (secs) and F0 (Hz) contours: initial
    #               smoothed, ideal, and smoothed ideal: "[soundName]_all_F0.Table"
    #            c. table showing time (secs) and F0 (Hz) coordinates of of maximum
    #               curvature ideal tonal targets along with maxK annotations:
    #               [soundName]_ideal_TTs.Table
    #     3. Report table showing smoothing parameters, tonal analysis, and comments
    #     3. Figure with spectrogram, pitch contour, and selected display parameters.
    #        It also includes a legend.
    #
    # F. GENERAL OUTPUT (OUTPUT FOLDER)
    #     1. tab-delineated file reporting latest smoothing parameters, tonal tier
    #        annotations and comments for each set of files: "Max-K_Analysi_Report.txt"
    #     2. tab-delineated file showing most recent pitch processing parameter settings
    #        in master UI form.

    # FAILSAFES / ERROR HANDLING
    #     1. Textgrid backup
    #     2. % annotations are added to Max K to show onset and offset of utterance
    #        voicing
    #     3. Error windows when idealisation functions break down and added to comments
    #        textbox and report entry (shown in report during batch processing)

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
    optionmenu Curvature_estimation 1
        option Second derivative
        option Angle of vectors
    natural Minimum_F0 55
    natural Maximum_F0 400
    integer Initial_praat_smooothing_bandwidth 10

    comment Post idealisation smoothing parameters (moving point average)
    integer Physiological_constraints 8
    integer Fine_grained_smoothing 1
    comment
    boolean Batch_process_directory
endform

### CALL SUBROUTINES
@versionCheck
@infoLines
@setUpDirsFiles
@getSoundGridInfo
@setVars
@saveMenuVars
@main
@saveAndTidy

# INCLUDE SUBROUTINES AND FUNCTION LIBRARIES
# Subroutines take no arguments are written specifically for this set of scripts
include Subroutines/infoLines.praat
include Subroutines/main.praat
include Subroutines/setUpDirsFiles.praat
include Subroutines/setVars.praat
include Subroutines/getSoundGridInfo.praat
include Subroutines/drawStuffForEditing.praat
include Subroutines/createLegendTable.praat
include Subroutines/updateReport.praat
include Subroutines/saveMenuVars.praat
include Subroutines/saveAndTidy.praat

# Functions arguments and are (generally) designed to be adaptable to any script
include Functions/ContourAnalysis.praat
include Functions/Graphical.praat
include Functions/FixPitch.praat
include Functions/Idealisation.praat
include Functions/Maths.praat
include Functions/Management.praat
