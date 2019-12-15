# MAX-K SUBROUTINE: DRAW STUFF
# ============================
# Written for Praat 6.0.40

# script by Antoin Eoin Rodgers
# rodgeran@tcd.ie
# Phonetics and speech Laboratory, Trinity College Dublin
# October 10 -  December 8,  2019

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
    subPrt2$[2] = "tonal annotations"
    subPrt2$[3] = "curvature"
    subPrt2$[4] = "curvature and tonal annotations"

    subPrt1 = draw_f0_corrected * 2 + draw_resynth
    subPrt2 = draw_K * 2 + draw_tonal
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
    Select outer viewport: 0, 6.5, 0, 3.35
    Axes: c3pogram.minT, c3pogram.maxT,
        ... drawC3pogram.minF0,  drawC3pogram.maxF0
    if draw_f0_corrected
        Colour: fixedF0Col$
        @draw_table_line: 'curveEst$'.table, "Time", "F0", c3pogram.minT,
            ... c3pogram.maxT, 1
    endif
    Line width: 1
    if draw_K
        @drawK: 'curveEst$'.max,  'curveEst$'.table, 1, c3pogram.minT,
            ...  c3pogram.maxT, curveEst$, kCol$
    endif

    if draw_tonal and idealTableExists and userInput
        tempIdeal = Read from file: manipPath$ + sound$
            ... + "_ideal_TTs.Table"
        @drawTonal: tempIdeal, c3pogram.minT, c3pogram.maxT,
            ... drawC3pogram.minF0, drawC3pogram.maxF0, tonalCol$
        selectObject: tempIdeal
        Remove
    endif

    ### draw idealised pitch contour
    if pitchFileExists and userInput and draw_resynth
        .tempPitch = Read from file:
            ... resynthPath$ + sound$ + ".Pitch"
        @drawIdealization: .tempPitch, c3pogram.minT, c3pogram.maxT,
            ... drawC3pogram.minF0, drawC3pogram.maxF0, idealCol$
        selectObject: .tempPitch
        Remove
    endif

    Solid line
    Line width: 1
    Black
    Select outer viewport: 0, 6.5, 0, 4
endproc
