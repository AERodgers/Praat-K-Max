# STH Analysis sub-routine: updateReport
# ====================================================================
# Written for Praat 6.0.40

# script by Antoin Eoin Rodgers
# rodgeran@tcd.ie
# Phonetics and speech Laboratory, Trinity College Dublin
# October 10 -  December 8,  2019

procedure updateReport
    selectObject: report
    Set string value: tableRow, "comments", comment$
    Set string value: tableRow, "smooth", string$(pre_smoothing)
        ... + " " + string$(coarse_smoothing) + " " + string$(fine_smoothing)
    Set string value: tableRow, "phonology", phonology$
endproc
