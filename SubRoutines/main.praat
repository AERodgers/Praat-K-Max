# STH Analysis sub-routine: main
# =============================
# Written for Praat 6.0.40

# script by Antoin Eoin Rodgers
# rodgeran@tcd.ie
# Phonetics and speech Laboratory, Trinity College Dublin
# October 10 -  December 10,  2019

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

        # get sound info
        selectObject: sound_list
        sound$ = Get string: curr_sound
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
           if not alreadyOpened#[curr_sound] and userInput
               selectObject: textgrid
               Save as text file: backupPath$ + sound$ + ".TextGrid"
               alreadyOpened#[curr_sound] = 1
           endif

            # add second set of STH tiers -- NB: adds tiers for own use: remove later
            kTiers = 1
            if userInput
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
            endif

            # Read in or create pitch file
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

            ###vvvv Key bit of code!
            ### Calculate Elbows of smoothed contour
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
                    integer: "Initial Praat smooothing bandwidth", pre_smoothing
                    integer: "Physiological constraints smoothing parameter", coarse_smoothing
                    integer: "Fine grained smoothing", fine_smoothing
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
				coarse_smoothing = physiological_constraints_smoothing_parameter
				fine_smoothing = fine_grained_smoothing
				pre_smoothing = initial_praat_smooothing_bandwidth
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
                    ... minF0, maxF0, k.table, k.min,
                    ... coarse_smoothing, fine_smoothing, jk$
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
                    ... minF0, maxF0, k.table, k.min,
                    ... coarse_smoothing, fine_smoothing, jk$
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
