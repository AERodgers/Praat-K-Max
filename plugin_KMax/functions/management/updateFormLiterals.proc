procedure updateFormLiterals(.form_script_address$)
    # Metascript to update form menu script to reflect user variable choices.
        # .form_script_address$ = address of script with form in it.
        #
        # Antoin Eoin Rodgers
        # rodgeran@tcd.ie
        # Phonetics and speech Laboratory, Trinity College Dublin
    .form_script = Read Strings from raw text file: .form_script_address$
    .numLines = Get number of strings

    # find First line of form.
    .formStart = 0
    .curLine = 1
    while not .formStart
        .curLine$ = Get string: .curLine
        .formStart =  (left$(.curLine$, 5) == "form ") * .curLine
        if .curLine > .numLines
            .errorLine$ = "Error: Cannot find form in script." + newline$
            .errorLine$ += "Please contact rodgeran@tcd.ie" + newline$
            exitScript: .errorLine$
        endif
        .curLine += 1
    endwhile
    .formStart += 1

    # Find Last line of form.
    .formEnd = 0
    .curLine = .formStart + 1
    while not .formEnd
        .curLine$ = Get string: .curLine
        .formEnd =  (.curLine$ == "endform") * .curLine
        if .curLine > .numLines
            .errorLine$ = "Error: Form end not found in K-Max script."newline$
            .errorLine$ += "Please contact rodgeran@tcd.ie" + newline$
            exitScript: .errorLine$
        endif
        .curLine += 1
    endwhile
    .formEnd -= 1

    # Read and update Form section of script
    for .curLine from .formStart to .formEnd
        .curLine$ = Get string: .curLine

        # Trim leading white space.
        .spaces$ = ""
        while left$(.curLine$, 1) == " "
            .spaces$ += " "
            .curLine$ = mid$(.curLine$, 2, length(.curLine$))
        endwhile

        # Ignore non variable lines.
        if !(.curLine$ == "" or left$(.curLine$, 7) == "comment")
            # Get type and text of current line.
            @formTextToVar: .curLine$, "updateFormLiterals.curLineVar$"
            .curType$ = formTextToVar.type$
            .curText$ = formTextToVar.text$

            # Convert non-string literals to string.
            if right$(.curLineVar$, 1) == "$"
                .literal$ = '.curLineVar$'
            else
                .literal$ = string$('.curLineVar$')
            endif

            # Update the current script line to match most recent user input.
            Set string: .curLine,
                    ... .spaces$ + .curType$ + " " + .curText$ + " " + .literal$
            endif
        endif
    endfor

    # write updated script to script file.
    .scriptSize = Get number of strings
    curLine$ = Get string: 1
    writeFileLine: .form_script_address$, curLine$
    for .i from 2 to .scriptSize
        curLine$ = Get string: .i
        appendFileLine: .form_script_address$, curLine$
    endfor

    removeObject: .form_script
endproc
