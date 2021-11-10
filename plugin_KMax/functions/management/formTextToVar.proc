procedure formTextToVar: .form_text$, .output_var$
    # converts the text of a praat form into its varible format
    #     .form_text$   = text as it appears in form
    #     .output_var$  = form text reformatted as Praat variable.
    #
    # Antoin Eoin Rodgers
    # rodgeran@tcd.ie
    # Phonetics and speech Laboratory, Trinity College Dublin

    # Get variable type and form text
    .space = index(.form_text$, " ")
    .type$ = left$(.form_text$, .space - 1)

    # remove type keyword from form text.
    .form_text$ = mid$(.form_text$, .space + 1, length(.form_text$))

    # remove all text not related to variable creation.
    .space = index(.form_text$, " ")
    .text$ = left$(.form_text$, .space -1)
    # convert form text variables to valid variable name
    '.output_var$' = replace_regex$ (.text$, "[A-Z]", "\L&", 1)
    '.output_var$' = replace_regex$('.output_var$', "[^A-Z^a-z^0-9^\.^_]", "_", 0)
    '.output_var$' = replace$('.output_var$', "^", "_", 0)

    # add string symbol ($) if variable type is a string.
    if .type$ == "word" or .type$ = "sentence" or .type$ = "text"
        '.output_var$' += "$"
    endif
endproc
