procedure fixEscapeChars: .my_string$
    # Replaces characters in a string with escape character codes where needed.
        # Replaces the characters "\*+?|{[()^$.# " with their escape character
        # codes in the variable named in '.my_string$'.
        #
        # This prevents regex functions interpreting the characters literally.
        #
        # Antoin Eoin Rodgers
        # rodgeran@tcd.ie
        # Phonetics and speech Laboratory, Trinity College Dublin

    '.my_string$' = replace_regex$(
              ... '.my_string$',
              ... "[\\\*\+\?\|\{\[\(\)\^\$\.]",
              ... "\\&", 0)
endproc
