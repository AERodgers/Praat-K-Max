# EDIT TEXTGRID BATCH V.3.0
# =========================
# Written for Praat 6.0.40

# script by Antoin Eoin Rodgers
# rodgeran@tcd.ie
# Phonetics and speech Laboratory, Trinity College Dublin
# Jan 19, 2019

# This script opens every sound file with a matching textgrid in a
# directory.
#
# The user can choose which tier to hide in the text grid to avoid cluttering.
#
# The script contains two preliminary UIs:
#     1. Choose Directory form:
#            - the directory with textgrid and sound files (with or without
#              final "/" or "\")
#            - sound file suffix (with or with out ".")
#            - directory of resynthesised waveform (if any)
#            - prefix for resynthesised waveforms (if any)
#
#        NOTE: Textgrids and sounds files (wav) must be in the same directory.
#
#     2. Show/Hide Tiers:
#            - Tick the tiers you want to display while editing
#            - It is not possible to hide all tiers
#
# There is one UI during the main loop with the following options:
#     1. [Exit]  Exit script
#     2. [ <  ]  Go to previous textgrid or the sound file index in "jump to..."
#     3. [  > ]  Go to next textgrid or the sound index file in "jump to..."
#     4. [Save]  Save the current textgrid
#
# Failsafes / Error Handling
#     1. a backup directory is created which contains:
#            - a copy of each text grid which appears in the editor window
#              (before editing)
#            - a report listing all texgrids changed
#     2. The script cannot cope with tier names beginning with a number or
#        which contain characters that break variable name conventions (with
#        the exception of initial capitals)

# UI FORM
form Text grid editor: Choose Directory
    sentence Directory example
    word Sound_file_extension .wav
endform
@versionCheck
@updateFormLiterals("main_editTextgrids.praat")

# Correct/shorten form errors.
dir$ = directory$
ext$ = sound_file_extension$
if left$(ext$, 1) != "."
    ext$ = "." + ext$
