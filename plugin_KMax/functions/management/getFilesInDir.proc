procedure getFilesInDir: .file_vector_name$, .dir$, .ext$
    # Creates a string vector of base TextGrid names in a specified directory.
        # .file_vector_name$ = string with name of ouput string vector;
        # .dir$              = target directory.
        # .ext$              = file extension
        #
        # Note: the vector will return the names of the TextGrid files without
        #       the .TextGrid extension.
        #
        # Antoin Eoin Rodgers
        # rodgeran@tcd.ie
        # Phonetics and speech Laboratory, Trinity College Dublin

    # Correct directory.
    if (not(right$(.dir$, 1) == "/" or right$(.dir$) == "\"))
        .dir$ += "/"
    endif
    # correct vector name
    if (right$(.file_vector_name$, 1) != "$#")
        .file_vector_name$ = replace$(.file_vector_name$, "#", "", 0)
        .file_vector_name$ = replace$(.file_vector_name$, "$", "", 0)
        .file_vector_name$ += "$#"
    endif
    # correct extension
    if (left$(.ext$, 1) != "." and .ext$ != "")
        .ext$ = "." + .ext$
    endif

    # get list of TextGrid files
    .file_list_temp_1 = Create Strings as file list: "fileList",
        ... .dir$ + "*" + .ext$
    # exit the script with warning if directory contains no TextGrid files.
    .numGrids = Get number of strings
    if .numGrids = 0
        exitScript: "DIRECTORY CONTAINS NO '.ext$' FILES." + newline$
    endif

    # get list of file names without suffix
    selectObject: .file_list_temp_1
    .file_list_temp2 = Replace all: .ext$, "", 0, "literals"
    .numGrids = Get number of strings
    '.file_vector_name$' = List all strings

    selectObject: .file_list_temp_1
    plusObject: .file_list_temp2
    Remove
endproc
