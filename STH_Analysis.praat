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
    #   2. textgrid with at minimum a reference tier
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
    #     7. exit the script (clears all temporary objects and completes report)
    #     8. Change the smoothing parameters on the fly and add an additions comment.
    #        This is done using the input boxes above
    #
    # OUTPUT
    #     1. updated TextGrids (if saved)
    #     2. resynthesised sounds and associated manipulation objects
    #        (if resynth option selected)
    #
    # FAILSAFES / ERROR HANDLING
    #     1. a backup directory is created which contains:
    #            - backup of each TextGrid as it was before script was run
    #            - a report listing all texgrids changed
    #     2. Resynth finds first defined F0 nearest to annotated tonal targets
    #        and adjusts textgrid accordingly. If no nearby defined F0 found,
    #        error warning displayed.
    #     3. Error windows when idealisation functions break down
    #        (shown in report during batch processing)

### COMPATABILITY CHECK
version$ = praatVersion$
if number(left$(version$, 1)) < 6
    echo You are running Praat 'praatVersion$'.
    ... 'newline$'This script runs on Praat version 6.0.40 or later.
    ... 'newline$'To run this script, update to the latest
    ... version at praat.org
    exit
endif

### INPUT FORM
form Text grid editor: Choose Directory
    sentence Directory C:\Users\antoi\Desktop\test
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
    word Boundary_tier boundary
    comment File format
    word Pitch_prefix PF_
    word Resynthesis_prefix RS_
    word Sound_suffix .wav
    comment Pitch Processing Parameters
    natural Minimum_F0 120
    natural Maximum_F0 320
    integer Pre_smoothing 10
    comment Physiological constraints approximation parameters
    integer Coarse_smoothing 8
    integer Fine_smoothing 3
    comment
    word phonology_colour Navys
    boolean Batch_process_directory
endform

### RUN MAIN PROCEDURE
startTime$ = date$()
writeInfoLine: "EDIT/ANALYSE SOUNDS USING SECONDARY TONE HYPOTHESIS"
appendInfoLine: "=================================================="
appendInfoLine: newline$, "Started:  ", startTime$
if batch_process_directory
    appendInfoLine: "Be patient. This may take a while..."
endif

@main

appendInfo: newline$, "Finished: ", date$()