endif
if (right$(dir$, 1) != "/" or right$(dir$, 1) != "\") and right$(dir$, 1) != ""
    dir$ += "/"
endif

# SHOW/HIDE TIERS FORM
@tierIDs: dir$
tiersToShow = 0
while tiersToShow = 0
    # Show/Hide tiers UI
    beginPause: "Show/Hide Tiers"
    comment: "Check the tiers you want to view while editing"
    for i to tierIDs.n
        curBoolean$ = replace_regex$(tierIDs.name$[i], ".", "\l&", 1) + " tier"
        boolean: curBoolean$, 0
    endfor
    show_hide_choice = endPause: "Exit", "Continue", 2, 0
    if show_hide_choice = 1
        exit
    endif

    # Check user has selected at least one tier
    for i to tierIDs.n
        curBoolean$ = replace_regex$ (tierIDs.name$[i], ".", "\l&", 1) + "_tier"
        tiersToShow += 'curBoolean$'
    endfor
endwhile

# Process show/hide tiers form.
hide_tiers$ = ""
for i to tierIDs.n
    curBoolean$ = replace_regex$(tierIDs.name$[i], ".", "\L&", 1) + "_tier"
    if not 'curBoolean$'
        hide_tiers$ += tierIDs.name$[i] + " "
    endif
endfor
if right$(hide_tiers$, 1) = " "
    hide_tiers$ = left$(hide_tiers$, length(hide_tiers$) - 1)
endif

# GENERATE SOUND FILE LIST
sound_list_temp = Create Strings as file list: "sounds", dir$ + "*"
    ... + ext$
sound_list = Replace all: ext$, "", 0, "literals"
num_wavs = Get number of strings
selectObject: sound_list_temp
Remove

# Exit script if directory contains no sound files.
if not num_wavs
    exitScript: "No sounds found:" + newline$ + "Directory: " +
    ... replace$(dir$, "\", "/", 0) + newline$ +"Extension: " + ext$ + newline$
endif

# GENERATE TEXTGRID LIST
grid_list_temp_1 = Create Strings as file list: "textgrids",
... dir$ + "*.textgrid"
grid_list_temp_2 = Replace all: ".TextGrid", "", 0, "literals"
Rename: "textgrids"
grid_list = To WordList
selectObject: grid_list_temp_1
plusObject: grid_list_temp_2
Remove

# CREATE BACKUP DIRECTORY
backup_path$ = dir$ + "backup/"
createDirectory: backup_path$

# MAIN EDITING ROUTINE
edit_choice = 0
grid_saved# = zero# (num_wavs)
i = 0
while i < num_wavs
    i += 1
    i_adjust = 0
    selectObject: sound_list
    cur_wav$ = Get string: i

    #edit textgrid if it exists
    selectObject: grid_list
    grid_exists = Has word: cur_wav$
    if grid_exists
        # read in sound and textgrid
        cur_wav = Read from file: dir$ + cur_wav$ + ext$
        Scale intensity: 70
        cur_grid = Read from file: dir$ + cur_wav$ + ".TextGrid"
        Save as text file: backup_path$ + cur_wav$ + ".TextGrid"
        @removeDuplicateTiers: cur_grid

        # remove tiers for temporary textgrid, if any have been specified.
        if length(hide_tiers$) != 0
            @temp_textgrid: "cur_grid", hide_tiers$
            selectObject: temp_textgrid.object
            plusObject: cur_wav
        else
            selectObject: cur_grid
            plusObject: cur_wav
        endif
        Edit

        # pause to let user edit the text grid.
        pauseText$ = "Editing " + cur_wav$
        beginPause: pauseText$
            comment: string$(i) + "/" + string$(num_wavs) + ": " + cur_wav$
            natural: "Jump to", i + 1
        edit_choice = endPause: "Exit", "<", ">", "Save", 4, 0

        # Save merged textgrid if any have been specified.
        if length(hide_tiers$) != 0
            @merge_textgrids
        endif
        if edit_choice = 4
            selectObject: cur_grid
            Save as text file: dir$ + cur_wav$ + ".TextGrid"
            grid_saved#[i] = 1
            i_adjust = -1
        elsif edit_choice = 3
            i_adjust = jump_to - 1 - i
        elsif edit_choice = 2
            i_adjust = -2
            if (jump_to != i + 1)
                i_adjust = jump_to - 1 - i
            endif
        endif

        # Delete current backup if no changes have been made to file.
        if edit_choice != 4 and not(grid_saved#[i])
            deleteFile: backup_path$ + cur_wav$ + ".TextGrid"
        endif

        # Adjust i.
        i += i_adjust
        if i > num_wavs
            i = num_wavs - 1
        elsif i < 0
            i = 0
        endif

        # remove current sound object and textgrid
        selectObject: cur_grid
        plusObject: cur_wav
        Remove

        # Check for exit script
        i += i * 10e10 * (edit_choice = 1)

    endif
endwhile

# remove remaining objects
selectObject: sound_list
plusObject: grid_list
Remove

# PROCEDURES
procedure tierIDs: .dir$
    # Get all tier names in directory

    .n = 0
    # Get list of textgrids
    .grid_list = Create Strings as file list: "fileList", .dir$ + "*.TextGrid"
    .numberOfGrids =  Get number of strings
    # exit if no text grids
    if .numberOfGrids = 0
        removeObject: .grid_list
        exitScript: "Directory contains no TextGrid files." + newline$
    endif
    # Get names of all textgrid tiers in directory
    for .i to .numberOfGrids
        selectObject: .grid_list
        .gridName$ = Get string: .i
        .cur_grid = Read from file: .dir$ + .gridName$
        .num_tiers = Get number of tiers
        if .n = 0
            .name$[1] = Get tier name: 1
            .n = 1
        endif
        for j to .num_tiers
            .cur_tier$ = Get tier name: j
            .nameAlreadyExists = 0
            for .k to .n
                .nameAlreadyExists += (.cur_tier$ = .name$[.k])
            endfor
            if not .nameAlreadyExists
                .n += 1
                .name$[.n] = .cur_tier$
            endif
        endfor
        Remove
    endfor
    selectObject: .grid_list
    Remove
endproc

procedure temp_textgrid: .original$, .delete_list$
    # convert .delete_list$ to array of tiers to be deleted:
    # (.delete$[.n] with .n elements)
    .list_length = length(.delete_list$)
    .n = 1
    .prev_start = 1
    for .i to .list_length
        .char$ = mid$(.delete_list$, .i, 1)
        if .char$ = " "
            .delete$[.n] = mid$(.delete_list$, .prev_start, .i - .prev_start)
            .n += 1
            .prev_start = .i + 1
        endif

        if .n = 1
            .delete$[.n] = .delete_list$
        else
            .delete$[.n] =
            ... mid$(.delete_list$, .prev_start, .list_length - .prev_start + 1)
        endif
    endfor

    # create a copy of '.original$' and delete target tiers
    selectObject: '.original$'
    .num_tiers = Get number of tiers
    .name$ = selected$("TextGrid")
    .name$ += "_temp"
    Copy: .name$
    .object = selected ()
    for .i to .num_tiers
        .cur_tier = .num_tiers + 1 - .i
        .name_cur$ = Get tier name: .cur_tier
        for .j to .n
            if .delete$[.j] = .name_cur$
                Remove tier: .cur_tier
            endif
        endfor
    endfor
endproc

procedure merge_textgrids
    # Get number of and list of original and temporary tiers.
    selectObject: temp_textgrid.object
    .temp_n_tiers = Get number of tiers
    for .i to .temp_n_tiers
        .temp_tier$[.i] = Get tier name: .i
    endfor
    selectObject: 'temp_textgrid.original$'
    .orig_n_tiers = Get number of tiers
    .name$ = selected$("TextGrid")
    for .i to .orig_n_tiers
        .orig_tier$[.i] = Get tier name: .i
    endfor

    # create 1st tier of merged tier
    selectObject: 'temp_textgrid.original$'
    Extract one tier: 1
    .new = selected()
    if .orig_tier$[1] = .temp_tier$[1]
        selectObject: temp_textgrid.object
        Extract one tier: 1
        .temp_single_tier = selected ()
        plusObject: .new
        Merge
        .newNew =selected()
        Remove tier: 1
        selectObject: .temp_single_tier
        plusObject: .new
        Remove
        .new = .newNew
    endif

    # merge tiers 2 to .orig_n_tiers
    for .i from 2 to .orig_n_tiers
        .useTemp = 0
        for .j to .temp_n_tiers
            if .orig_tier$[.i] =  .temp_tier$[.j]
                .useTemp = .j
            endif
        endfor
        if .useTemp
            selectObject: temp_textgrid.object
            Extract one tier: .useTemp
        else
            selectObject: 'temp_textgrid.original$'
            Extract one tier: .i
        endif
        .temp_single_tier = selected ()
        plusObject: .new
        Merge
        .newNew =selected()
        selectObject: .temp_single_tier
        plusObject: .new
        Remove
        .new = .newNew
    endfor
    selectObject: 'temp_textgrid.original$'
    plusObject: temp_textgrid.object
    Remove
    'temp_textgrid.original$' = .new
    selectObject: 'temp_textgrid.original$'
    Rename: .name$
endproc

procedure removeDuplicateTiers: .textGrid
    selectObject: .textGrid
    .name$ = selected$()
    .num_tiers = Get number of tiers
    .prev_tier$ = Get tier name: .num_tiers
    for .i from 2 to .num_tiers
        .cur_tier = .num_tiers - .i + 1
        .cur_tier$ = Get tier name: .cur_tier
        if .cur_tier$ = .prev_tier$
            Remove tier: .cur_tier
        endif
    .prev_tier$ = .cur_tier$
    endfor
endproc

include functions/management/versionCheck.proc
include functions/management/updateFormLiterals.proc
include functions/management/formTextToVar.proc
