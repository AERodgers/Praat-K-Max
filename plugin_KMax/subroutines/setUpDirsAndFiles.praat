# K-MAX SUBROUTINE: SET UP DIRECTORIES AND FILES
# ================================================
# Written for Praat 6.0.40

# script by Antoin Eoin Rodgers
# rodgeran@tcd.ie
# Phonetics and speech Laboratory, Trinity College Dublin
# October 10 - December 18, 2019


procedure setUpDirsAndFiles
    dir$ = directory$
    suffix$ = ".wav"

    # correct form errors
    if suffix$ != "" and left$(suffix$, 1) != "."
        suffix$ = "." + suffix$
    endif
    if right$(dir$, 1) != "/" or right$(dir$, 1) != "\"
        dir$ = dir$ + "/"
    endif

    # create directory paths
    backupPath$ = dir$ + backup_directory$ + "/"
    backupPath$ = replace$(backupPath$, "//", "/", 0)
    imagePath$ = dir$ + image_directory$ + "/"
    imagePath$  = replace$(imagePath$ , "//", "/", 0)
    manipPath$ = dir$ + manipulation_directory$ + "/"
    manipPath$  = replace$(manipPath$ , "//", "/", 0)
    outputPath$ = dir$ + output_directory$ + "/"
    outputPath$  = replace$(outputPath$ , "//", "/", 0)
    pitchPath$ = dir$ + pitch_directory$ + "/"
    pitchPath$  = replace$(pitchPath$ , "//", "/", 0)
    rsDir$ = dir$ + resynth_directory$ + "/"
    rsDir$  = replace$(rsDir$ , "//", "/", 0)

    # create directories (if they don't exist)
    createDirectory: dir$ + backup_directory$
    createDirectory: dir$ + image_directory$
    createDirectory: dir$ + manipulation_directory$
    createDirectory: dir$ + output_directory$
    createDirectory: dir$ + pitch_directory$
    createDirectory: dir$ + resynth_directory$

    # create report (if it doesn't exist)
    reportPath$ = outputPath$ + "K-Max_Analysis_Report.txt"
    if fileReadable: reportPath$
        report = Read from file: reportPath$
    else
        report = Create Table with column names:
            ... "K-Max_Analysis_Report", 0,
            ... "count sound tonalText comments " +
            ... "pre_smooth coarse_smooth"
    endif

endproc
