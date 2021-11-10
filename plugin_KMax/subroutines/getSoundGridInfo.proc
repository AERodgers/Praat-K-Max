# K-MAX SUBROUTINE: GET SOUND AND TEXTGRID INFO
# =============================================
# Written for Praat 6.0.40

# script by Antoin Eoin Rodgers
# rodgeran@tcd.ie
# Phonetics and speech Laboratory, Trinity College Dublin
# October 10 - December 18, 2019

procedure getSoundGridInfo
    # get list of wave files
    sound_list_temp1 = Create Strings as file list: "fileList",
        ... dir$ + "*" + suffix$
    # exit the script if directory contains no sound files
    numSounds = Get number of strings
    if numSounds = 0
        exitScript: "DIRECTORY CONTAINS NO 'suffix$' files." + newline$
    endif

    # get list of file names without suffix
    selectObject: sound_list_temp1
    sound_list_temp2 = Replace all: suffix$, "", 0, "literals"
    numSounds = Get number of strings
    sound_list$# = List all strings

    selectObject: sound_list_temp1
    plusObject: sound_list_temp2
    Remove

    # list sounds and indices in Info window for user convenience
    if not batch_process_directory

        appendInfoLine: newline$, newline$, "Index", tab$, "Sound"
        for i to numSounds
            appendInfoLine: i, tab$, sound_list$#[i]
        endfor
    endif
    appendInfoLine: newline$

    # get list of textgrids in target directory
    textgrid_list_temp1 = Create Strings as file list: "textgrids",
        ... dir$ + "*.TextGrid"
    Replace all: ".TextGrid", "", 0, "literals"
    textgrid_list_temp2 = selected ()
    Rename: "textgrids"
    textgrid_list$# = List all strings
     # NB: A string array will work better than a word list since it can cope
     # with file names which contain a space. The convenient query
     # "Has word", which is available for a word list, can simply be replace
     # with index$(string_array$#, target_name$). (2021.07.16)

    removeObject: textgrid_list_temp1
    removeObject: textgrid_list_temp2
    endproc
