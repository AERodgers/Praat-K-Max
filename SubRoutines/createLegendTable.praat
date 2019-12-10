# STH Analysis sub-routine: createLegendTable
# ====================================================================
# Written for Praat 6.0.40

# script by Antoin Eoin Rodgers
# rodgeran@tcd.ie
# Phonetics and speech Laboratory, Trinity College Dublin
# October 10 -  December 8,  2019

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