### MAIN PROCEDURE (takes no arguments, uses non dot-variables, runs main interface)
procedure main
    # initialize directories and variables
    @setUpDirsFiles
    @getSoundGridInfo
    @shortenVars

    # save initial variables
    writeFile: outputPath$ + "STH_form_params.Table", "Parameter" + tab$ + "Value"
    ... + newline$ + "Minimum_F0" + tab$ + string$(minimum_F0)
    ... + newline$ + "Maximum_F0" + tab$ + string$(maximum_F0)
    ... + newline$ + "Pre_smoothing" + tab$ + string$(pre_smoothing)
    ... + newline$ + "Coarse_smoothing" + tab$ + string$(coarse_smoothing)
    ... + newline$ + "Fine_smoothing" + tab$ + string$(fine_smoothing)

    # set main flags
    alreadyOpened# = zero# (numSounds)
    pitchSaved# = zero# (numSounds)
    draw_f0_corrected = 0
    draw_K = 0
    draw_resynth = 1
    draw_phono = 1

    for curr_sound to numSounds
        # set binary flags
        show_RS = 0

        # get sound name
        selectObject: sound_list
        sound$ = Get string: curr_sound

        #add info about current sound to output window
        curSound$ = string$(curr_sound)
        curr_pc = round(1000 * (curr_sound) / numSounds) / 10
        curr_pc$ = string$(curr_pc)
        if curr_pc = round (curr_pc)
            curr_pc$ += ".0"
        endif

        ### Get previous report data, if exists
        selectObject: report
        tableRow = Search column: "sound", sound$
        if tableRow
            comment$ = Get value: tableRow, "comments"
            if comment$ = "?" or comment$ = " "
                comment$ = ""
            endif
            if edit_choice > 3
                smoothString$ = Get value: tableRow, "smooth"
                left = index(smoothString$, " ")
                right = rindex(smoothString$, " ")
                length = length(smoothString$)
                pre_smoothing = number(left$(smoothString$, left))
                coarse_smoothing = number(mid$(smoothString$, length - left + 1,
                    ... right - left - 1))
                fine_smoothing = number(right$(smoothString$, length - right))
            endif
        else
            Append row
            tableRow = Get number of rows
            comment$ = ""
            Set string value: tableRow, "count", curSound$ + "/" + string$(numSounds)
            Set string value: tableRow, "sound", sound$
            Set string value: tableRow, "smooth", string$(pre_smoothing)
                ... + " " + string$(coarse_smoothing) + " " + string$(fine_smoothing)
        endif

        #edit textgrid if it exists
        selectObject: textgrid_list
        textgridExists = Has word: sound$

        if textgridExists
            # read in sound
            soundobject = Read from file: dir$ + sound$ + suffix$
            Scale intensity: 65

            # read in textgrid, identify core tiers
            textgrid = Read from file: dir$ + sound$ + ".TextGrid"
            @findTier: "t_tier", textgrid, t_tier$
            @findTier: "b_tier", textgrid, b_tier$
            @findTier: "r_tier", textgrid, r_tier$

            # get Phonology from TextGrid (if exists)
            if t_tier * b_tier
                keepTiers# = {t_tier, b_tier}
                @getPhono: keepTiers#, b_tier$, textgrid
                phonology$ =  getPhono.text$
            else
                phonology$ =  ""

            endif

            ### Respond to previous UI commands (if applicable)
            # read in resynth (if previously chosen)
            if edit_choice = 3
                resynthManip = Read from file: manipPath$ + sound$ + ".Manipulation"
                show_RS = 1
            endif
            # run reset of K analysis, smoothing, and fix pitch if selected
            if edit_choice < 3 and edit_choice
                    selectObject: textgrid
                    # Remove K tiers if contour being resmoothed or F0 re-corrected
                    numTiers = Get number of tiers
                    for i to numTiers
                        curTier = numTiers - i + 1
                        curName$ = Get tier name: curTier
                        if curName$ = t_tier$ or curName$ = "maxK"
                            Remove tier: curTier
                        endif
                    endfor
                if edit_choice = 2
                    # backup original pitch object
                    if not pitchSaved#[curr_sound] and pitchExists
                        tempPitch = Read from file: pitchPath$ + sound$ + ".Pitch"
                        Save as text file: backupPath$ + sound$ + ".Pitch"
                        Remove
                        pitchSaved#[curr_sound] = 1
                    endif
                    @fixPitch: textgrid, r_tier, soundobject, 0.01, 1, 3, minF0, maxF0
                    selectObject: fixPitch.new
                    Save as text file: pitchPath$ + sound$ + ".Pitch"
                    Remove
                endif
            endif

           # back up textgrid prior to editing the first time it is opened
           if not alreadyOpened#[curr_sound]
               selectObject: textgrid
               Save as text file: backupPath$ + sound$ + ".TextGrid"
               alreadyOpened#[curr_sound] = 1
           endif

            # add second set of STH tiers -- NB: adds tiers for own use: remove later
            @findTier: "first_tier", textgrid, "rhythmic"
            if first_tier
                first_tier$ = "rhythmic"
            else
                first_tier$ = r_tier$
            endif

            @insMissTier: textgrid, "sonorance", first_tier$, 1
            @insMissTier: textgrid, "vowel", "sonorance" , 1
            @insMissTier: textgrid, "toneExtrema", "sonorance", 0
            # insert and populate tiers if they do not exist
            @insMissTier: textgrid, t_tier$, "vowel", 0
            @insMissTier: textgrid, "maxK", t_tier$, 0
            kTiers = insMissTier.tierExists
            @insMissTier: textgrid, b_tier$, "maxK", 0

            ###vvvv Key bit of code!
            ### Calculate Elbows of smoothed contour
            pitchExists = fileReadable
                ... (pitchPath$ + sound$ + ".Pitch")
            if pitchExists
                tempPitch = Read from file: pitchPath$ + sound$ + ".Pitch"
            else
                @fixPitch: textgrid, r_tier, soundobject, 0.01, 1, 3, minF0, maxF0
                tempPitch = fixPitch.new
                selectObject: tempPitch
                Save as text file: pitchPath$ + sound$ + ".Pitch"
            endif
            fixedPitch = Smooth: pre_smoothing
            @k: fixedPitch, 0
            ####^^^^

            if not kTiers
                @findTier: "maxK_tier", textgrid, "maxK"
                @findTier: "t_tier", textgrid, t_tier$
                selectObject: k.max
                numKMax = Get number of rows
                for i to numKMax
                    tMax[i] = Get value: i, "Time"
                    kMax[i] = Get value: i, "K"
                    toneLike$[i] = Get value: i, "toneLike"
                endfor
                selectObject: textgrid
                for i to numKMax
                    Insert point: t_tier, tMax[i], ""
                    Insert point: maxK_tier, tMax[i],
                        ... toneLike$[i] + fixed$(kMax[i]*100, 0)
                endfor
            endif

            #  show resynth if selected
            if show_RS = 1 and userInput
                selectObject: resynthManip
                Edit
                editor: resynthManip
                    Set pitch units: "semitones re 100 Hz"
                    Set pitch range: 12 * log2(maxF0/100)
                endeditor
            endif
            @drawStuffForEditing
            if userInput
                # remove tiers for temporary textgrid (declutter view window)
                @temp_textgrid: "textgrid",
                    ... "ortho vowel register scope foot toneExtrema fixF0 sonorance"
                    ... + " HDur LDur"

                # show sound and textgrid
                selectObject: temp_textgrid.object
                plusObject: soundobject
                Edit
                # pause to let user edit the text grid
                pauseText$ = "Editing " + sound$
                beginPause: pauseText$
                    comment: "Currently showing waveform " + sound$
                        ... + " (" + curSound$ + "/" + string$(numSounds) + ")"
                    integer: "Pre smoothing", pre_smoothing
                    integer: "Coarse smoothing", coarse_smoothing
                    integer: "Fine smoothing", fine_smoothing
                    boolean: "Draw corrected contour", draw_f0_corrected
                    boolean: "Draw curvature contour", draw_K
                    boolean: "Draw resynthesised contour", draw_resynth
                    boolean: "Draw phonology and ideal targets", draw_phono
                    sentence: "Comment", comment$
                    integer: "Next object", curr_sound + 1

                edit_choice = endPause:
                    ... "Smooth",
                    ... "Fix F0",
                    ... "Process",
                    ... "<",
                    ... "Next",
                    ... "Exit", 4

                draw_f0_corrected = draw_corrected_contour
                draw_K = draw_curvature_contour
                draw_resynth = draw_resynthesised_contour
                draw_phono = draw_phonology_and_ideal_targets
            endif
            if userInput
                @merge_textgrids
            endif

            #purge Blanks in tone tier
            selectObject: textgrid
            numTonePts = Get number of points: t_tier
            for i to numTonePts
                curPt = numTonePts - i + 1
                curPt$ = Get label of point: t_tier, curPt
                if curPt$ = ""
                    Remove point: t_tier, curPt
                endif
            endfor

            # process pause menu choices
            if edit_choice = 6
                beginPause: pauseText$
                    comment: "Exit Script?"
                exitNow = endPause: "No", "Yes", 1
                if exitNow = 2
                    curr_sound = numSounds
                else
                    curr_sound -= 1
                    edit_choice = 5
                endif
            elsif edit_choice = 5
                curr_sound = next_object - 1
            elsif edit_choice = 4
                curr_sound = (curr_sound - 2) + ((curr_sound - 2) < 0)

            elsif edit_choice = 3
                curr_sound -= 1
                keepTiers# = {t_tier, b_tier}
                @idealise: soundobject, textgrid, tempPitch,
                    ... minF0, maxF0, k.table, k.min, coarse_smoothing, fine_smoothing
                selectObject: idealise.wav
                Save as WAV file: rsDirPrefix$ + sound$
                    ... + ".wav"
                Remove
                selectObject: idealise.manip
                Save as text file: manipPath$ + sound$
                    ... + ".Manipulation"
                Remove
                selectObject: idealise.table
                Save as text file: manipPath$ + sound$
                    ... + "_ideal_TTs.Table"
                Remove
                selectObject: idealise.allF0Contours
                Save as text file: manipPath$ + sound$
                    ... + "_all_F0.Table"
                Remove
                selectObject: idealise.pitch
                Save as text file: resynthPath$ + sound$ + ".Pitch"
                Remove
                selectObject: textgrid
                Save as text file: dir$ + sound$ + ".TextGrid"
                #update report
                @updateReport
            elsif edit_choice = 2
                curr_sound -= 1
            elsif edit_choice = 1
                curr_sound -= 1
            else
                keepTiers# = {t_tier, b_tier}
                @idealise: soundobject, textgrid, tempPitch,
                    ... minF0, maxF0, k.table, k.min, coarse_smoothing, fine_smoothing
                @drawIdealization: idealise.pitch, c3pogram.minT, c3pogram.maxT,
                    ... drawC3pogram.minF0, drawC3pogram.maxF0
                if draw_phono
                    @drawPhono: idealise.table, c3pogram.minT, c3pogram.maxT,
                    ... drawC3pogram.minF0, drawC3pogram.maxF0, phonoCol$
                endif
                selectObject: idealise.wav
                Save as WAV file: rsDirPrefix$ + sound$ + ".wav"
                Remove
                selectObject: idealise.manip
                Save as text file: manipPath$ + sound$ + ".Manipulation"
                Remove
                selectObject: idealise.table
                Save as text file: manipPath$ + sound$
                    ... + "_ideal_TTs.Table"
                Remove
                selectObject: idealise.allF0Contours
                Save as text file: manipPath$ + sound$
                    ... + "_all_F0.Table"
                Remove
                selectObject: idealise.pitch
                if not pitchFileExists
                    Save as text file: resynthPath$ + sound$ + ".Pitch"
                endif
                Remove

                #update report
                @updateReport
            endif

            @createLegendTable
            yOffset = (drawC3pogram.maxF0 - drawC3pogram.minF0)/15
            @drawLegend: c3pogram.minT, c3pogram.maxT,
            ... drawC3pogram.minF0, drawC3pogram.maxF0,
                ... k.table, "Time", "F0",
                ... tempLegend, 0.01
            selectObject: tempLegend
            Remove
            Save as 600-dpi PNG file:  imagePath$ + sound$ + ".png"

            # remove current for loop surplus objects
            selectObject: textgrid
            plusObject: soundobject
            plusObject: fixedPitch
            plusObject: tempPitch
            plusObject: k.table
            plusObject: k.max
            plusObject: k.min
            if show_RS
                plusObject: resynthManip
            endif
            Remove
        else
            if userInput
                beginPause: "WARNING"
                comment: sound$ + " does not have an associated text grid file."
                comment: "It will be skipped."
                endPause: "Continue", 1
            endif

       endif

    endfor

    #save report
    selectObject: report
    Save as tab-separated file: reportPath$

    # remove remaining objects
    selectObject: sound_list
    plusObject: textgrid_list
    plusObject: report
    Remove
