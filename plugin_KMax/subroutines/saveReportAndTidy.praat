# K-MAX SUBROUTINE: CLEAR OBJECT WINDOW AND SAVE REPORT
# =====================================================
# Written for Praat 6.0.40

# script by Antoin Eoin Rodgers
# rodgeran@tcd.ie
# Phonetics and speech Laboratory, Trinity College Dublin

procedure saveReportAndTidy
    ### save report
    selectObject: report
    Sort rows: "count"
    .numRows = Get number of rows
    for .i to .numRows
        curCom$ = Get value: .i, "comments"
        if curCom$ = "?"
            Set string value: .i, "comments", ""
        endif
    Save as tab-separated file: reportPath$

    ### remove remaining objects
    selectObject: report
    plusObject: errorBeep
    Remove


    ### Task completion Info
    appendInfoLine: newline$, "Finished at: ", mid$(date$(), 12, 8)
endproc
