# MAX-K SUBROUTINE: GET SOUND AND TEXTGRID INFO
# =============================================
# Written for Praat 6.0.40

# script by Antoin Eoin Rodgers
# rodgeran@tcd.ie
# Phonetics and speech Laboratory, Trinity College Dublin
# October 10 -  December 8,  2019

procedure getSoundGridInfo
    # get list of wave files
    sound_list_temp = Create Strings as file list: "fileList",
        ... dir$ + "*" + suffix$
    # exit the script if directory contains no sound files
    numSounds = Get number of strings
    if numSounds = 0
        exitScript: "DIRECTORY CONTAINS NO 'suffix$' files." + newline$
    endif

    # get list of file names without suffix
    selectObject: sound_list_temp
    Replace all: suffix$, "", 0, "literals"
    Rename: "sounds"
    sound_list = selected ()
    numSounds = Get number of strings
    selectObject: sound_list_temp
    Remove

    # get list of textgrids in target file
    textgrid_file_list = Create Strings as file list: "textgrids",
        ... dir$ + "*.textgrid"
    textgrid_list_temp1 = selected ()
    Replace all: ".TextGrid", "", 0, "literals"
    textgrid_list_temp2 = selected ()
    Rename: "textgrids"
    noprogress To WordList
    textgrid_list = selected ()
    selectObject: textgrid_list_temp1
    plusObject: textgrid_list_temp2
    Remove
endproc