endproc

### SUB-PROCEDURES (take no arguments, use non dot-variables)
procedure setUpDirsFiles
    dir$ = directory$
    suffix$ = sound_suffix$

    # correct form errors
    if suffix$ != "" and left$(suffix$, 1) != "."
        suffix$ = "." + suffix$
    endif
    if right$(dir$, 1) != "/" or right$(dir$, 1) != "\"
        dir$ += "/"
    endif

    # create directory paths
    backupPath$ = dir$ + backup_directory$ + "/"
    backupPath$ = replace$(backupPath$, "//", "/", 0)
    imagePath$ = dir$ + image_directory$ + "/"
    imagePath$  = replace$(imagePath$ , "//", "/", 0)
    manipPath$ = dir$ + manipulation_directory$ + "/"
    manipPath$  = replace$(manipPath$ , "//", "/", 0)
    outputPath$ = dir$ + output_directory$ + "/"
    outputPath$  = replace$(outputPath$ , "//", "/", 0)
    pitchPath$ = dir$ + pitch_directory$ + "/" + pitch_prefix$
    pitchPath$  = replace$(pitchPath$ , "//", "/", 0)
    resynthPath$ = dir$ + resynth_directory$ + "/"
    resynthPath$  = replace$(resynthPath$ , "//", "/", 0)
    rsDirPrefix$ = resynthPath$ + resynthesis_prefix$
    rsDirPrefix$  = replace$(rsDirPrefix$ , "//", "/", 0)

    # create directories (if they don't exist)
    createDirectory: dir$ + backup_directory$
    createDirectory: dir$ + image_directory$
    createDirectory: dir$ + manipulation_directory$
    createDirectory: dir$ + output_directory$
    createDirectory: dir$ + pitch_directory$
    createDirectory: dir$ + resynth_directory$

    # create report (if it doesn't exist)
    reportPath$ = outputPath$ + "STH_Analysis_Report.txt"
    exists = fileReadable: outputPath$ + "STH_Analysis_Report.txt"
    if not exists
        writeFile:  reportPath$, "count" + tab$ + "sound" + tab$ + "smooth"
            ... + tab$ + "phonology" + tab$ + "comments"
    endif
    report = Read from file: reportPath$
