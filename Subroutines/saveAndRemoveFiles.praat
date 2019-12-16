# MAX-K SUBROUTINE: SAVE FILES FOR CURRENT SOUND / TEXTGRID PAIRS
# ===============================================================
# Written for Praat 6.0.40

# script by Antoin Eoin Rodgers
# rodgeran@tcd.ie
# Phonetics and speech Laboratory, Trinity College Dublin

procedure saveAndRemoveFiles
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

    selectObject: idealise.pitchTable
    # convert ST back to Hz
    Formula (column range): "IdealF0", "SmoothedIdealF0",
        ... "if self = undefined then undefined else 2^(self/12)*100 endif"

tempRows = Get number of rows
undefIdeal = 0
undefSmooth = 0
for l to tempRows
    curIdeal = Get value: l, "IdealF0"
    undefIdeal += (curIdeal = undefined)
    curSmooth = Get value: l, "IdealF0"
    undefSmooth += (curIdeal = undefined)
endfor

    Save as text file: manipPath$ + sound$
        ... + "_all_F0.Table"
    Remove

    selectObject: idealise.pitch
    Save as text file: resynthPath$ + rsPrefix$ + sound$ + ".Pitch"
    Remove

    selectObject: textgrid
    if userInput
        Save as text file: dir$ + sound$ + ".TextGrid"
    endif

    #update report
    @updateReport
endproc
