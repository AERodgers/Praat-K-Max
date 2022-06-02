# EDIT TEXTGRID BATCH V.3.1.1
# ===========================
# Written for Praat 6.0.40

# script by Antoin Eoin Rodgers
# rodgeran@tcd.ie
# Phonetics and speech Laboratory, Trinity College Dublin
# Jan 19, 2019

# This script opens every sound file with a matching textgrid in a drectory.
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
#     1. [ Exit ] Exit script
#     2. [  <   ] Go to previous textgrid or to index in "jump to..."
#     3. [ Undo ] Undo any changes created during the current pause.
#     4. [ Draw ] Draw C3PoGram of the current sound.
#     4. [ Save ] Save the current textgrid
#     5. [   >  ] Go to next textgrid or to index in "jump to..."
#     6. [Save >] Save the current textgrid and go to next textgrid or to index
#                 in "jump to..."
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
grid_list$# = List all strings
grid_list = To WordList
selectObject: grid_list_temp_1
plusObject: grid_list_temp_2
Remove

# CREATE BACKUP DIRECTORY
backup_path$ = dir$ + "backup/"
createDirectory: backup_path$

# CREATE INDICES IN INFO WINDOW
writeInfoLine: "Index of all target TextGrids"
appendInfoLine: "============================='newline$'"