endproc

procedure getSoundGridInfo
    # get list of wave files
    sound_list_temp = Create Strings as file list: "fileList",
        ... dir$ + "*" + suffix$
    # exit the script if directory contains no sound files
    numSounds = Get number of strings
    if numSounds = 0
        exitScript: "DIRECTORY CONTAINS NO 'suffix$' files." + newline$
    endif

    # get list of file names without suffix
    selectObject: sound_list_temp
    Replace all: suffix$, "", 0, "literals"
    Rename: "sounds"
    sound_list = selected ()
    numSounds = Get number of strings
    selectObject: sound_list_temp
    Remove

    # get list of textgrids in target file
    textgrid_file_list = Create Strings as file list: "textgrids",
        ... dir$ + "*.textgrid"
    textgrid_list_temp1 = selected ()
    Replace all: ".TextGrid", "", 0, "literals"
    textgrid_list_temp2 = selected ()
    Rename: "textgrids"
    noprogress To WordList
    textgrid_list = selected ()
    selectObject: textgrid_list_temp1
    plusObject: textgrid_list_temp2
    Remove
endproc

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

procedure drawStuffForEditing
    # Draw C3Pogram
    pitchFileExists = fileReadable(resynthPath$ + sound$ + ".Pitch")
    idealTableExists = fileReadable(manipPath$ + sound$ + "_ideal_TTs.Table")

    # calculate figure title and subtitle based on contour display flags
    subPrt1$[1] = ""
    subPrt1$[2] = "resynthesised contour"
    subPrt1$[3] = "corrected contour"
    subPrt1$[4] = "corrected and resynthesised contours"
    comma$[1] = ""
    comma$[2] = ", "
    with$[1] = ""
    with$[2] = "with "
    subPrt2$[1]= ""
    subPrt2$[2] = "phonology"
    subPrt2$[3] = "curvature"
    subPrt2$[4] = "curvature and phonology"

    subPrt1 = draw_f0_corrected * 2 + draw_resynth
    subPrt2 = draw_K * 2 + draw_phono
    with = (subPrt1 or subPrt2) + 1
    comma = (subPrt1 and subPrt2) + 1

    heading$ =  replace$(sound$, "_", "\_ ", 0) + " %F_0 contour"
    subPrt1$ = subPrt1$[subPrt1 + 1]
    headingPt2$ = subPrt2$[subPrt2 + 1]
    subtitle$ = with$[with] + subPrt1$ + comma$[comma] + headingPt2$

    # Draw c3pogram
    @c3pogram: 3, 2, 1, heading$, subtitle$,
        ... textgrid, soundobject, r_tier, minF0, maxF0

    # draw corrected F0 contour and K contour
    Solid line
    Line width: 2
    Magenta
    Select outer viewport: 0, 6.5, 0, 3.35
    Axes: c3pogram.minT, c3pogram.maxT,
        ... drawC3pogram.minF0,  drawC3pogram.maxF0
    if draw_f0_corrected
        @draw_table_line: k.table, "Time", "F0", c3pogram.minT,
            ... c3pogram.maxT, 1
    endif
    Line width: 1
    Red
    if draw_K
        @drawK: k.max,  k.table, 1, c3pogram.minT, c3pogram.maxT
    endif

    if draw_phono and idealTableExists and userInput
        tempIdeal = Read from file: manipPath$ + sound$
            ... + "_ideal_TTs.Table"
        @drawPhono: tempIdeal, c3pogram.minT, c3pogram.maxT,
            ... drawC3pogram.minF0, drawC3pogram.maxF0, phonoCol$
        selectObject: tempIdeal
        Remove
    endif

    ### draw idealised pitch contour
    if pitchFileExists and userInput and draw_resynth
        .tempPitch = Read from file:
            ... resynthPath$ + sound$ + ".Pitch"
        @drawIdealization: .tempPitch, c3pogram.minT, c3pogram.maxT,
            ... drawC3pogram.minF0, drawC3pogram.maxF0
        selectObject: .tempPitch
        Remove
    endif

    Solid line
    Line width: 1
    Black
    Select outer viewport: 0, 6.5, 0, 4
