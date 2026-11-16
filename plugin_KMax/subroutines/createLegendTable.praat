# K-MAX SUBROUTINE: CREATE LEGEND TABLE
# =====================================
# Written for Praat 6.0.40

# script by Antoin Eoin Rodgers
# rodgeran@tcd.ie
# Phonetics and speech Laboratory, Trinity College Dublin
# October 10 - December 18, 2019

procedure createLegendTable
    tempLegend = Create Table with column names: "legend", 1,
        ... "style colour text size"
    legendLines = 1
    Set string value: 1, "style", "Dot"
    Set string value: 1, "colour", "{0.2, 0.2, 1}"
    Set string value: 1, "text", "%f_0 (CPP)"
    Set numeric value: 1, "size", 0.75

    if draw_f0_corrected
        legendLines += 1
        Append row
        Set string value: legendLines, "style", "Line"
        Set string value: legendLines, "colour", fixedF0Col$
        Set string value: legendLines, "text", "corrected %f_0"
        Set numeric value: legendLines, "size", 2 * widthCoeff
    endif

    if draw_K
        legendLines += 1
        Append row
        Set string value: legendLines, "style", "Line"
        Set string value: legendLines, "colour", kCol$
        Set string value: legendLines, "text", "%f_0\""p(t)"
        Set numeric value: legendLines, "size", 1 * widthCoeff
    endif

    if draw_resynth
        legendLines += 1
        Append row
        Set string value: legendLines, "style", "Line"
        Set string value: legendLines, "colour", idealCol$
        Set string value: legendLines, "text", "%f_0 resynthesis"
        Set numeric value: legendLines, "size", 3 * widthCoeff
    endif

    if draw_tonal
        legendLines += 1
        Append row
        Set string value: legendLines, "style", "x"
        Set string value: legendLines, "colour", tonalCol$
        Set string value: legendLines, "text", "ideal targets"
        Set numeric value: legendLines, "size", 10
    endif

    Reflect rows
endproc
