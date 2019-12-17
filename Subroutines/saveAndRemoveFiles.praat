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

    # fix idealTT table for readablility
    selectObject: idealise.table
    .numRows = Get number of rows
    Insert column: 2, "maxK_F0"
    Formula: "ideal_F0", "fixed$(self, 1)"
    Formula (column range): "maxK_T", "ideal_T", "fixed$(self, 3)"
    Formula (column range): "Slope", "Intercept", "fixed$(self, 2)"
    for .i to .numRows
        selectObject: idealise.table
        .curT = Get value: .i, "maxK_T"
        selectObject: tempPitch
        .curF0 = Get value at time: .curT, "Hertz", "Linear"
        selectObject: idealise.table
        Set string value: .i, "maxK_F0", fixed$(.curF0, 1)
    endfor
    selectObject: idealise.table

    Save as tab-separated file: outputPath$ + sound$
        ... + "_ideal_TTs.Table"
    Remove

    selectObject: idealise.pitchTable
    # convert ST back to Hz
    Formula (column range): "IdealF0", "SmoothedIdealF0",
        ... "if self = undefined then undefined else 2^(self/12)*100 endif"
    Remove column: "Frame"
    Save as tab-separated file: outputPath$ + sound$
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