endproc

procedure createLegendTable
    tempLegend = Create Table with column names: "legend", 1, "style colour text size"
    legendLines = 1
    Set string value: 1, "style", "Dot"
    Set string value: 1, "colour", "Blue"
    Set string value: 1, "text", "%F_0 + CPP"
    Set numeric value: 1, "size", 2

    if draw_f0_corrected
        legendLines += 1
        Append row
        Set string value: legendLines, "style", "Line"
        Set string value: legendLines, "colour", "Magenta"
        Set string value: legendLines, "text", "Corrected F0"
        Set numeric value: legendLines, "size", 2
    endif

    if draw_K
        legendLines += 1
        Append row
        Set string value: legendLines, "style", "Line"
        Set string value: legendLines, "colour", "Red"
        Set string value: legendLines, "text", "curvature"
        Set numeric value: legendLines, "size", 2
    endif

    if draw_resynth
        legendLines += 1
        Append row
        Set string value: legendLines, "style", "Line"
        Set string value: legendLines, "colour", "Lime"
        Set string value: legendLines, "text", "%F_0 Resynthesis"
        Set numeric value: legendLines, "size", 2
    endif

    if draw_phono
        legendLines += 1
        Append row
        Set string value: legendLines, "style", "x"
        Set string value: legendLines, "colour", "Black"
        Set string value: legendLines, "text", "Ideal Targets"
        Set numeric value: legendLines, "size", 10
    endif
endproc

procedure updateReport
    selectObject: report
    Set string value: tableRow, "comments", comment$
    Set string value: tableRow, "smooth", string$(pre_smoothing)
        ... + " " + string$(coarse_smoothing) + " " + string$(fine_smoothing)
    Set string value: tableRow, "phonology", phonology$
endproc

include Fns/ContourAnalysis.praat
include Fns/Graphical.praat
include Fns/FixPitch.praat
include Fns/Idealisation.praat
include Fns/Maths.praat
include Fns/ObjectManagement.praat
