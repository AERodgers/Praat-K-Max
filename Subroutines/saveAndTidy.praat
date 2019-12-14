# Tidy-up for K-max
# ===================
# Written for Praat 6.0.40

# script by Antoin Eoin Rodgers
# rodgeran@tcd.ie
# Phonetics and speech Laboratory, Trinity College Dublin

procedure saveAndTidy

    ### save report
    selectObject: report
    Save as tab-separated file: reportPath$

    ### remove remaining objects
    selectObject: sound_list
    plusObject: textgrid_list
    plusObject: report
    Remove

    ### Task completion Info
    appendInfoLine: "Finished at: ", mid$(date$(), 12, 8)

endproc