for i to size(grid_list$#)
    appendInfoLine: i, tab$, grid_list$#[i]
endfor

# MAIN EDITING ROUTINE
edit_choice = 0
grid_saved# = zero# (num_wavs)
i = 0

# Menu Response Choices
.choice$[7] = "Save >"
.choice$[6] = ">"
.choice$[5] = "Save"
.choice$[4] = "Draw"
.choice$[3] = "Undo"
.choice$[2] = "<"
.choice$[1] = "Exit"

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
        edit_choice = endPause:
                    ... "Exit", "<", "Undo", "Draw", "Save", ">", "Save >", 5, 0

        # Save merged textgrid if any have been specified.
        if length(hide_tiers$) != 0
            @merge_textgrids
        endif

        # Process Edit Choices
        if .choice$[edit_choice] = "Save >"
            selectObject: cur_grid
            Save as text file: dir$ + cur_wav$ + ".TextGrid"
            grid_saved#[i] = 1
            i_adjust = jump_to - 1 - i
        elsif .choice$[edit_choice] = ">"
            i_adjust = jump_to - 1 - i
        elsif .choice$[edit_choice] = "Save"
            selectObject: cur_grid
            Save as text file: dir$ + cur_wav$ + ".TextGrid"
            grid_saved#[i] = 1
            i_adjust = -1
        elsif .choice$[edit_choice] = "Draw"
            selectObject: cur_wav
            temp_name$ = selected$("Sound")
            To Pitch (ac): 0, 55, 15, "no", 0.03, 0.45, 0.01, 0.35, 0.14, 550
            f0_min = Get minimum: 0, 0, "Hertz", "parabolic"
            f0_max = Get maximum: 0, 0, "Hertz", "parabolic"
            Remove
            @c3pogram: 1, 2, 1,
            ... "%f_0 CPP contour of " + replace$(temp_name$, "_", "\_ ", 0),
            ... cur_grid, cur_wav, 2,
            ... f0_min / 1.1, f0_max * 1.1, 30, 90, 8
            i_adjust = -1
        elsif .choice$[edit_choice] = "Undo"
            i_adjust = -1
        elsif .choice$[edit_choice] = "<"
            i_adjust = -2
            if (jump_to != i + 1)
                i_adjust = jump_to - 1 - i
            endif
        endif

        # Delete current backup if no changes have been made to file.
        if not(grid_saved#[i])
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


### C3POGRAM
# C3POGRAM FUNCTIONS
procedure c3pogram: .param2, .hz_ST, .paintSpect, .title$, .grid, .sound,
    ...  .tier, .minF0, .maxF0, .mindB, .maxdB, .vpWidth

    # adjust sound intensity
    selectObject: .sound
    Scale intensity: 70

    if .grid * .tier > 0
        selectObject: .grid
        .refTier = Extract one tier: .tier
        .gridTable = Down to Table: "no", 3, "no", "no"
        .num_rows = Get number of rows
        .minT = Get value: 1, "tmin"
        .maxT = Get value: .num_rows, "tmax"
        Remove
    else
        selectObject: .sound
        .minT = Get start time
        .maxT = Get end time
    endif

    # reset draw space
    Erase all
    Black
    10
    Solid line
    Courier
    Select outer viewport: 0, .vpWidth, 0, 3.35

    # draw spectrogram
    if .paintSpect
        selectObject: .sound
        specky = To Spectrogram: 0.005, 5000, 0.002, 20, "Gaussian"
        Paint: .minT, .maxT, 0, 0, 100, "yes", 50, .vpWidth, 0, "no"
        Marks right every: 1, 200, "no", "yes", "no"
        Line width: 2
        Marks right every: 1000, 1, "yes", "yes", "no"
        Text right: "yes", "Spectral Frequency (kHz)"
        Remove
    endif
    Line width: 1
    Draw inner box

    if .grid * .tier > 0
        # draw text grid text and lines
        Select outer viewport: 0, .vpWidth, 0, 4
        selectObject: .refTier
        Draw: .minT, .maxT, "no", "yes", "no"
        Line width: 1
        Draw inner box
    endif

    # Adjust time to start from 0
    Axes: 0, .maxT-.minT, 1, 0

    # Draw time axis
    Marks bottom every: 1, 0.2, "yes", "yes", "no"
    Line width: 1
    Marks bottom every: 1, 0.1, "no", "yes", "no"
    Text bottom: "yes", "Time (secs)"

    # get pitch table
    @pitch: .sound, .minF0, .maxF0
    @pitch2Table: pitch.obj, 0
    selectObject: pitch2Table.table
    Rename: "pitch"

    # get second VQ table
    .secondParam$[1] = "cpp"
    .secondParam$[2] = "intensity"
    .secondParam$[3] = "h1h2"
    .secondParam$[4] = "harmonicity"
    .name$ = .secondParam$[.param2]
    if .param2 = 1
        @cpp: .sound, .minF0, .maxF0, pitch2Table.table
    elsif .param2 = 2
        @intensity: .sound, .minF0, .minT, .maxT
    elsif .param2 = 3
        @h1h2: .sound, pitch2Table.table
        selectObject: h1h2.table
        Formula: "value", "-self"
    else
        @harmonicity: .sound, .minF0
    endif
    .vqTable = '.name$'.table


    # draw cp3ogram
    #intensity hack
    if .hz_ST != 3
        @drawC3Pogram: pitch2Table.table, .vqTable, .minT, .maxT, .minF0,
        ... .maxF0, .param2, .hz_ST, .vpWidth
    else
        @drawIntensity: .sound, .minT, .maxT, .minF0, .mindB, .maxdB, .vpWidth
    endif

    # add pitch axis information
    Select outer viewport: 0, .vpWidth, 0, 3.35
    if .hz_ST = 2
        .leftMajor = 5
        .leftText$ = "F0 (ST re 1 Hz)"
    else
        .leftMajor = 50
        .leftText$ = "F0 (Hz)"
    endif
    if .hz_ST < 3
        Line width: 2
        Marks left every: 1, .leftMajor, "yes", "yes", "no"
        Line width: 1
        Marks left every: 1, .leftMajor / 5, "no", "yes", "no"
        Text left: "yes", .leftText$
    else
        Line width: 2
        Marks left every: 1, 10, "yes", "yes", "no"
        Line width: 1
        Marks left every: 1, 2, "no", "yes", "no"
        Text left: "yes", "Intensity (dB)"
    endif

    # add title
    if .grid * .tier > 0
        Select outer viewport: 0, .vpWidth, 0, 4
    else
        Select outer viewport: 0, .vpWidth, 0, 3.35
    endif

    Font size: 14
    nowarn Text top: "yes", "##" + .title$
    Font size: 10

    selectObject: .vqTable
    plusObject: pitch2Table.table
    plusObject: pitch.obj
    if .grid * .tier > 0
        plusObject: .refTier
    endif
    Remove
endproc

procedure drawC3Pogram: .pitchTable, .secondParam, .minT, .maxT, .minF0,
    ... .maxF0, .type, .hz_ST, .vpWidth
    selectObject: .pitchTable
    # adjust F0 if pitch scale set to semitones
    if .hz_ST = 2
        Formula: "F0", "log2(self)*12"
        .minF0 = log2(.minF0) * 12
        .maxF0 = log2(.maxF0) * 12
    endif

    # Convert second parameter to shading values
    selectObject: .secondParam
    .minPar2  = Get minimum: "value"
    .maxPar2 = Get maximum: "value"
    Append column: "shade"
    Formula: "shade", "1 - (self[""value""] - .minPar2) / (.maxPar2 - .minPar2)"

    # set picture window
    Select outer viewport: 0, .vpWidth, 0, 3.35
    Axes: .minT, .maxT, .minF0, .maxF0
    .di = Horizontal mm to world coordinates: 0.9
    Font size: 10
    Courier
    Solid line

    # Draw C3POGRAM points
    selectObject: .pitchTable
    .numPitchPts = Get number of rows
    Colour: "Black"
    for .i to .numPitchPts
        selectObject: .pitchTable
        .curT = Get value: .i, "Time"
        .curF0 = Get value: .i, "F0"
        @nearestVal: .curT, .secondParam, "time"
        .sh = Get value: nearestVal.index, "shade"
        .shT = Get value: nearestVal.index, "time"
        if not(abs(.shT - .curT)*1000 > 5.5555)
            Paint circle: "{'.sh','.sh',1-0.8*'.sh'}", .curT, .curF0,
            ... .di * 0.1 + .di * (1 - .sh)
            Colour: "blue"
            Line width: 0.5
            Draw circle: .curT, .curF0, .di * 0.1 + .di * (1 - .sh)
        else
            Paint circle: "{1,0,0}", .curT, .curF0, .di * 0.1
            Line width: 0.5
        endif
        Line width: 1
        Colour: "Black"
    endfor
endproc

procedure drawIntensity: .sound, .minT, .maxT, .minF0, .mindB, .maxdB, .vpWidth
    selectObject: .sound
    .intensity = To Intensity: .minF0, 0, "yes"

    # set picture window
    Select outer viewport: 0, .vpWidth, 0, 3.35
    Axes: .minT, .maxT, .mindB, .maxdB

    Font size: 10
    Courier
    Solid line
    Line width: 7
    Black
    Draw: .minT, .maxT, .mindB, .maxdB, "no"
    Line width: 4
    Green
    Draw: .minT, .maxT, .mindB, .maxdB, "no"
    Line width: 1

    removeObject: .intensity
endproc

# PARAMETER EXTRACTION FUNCTIONS
procedure pitch: .sound, .minF0, .maxF0
    selectObject: .sound
    .obj = To Pitch (ac):
    ... 0, .minF0, 15, "no", 0.03, 0.45, 0.01, 0.35, 0.14, .maxF0
endproc

procedure h1h2: .sound, .pitchTable
    # Procedure dependencies @getHn

    # PROCESS SOUND WAVEFORM
    # Get sampling data from sound object
    selectObject: .sound
    .sampHz = Get sampling frequency
    .coeffs = round (.sampHz/1000) + 2
    # create spectrogram of original sound (delete later)
    .soundSpectro = To Spectrogram: 0.03, 5000, 0.002, 20, "Gaussian"
    # get LPC, IF sound waveform, and IF waveform narrowband spectrogram
    selectObject: .sound
    .lpc = To LPC (autocorrelation): .coeffs, 0.025, 0.005, 50
    plusObject: .sound
    .if = Filter (inverse)
    .ifSpectro = To Spectrogram: 0.03, 5000, 0.002, 20, "Gaussian"

    # PROCESS PITCH TABLE
    # convert pitch to pitch table if necessary
    selectObject: .pitchTable
    .isPitchObj = index(selected$(), "Pitch")
    if .isPitchObj
        .pitchTier = Down to PitchTier
        .pitchToR = Down to TableOfReal: "Hertz"
        .pitchTable = To Table: "rowLabel"
        selectObject: .pitchTier
        plusObject: .pitchToR
        Remove
        selectObject: .pitchTable
        Remove column: "rowLabel"
    endif
    Remove column: "Frame"
    .table = Copy: "H1H2"
    .numRows = Get number of rows
    Set column label (index): 1, "time"
    Append column: "value"
    # get array of F0 and time points
    for .i to .numRows
        .f0[.i] = Get value: .i, "F0"
        .time[.i] = Get value: .i, "time"
    endfor
    Remove column: "F0"

    # PROCESS H1-H2
    # get h1-h2 array
    for .i to .numRows
        @getHn: .ifSpectro, 1, .time[.i], .f0[.i]
        .h1 = getHn.db
        @getHn: .ifSpectro, 2, .time[.i], .f0[.i]
        .h1h2$ = fixed$(.h1 - getHn.db, 3)
        selectObject: .table
        Set string value: .i, "value", .h1h2$
    endfor

    .mean = Get mean: "value"
    .stDev = Get standard deviation: "value"

    # remove statistical outliers
    @delRowsIf: .table, "self[""value""] < h1h2.mean - h1h2.stDev * 3"
    @delRowsIf: .table, "self[""value""] > h1h2.mean + h1h2.stDev * 3"

    ### Remove surplus objects:
    selectObject: .soundSpectro
    plusObject: .lpc
    plusObject: .if
    plusObject: .ifSpectro
    if .isPitchObj
        plusObject: .pitchTable
    endif
    Remove
endproc

procedure getHn: .ifSpectro, .hn, .time, .f0
    selectObject: .ifSpectro
    .slice = To Spectrum (slice): .time
    .db = Get sound pressure level of nearest maximum: .f0 * .hn
    Remove
endproc

procedure harmonicity: .sound, .minF0
    # Procedure dependencies: @array2table (@list2array), @delRowsIf

    # create harmonicity object
    selectObject: .sound
    .harmonicity = To Harmonicity (ac): 0.01, .minF0, 0.1, 4.5
    #get main stats for harmonicity table
    .mean =Get mean: 0, 0
    .stDev = Get standard deviation: 0, 0
    .frames = Get number of frames

    # create array of harmonicity values
    for .i to .frames
       time[.i] = Get time from frame number: .i
       value[.i] = Get value in frame: .i
    endfor
    #  create harmonicity table
    @array2table: "harmonicity", "time value", .frames
    .table = array2table.table
    .minimum = Get minimum: "value"
    @delRowsIf: .table, "self[""value""] = harmonicity.minimum"
    @delRowsIf: .table, "self[""value""] < harmonicity.mean - harmonicity.stDev * 1"
    selectObject: .harmonicity
    Remove
endproc

procedure intensity: .sound, .minF0, .minT, .maxT
    # Procedure dependencies: @delRowsIf, @tableStats (@keepCols, @table2array)

    # create harmonicity object
    selectObject: .sound
    .tempI1 = To Intensity: 75, 0, "yes"
    .tempI2 = Down to IntensityTier
    .tempI3 = Down to TableOfReal
    .tempI4 = To Table: "delete"
    Remove column: "delete"
    Set column label (index): 1, "time"
    Set column label (index): 2, "value"
    selectObject: .tempI1
    plusObject: .tempI2
    plusObject: .tempI3
    Remove

    .table = .tempI4
    selectObject: .table
    .mean = Get mean: "value"
    .stDev = Get standard deviation: "value"
    @delRowsIf: .table, "self[""value""] < intensity.mean - intensity.stDev"


    # get linear regression of intensity for utterance portion of waveform
    .tempTable = Copy: "intensityTemp"
    @delRowsIf: .tempTable, "self[""time""] <= intensity.minT"
    @delRowsIf: .tempTable, "self[""time""] >= intensity.maxT"
    @tableStats: .tempTable, "time", "value"

    selectObject: .tempTable
    @delRowsIf: .table, "self [""value""] < tableStats.yMean - tableStats.stDevY"
    .mean = Get mean: "value"
    .stDev = Get standard deviation: "value"
    selectObject: .tempTable
    Remove

    selectObject: .table
    Formula: "value", "self[""value""] - (self[""time""] * tableStats.slope + tableStats.intercept)"
endproc

procedure cpp: .sound, .minF0, .maxF0, .pitchTable
    # Procedure dependencies:  @delRowsIf
    selectObject: .sound
    .powerCepstrogram = To PowerCepstrogram: .minF0, 0.002, 5000, 50

    selectObject: .pitchTable
    .table = Copy: "CPP"
    .numRows = Get number of rows
    Set column label (index): 2, "time"

    for .i to .numRows
        .time[.i] = Get value: .i, "time"
        .f0[.i] = Get value: .i, "F0"
    endfor

    for .i to .numRows
        selectObject: .powerCepstrogram
        .powerCepstralSlice = To PowerCepstrum (slice): .time[.i]
        .cpp[.i] = Get peak prominence: .minF0, .maxF0, "Parabolic", 0.001, 0, "Straight", "Robust"
        Remove
    endfor

    selectObject: .table
    Append column: "value"
    for .i to .numRows
        Set numeric value: .i, "value", .cpp[.i]
    endfor
    .mean = Get mean: "value"
    .stDev = Get standard deviation: "value"
    @delRowsIf: .table, "self [""value""] < cpp.mean - cpp.stDev * 2"

    selectObject: .powerCepstrogram
    Remove
endproc

# OBJECT MANAGEMENT FUNCTIONS
procedure array2table: .table$, .arrays$, .rows
    # Procedure dependencies: @list2array

    # convert array list to indexed string list
    @list2array: .arrays$, "list2array.arrayList$"

    # simplify array/column names
    .cols = list2array.n
    for .j to .cols
        .cols$[.j] = list2array.arrayList$[.j]
        if right$(.cols$[.j], 1) = "$"
            .string[.j] = 1
        else
            .string[.j] = 0
    endfor

    # create empty table
    .table = Create Table with column names: .table$, .rows, .arrays$

    # populate table
    for .i to .rows
        for .j to .cols
            .curCol$ =  .cols$[.j]
            if .string[.j]
                Set string value: .i, .curCol$, '.curCol$'[.i]
            else
                Set numeric value: .i, .curCol$, '.curCol$'[.i]
            endif
        endfor
    endfor
endproc

procedure table2array: .table, .col$, .array$
    # Procedure dependencies: none

    .string = right$(.array$, 1) = "$"
    selectObject: .table
    .n = Get number of rows
    for .i to .n
        if .string
            .cur_val$ = Get value: .i, .col$
            '.array$'[.i] = .cur_val$
        else
            .cur_val = Get value: .i, .col$
            '.array$'[.i] = .cur_val
        endif
    endfor
endproc

procedure list2array: .list$, .array$
    # Procedure dependencies: none

    .list_len = length(.list$)
    .n = 1
    .prev_start = 1
    for .i to .list_len
        .char$ = mid$(.list$, .i, 1)
        if .char$ = " "
            '.array$'[.n] = mid$(.list$, .prev_start, .i - .prev_start)
            .origIndex[.n] = .prev_start
            .n += 1
            .prev_start = .i + 1
        endif
    endfor
    if .n = 1
        '.array$'[.n] = .list$
    else
        '.array$'[.n] = mid$(.list$, .prev_start, .list_len - .prev_start + 1)
    endif
    .origIndex[.n] = .prev_start
endproc

procedure pitch2Table: .pitchObject, .interpolate
    # Procedure dependencies: none
    selectObject: .pitchObject
    .originalObject = .pitchObject
    if .interpolate
        .pitchObject = Interpolate
    endif

    # Get key pitch data
    .frameTimeFirst = Get time from frame number: 1
    .timeStep = Get time step

    #create pitch Table (remove temp objects)
    .pitchTier = Down to PitchTier
    .tableofReal = Down to TableOfReal: "Hertz"
    .pitchTable = To Table: "rowLabel"
    selectObject: .pitchTier
    plusObject: .tableofReal
    Remove

    # Get key pitchTable data
    selectObject: .pitchTable
    .rows = Get number of rows
    .rowTimeFirst = Get value: 1, "Time"

    # estimate frame of first row
    Set column label (index): 1, "Frame"
    for .n to .rows
        .rowTimeN = Get value: .n, "Time"
        .tableFrameN = round((.rowTimeN - .frameTimeFirst) / .timeStep + 1)
        Set numeric value: .n, "Frame", .tableFrameN
    endfor

    #removeInterpolated pitch
    if  .originalObject != .pitchObject
        selectObject: .pitchObject
        Remove
    endif
    .table = .pitchTable
endproc

procedure nearestVal: .input_val, .input_table, .input_col$
    # Procedure dependencies: none

    .diff = 1e+100
    selectObject: .input_table
    .num_rows = Get number of rows
    for .i to .num_rows
        .val_cur = Get value: .i, .input_col$
        .diff_cur = abs(.input_val - .val_cur)
        if .diff_cur < .diff
            .diff = .diff_cur
            .val = .val_cur
            .index = .i
        endif
    endfor
endproc

procedure delRowsIf: .table, .cond$
    # Procedure dependencies: none

    selectObject: .table
    .num_rows = Get number of rows
    Append column: "del"
    Formula: "del", "if " +.cond$ + " then 1 else 0 endif"
    for .i to .num_rows
        .cur_row = .num_rows + 1 - .i
        .cur_value = Get value: .cur_row, "del"
        if .cur_value
            Remove row: .cur_row
        endif
    endfor
    Remove column: "del"
endproc

procedure keepCols: .table, .keep_cols$, .new_table$
    # Procedure dependencies: @list2array
    @list2array: .keep_cols$, ".keep$"
    selectObject: .table
    '.new_table$' = Copy: .new_table$
    .num_cols = Get number of columns
    for .i to .num_cols
        .col_cur = .num_cols + 1 - .i
        .label_cur$ = Get column label: .col_cur
        .keep_me = 0
        for .j to list2array.n
            if .label_cur$ = list2array.keep$[.j]
                .keep_me = 1
            endif
        endfor
        if .keep_me = 0
            Remove column: .label_cur$
        endif
    endfor
endproc

procedure tableStats: .table, .colX$, .colY$
    # Procedure dependencies: @keepCols, @table2array

    @keepCols: .table, "'.colX$' '.colY$'", "tableStats.shortTable"

    .numRows = Get number of rows
    .factor$ = Get column label: 1
    if .colX$ != .factor$
        @table2array: .shortTable, .colY$, "tableStats.colTemp$"
        Remove column: .colY$
        Append column: .colY$
        for .i to table2array.n
            Set string value: .i, .colY$, .colTemp$[.i]
        endfor
    endif

    if .numRows > 1
        .stDevY = Get standard deviation: .colY$
        .stDevY = number(fixed$(.stDevY, 3))
        .stDevX = Get standard deviation: .colX$
        .linear_regression = To linear regression
        .linear_regression$ = Info
        .slope = extractNumber (.linear_regression$, "Coefficient of factor '.colX$': ")
        .slope = number(fixed$(.slope, 3))
        .intercept = extractNumber (.linear_regression$, "Intercept: ")
        .intercept = number(fixed$(.intercept, 3))
        .r = number(fixed$(.slope * .stDevX / .stDevY, 3))
        selectObject: .linear_regression
        .info$ = Info
        Remove
    else
        .stDevY = undefined
        .stDevX = undefined
        .linear_regression = undefined
        .linear_regression$ = "N/A"
        .slope = undefined
        .intercept = Get value: 1, .colY$
        .r = undefined
        .info$ = "N/A"
    endif

    selectObject: .shortTable
    .xMean = Get mean: .colX$
    .xMed = Get quantile: .colX$, 0.5
    .yMean = Get mean: .colY$
    .yMed = Get quantile: .colY$, 0.5
    Remove
endproc

include Functions/management/versionCheck.proc
include Functions/management/updateFormLiterals.proc
include Functions/management/formTextToVar.proc
