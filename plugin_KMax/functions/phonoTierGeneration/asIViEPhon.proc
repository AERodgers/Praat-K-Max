procedure asIViEPhon: .int_phon$
    # Converts an intermediate phonological string form to IViE phonology.
        # .int_phon$ = string with intermediate phonological form of a single
        #              pitch accent or boundary event;
        # output: asIViEPhon.text$ = string in IViE format.
        #
        # Antoin Eoin Rodgers
        # rodgeran@tcd.ie
        # Phonetics and speech Laboratory, Trinity College Dublin

    # process boundary tones
    .text$ = .int_phon$

    # remove invalid text
    .text$ = replace_regex$(.text$, "[^lLhH_*0+]", "", 1)

    # fix complex boundaries (if any)
    .text$ = replace_regex$(.text$, "^[LH]_[LH]$", left$(.text$, 1) + right$(.text$, 1), 1)

    # replace double boundary; i.e., "HH" or "LL"
    # .text$ = replace_regex$(.text$, "^.{2}|H{2}$", left$(.text$, 1), 1)

    # fix simple boundaries
    .text$ = replace_regex$(.text$, "^[LH0]_0$", left$(.text$, 1), 1)
    .text$ = replace_regex$(.text$, "^[LH0]_0$", left$(.text$, 1), 1)
    .text$ = replace_regex$(.text$, "^0_[LH0]$", right$(.text$, 1), 1)

    # handle putative phonological rules
    # L_ motivated downstep
    .text$ = replace$(.text$, "L_H*", "!H*", 1)
    # Deleted L *
    .text$ = replace$(.text$, "l_H*", "H*", 1)
    .text$ = replace$(.text$, "l*+H", ">H*", 1)
    # Deleted H*
    .text$ = replace$(.text$, "L*+h", "L*", 1)
    # Residual L*H (PA deletion)
    .text$ = replace$(.text$, "l*+h", "*", 1)

    # remove other secondary tones from PAs
    .text$ = replace_regex$(.text$, "_[lhLH0]$", "", 1)
    .text$ = replace_regex$(.text$, "^[lhLH0]_", "", 1)
    .text$ = replace$(.text$, "0", "", 0)
    .text$ = replace$(.text$, "+", "", 0)
endproc
