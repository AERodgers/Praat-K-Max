# MAX-K SUBROUTINE: MAIN ROUTINE
# ==============================
# Written for Praat 6.0.40

# script by Antoin Eoin Rodgers
# rodgeran@tcd.ie
# Phonetics and speech Laboratory, Trinity College Dublin
# October 10 - December 17, 2019

procedure main
    for curr_sound to numSounds
        # set flags and variables
        show_RS = 0
        # get sound info
        selectObject: sound_list
        sound$ = Get string: curr_sound
        curSound$ = string$(curr_sound)

        ### GET PREVIOUS REPORT DATA, IF EXISTS
        ###
        selectObject: report
        tableRow = Search column: "sound", sound$
        if tableRow
            comment$ = Get value: tableRow, "comments"
            if comment$ = "?" or comment$ = " "
                comment$ = ""
            endif
            if edit_choice > 3 or edit_choice < 1
            pre_smoothing = Get value: tableRow, "pre_smooth"
            coarse_smoothing = Get value: tableRow, "coarse_smooth"
            fine_smoothing = Get value: tableRow, "fine_smooth"
        else
            Append row
            tableRow = Get number of rows
            comment$ = ""
            Set string value: tableRow, "count", curSound$
            Set string value: tableRow, "sound", sound$
            Set numeric value: tableRow, "pre_smooth", pre_smoothing
            Set numeric value: tableRow, "coarse_smooth", coarse_smoothing
            Set numeric value: tableRow, "fine_smooth", fine_smoothing
        endif

        ### OPEN TEXTGRID FOR EDITING, IF EXISTS
        ###
        selectObject: textgrid_list
        textgridExists = Has word: sound$
        if textgridExists
            tempPitch = 0
            # read in sound and scale audio
            soundobject = Read from file: dir$ + sound$ + suffix$
            Scale intensity: 65

            # read in textgrid, identify core tiers
            textgrid = Read from file: dir$ + sound$ + ".TextGrid"
            @findTier: "t_tier", textgrid, t_tier$
            @findTier: "r_tier", textgrid, r_tier$

            # BACK UP TEXTGRID FIRST TIME OPENED
            if not alreadyOpened#[curr_sound] and userInput
                selectObject: textgrid
                Save as text file: backupPath$ + sound$ + ".TextGrid"
                alreadyOpened#[curr_sound] = 1
            endif

            # get Tonal annotation from TextGrid (if exists)
            if t_tier
                keepTiers# = {t_tier}
                @getTonal: keepTiers#, textgrid
                tonalText$ =  getTonal.text$
            else
                tonalText$ =  ""
            endif

            # PROCESS PREVIOUS UI COMMANDS AND OUTCOMES,(IF APPLICABLE)
            # read in resynth (if previously chosen)

            if edit_choice = 3
                resynthManip = Read from file: manipPath$ + sound$ +
                    ... ".Manipulation"
                show_RS = 1
            endif
            # run reset of K analysis, smoothing, and fix pitch if selected
            if edit_choice < 3 and edit_choice
                selectObject: textgrid
                # Remove K tiers if contour being smoothed or F0 corrected
                numTiers = Get number of tiers
                for i to numTiers
                    curTier = numTiers - i + 1
                    curName$ = Get tier name: curTier
                    if curName$ = t_tier$ or curName$ = "maxK"
                        Remove tier: curTier
                    endif
                endfor
                if edit_choice = 2
                    @fixPitch: textgrid, r_tier, soundobject, 0.01, 1, 3,
                        ... minF0, maxF0
                    selectObject: fixPitch.new
                    Save as text file: pitchPath$ + sound$ + ".Pitch"
                    tempPitch = fixPitch.new
                endif
            endif


            # ADD EXTRA TIERS IF NOT PRESENT
            kTiers = 1
            if userInput
                @findTier: "first_tier", textgrid, "rhythmic"
                if first_tier
                    first_tier$ = "rhythmic"
                else
                    first_tier$ = r_tier$
                endif

                if justForAER
                    .tTierAfter$ = "vowel"
                    @insMissTier: textgrid, "sonorance", first_tier$, 1
                    @insMissTier: textgrid, "vowel", "sonorance" , 1
                    @insMissTier: textgrid, "toneExtrema", "sonorance", 0
                else
                    .tTierAfter$ = r_tier$
                endif

                # insert and populate tiers if they do not exist
                @insMissTier: textgrid, t_tier$, .tTierAfter$, 0
                @insMissTier: textgrid, "maxK", t_tier$, 0
                kTiers = insMissTier.tierExists
            endif

            # READ / CREATE PITCH FILE
            pitchExists = fileReadable
                ... (pitchPath$ + sound$ + ".Pitch")

            # backup original pitch object
            if not pitchSaved#[curr_sound] and pitchExists
                backupPitch = Read from file: pitchPath$ + sound$
                    ... + ".Pitch"
                Save as text file: backupPath$ + sound$ + ".Pitch"
                pitchSaved#[curr_sound] = 1
                Remove
            endif

            if pitchExists and not tempPitch
                pitchOrig = Read from file: pitchPath$ + sound$ + ".Pitch"
                noprogress Interpolate
                tempPitch = selected()
                selectObject: pitchOrig
                Remove
                selectObject: tempPitch
            elsif not tempPitch
                @fixPitch: textgrid, r_tier, soundobject, 0.01, 1, 3,
                    ... minF0, maxF0
                tempPitch = fixPitch.new
                selectObject: tempPitch
                Save as text file: pitchPath$ + sound$ + ".Pitch"
            endif

            selectObject: tempPitch
            fixedPitch = Smooth: pre_smoothing

            # CREATE PITCH TABLE (REQUIRES INTERPOLATED PITCH OBJECT)
            selectObject: fixedPitch
            noprogress Down to PitchTier
            pitchTier = selected()
            noprogress Down to TableOfReal: "Semitones"
            tableOfReal = selected()
            pitchTable = To Table: "Frame"
            Append column: "K"
            Append column: "toneLike"
            selectObject: pitchTier
            plusObject: tableOfReal
            Remove

            # CALCULATE MAXIMUM CURVATURE USING F0''(t)
            @k: pitchTable, "Time", "F0"
            # populate empty maxK Tier
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
                        ... toneLike$[i]
                endfor
            endif
            # show resynth, if flagged
            if show_RS = 1 and userInput
                selectObject: resynthManip
                Edit
                editor: resynthManip
                    Set pitch units: "semitones re 100 Hz"
                    Set pitch range: 12 * log2(maxF0/100)
                endeditor
            endif

            @drawStuffForEditing

            ### RUN UI MENU
            if userInput
                # Create temporary textgrid for editing (declutter view window)
                @temp_textgrid: "textgrid", r_tier$ + " " + t_tier$ + " maxK "
                    ... + keepTiers$

                # show sound and textgrid
                selectObject: temp_textgrid.object
                plusObject: soundobject

                Edit
                # pause to let user edit the text grid
                pauseText$ = "Displaying " + sound$
                    ... + " (" + curSound$ + "/" + string$(numSounds) + ")"
                beginPause: pauseText$
                    comment: "Current smoothing parameters"
                    natural: "Praat smooothing bandwidth", pre_smoothing
                    natural: "Physiological constraints", coarse_smoothing
                    natural: "Fine grained smoothing", fine_smoothing
                    comment: "Image Drawing Options"
                    boolean: "Corrected contour", draw_f0_corrected
                    boolean: "Curvature contour", draw_K
                    boolean: "Resynthesised contour", draw_resynth
                    boolean: "Tonal annotation and ideal targets", draw_tonal
                    sentence: "Comment", comment$
                    integer: "Next object", curr_sound + 1
                    if feedback
                        comment: "ERRORS AND OBSERVATIONS"
                        if warning
                            selectObject: errorBeep
                            Play
                        endif
                    endif
                    for i to feedback
                        comment: feedback$[i]
                    endfor
                edit_choice = endPause:
                    ... "Smooth",
                    ... "Fix F0",
                    ... "Process",
                    ... "<",
                    ... "Next",
                    ... "Exit", 4

                draw_f0_corrected = corrected_contour
                draw_K = curvature_contour
                draw_resynth = resynthesised_contour
                draw_tonal = tonal_annotation_and_ideal_targets
                coarse_smoothing = physiological_constraints
                fine_smoothing = fine_grained_smoothing
                pre_smoothing = praat_smooothing_bandwidth
                @merge_textgrids
                feedback = 0
                warning = 0
            endif

            # purge Blanks in tone tier
            selectObject: textgrid
            numTonePts = Get number of points: t_tier
            for i to numTonePts
                curPt = numTonePts - i + 1
                curPt$ = Get label of point: t_tier, curPt
                if curPt$ = ""
                    Remove point: t_tier, curPt
                endif
            endfor

            # PROCESS PAUSE MENU CHOICES
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
                keepTiers# = {t_tier}
                @idealise: soundobject, textgrid, t_tier$, tempPitch,
                    ... minF0, maxF0, k.min,
                    ... coarse_smoothing, fine_smoothing
                @saveAndRemoveFiles
            elsif edit_choice = 2
                curr_sound -= 1
            elsif edit_choice = 1
                curr_sound -= 1
            else
                keepTiers# = {t_tier}
                @idealise: soundobject, textgrid, t_tier$, tempPitch,
                    ... minF0, maxF0, k.min,
                    ... coarse_smoothing, fine_smoothing
                @drawIdealization: idealise.pitch, c3pogram.minT, c3pogram.maxT,
                    ... drawC3pogram.minF0, drawC3pogram.maxF0, idealCol$
                if draw_tonal
                    @drawTonal: idealise.table, c3pogram.minT, c3pogram.maxT,
                    ... drawC3pogram.minF0, drawC3pogram.maxF0,
                    ... "ideal_T", "ideal_F0", tonalCol$
                endif
                @saveAndRemoveFiles
            endif

            # Add legend and save figure
            @createLegendTable
            yOffset = (drawC3pogram.maxF0 - drawC3pogram.minF0)/15
            @drawLegend: c3pogram.minT, c3pogram.maxT,
            ... drawC3pogram.minF0, drawC3pogram.maxF0,
                ... pitchTable, "Time", "F0",
                ... tempLegend, 0.01
            selectObject: tempLegend
            Remove
            Save as 300-dpi PNG file:  imagePath$ + sound$ + ".png"

            # remove current for loop surplus objects
            selectObject: textgrid
            plusObject: soundobject
            plusObject: fixedPitch
            plusObject: tempPitch
            plusObject: pitchTable
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
endproc
