procedure tableText2Char: .table, .text_col$, .valid_text$
    # Analyses the text in .text_col$ of .table and adds them to the table.
        # .table       = object ID of table
        # .text_col$ = text column name
        # .valid_text$  = list of valid characters. (Leave as "" if this
        #                does not apply.)
        #
        # The procedure will return the input table, which a duplicate of each
        # row where the text string is longer than one character. Each new
        # row will contain a single character from the original text string.
        #
        # This can facilitate the analyis of tiers rendered to table where
        # multiple characters may need to be processed.
        #
        # Antoin Eoin Rodgers
        # rodgeran@tcd.ie
        # Phonetics and speech Laboratory, Trinity College Dublin

    @fixEscapeChars: "tableText2Char.valid_text$"
    .regex_invalid$ = "[^" + .valid_text$ + "]"
    .warned = 1

    selectObject: .table
    .num_rows = Get number of rows
    .num_cols = Get number of columns
    for .i to .num_cols
        .col_name$[.i] = Get column label: .i
    endfor

    for .i to  .num_rows
        .cur_row = .num_rows + 1 - .i
        .cur_text$ = Get value: .cur_row, .text_col$
        if (length(.cur_text$) > 1)
            # Get values for each cell in current row.
            for .j to .num_cols
                .col_val$[.j] = Get value: .cur_row, .col_name$[.j]
            endfor
            Remove row: .cur_row
            for .j to length(.cur_text$)
                .cur_char$ = mid$(.cur_text$, length(.cur_text$) - .j + 1, 1)
                # check for invalid characters.
                if (.valid_text$ == "")
                    .containsInvalid = 0
                else
                    .containsInvalid = index_regex(.cur_char$, .regex_invalid$)
                endif
                if .containsInvalid
                    .name$ = selected$("Table")
                    appendInfoLine: "'.name$'", tab$,
                    ... "Ignoring ''.cur_char$'' in rhythm tier."
                else
                    # Create a duplicate of the original row for each char.
                    Insert row: .cur_row
                    for .k to .num_cols
                        Set string value: .cur_row, .col_name$[.k],
                                      ... .col_val$[.k]
                    endfor
                    # Replace the original string with the current character.
                    Set string value: .cur_row, .text_col$, .cur_char$
                endif
            endfor
        endif
    endfor
endproc
