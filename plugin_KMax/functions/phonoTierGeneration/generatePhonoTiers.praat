procedure generatePhonoTiers: .dir$, .rhy_tier$, .tonal_tier$
    # Procedure to process TextGrid files based on Form inputs.
    #     .dir$ = target directory
    #     .rhy_tier$ = name of rhythm tier
    #     .tonal_tier$ = name of tonal tier
    #
    # Antoin Eoin Rodgers
    # rodgeran@tcd.ie
    # Phonetics and speech Laboratory, Trinity College Dublin

    createDirectory: .dir$ + "/backup"
    @getFilesInDir: "generatePhonoTiers.grids$#", .dir$, "TextGrid"
    forAERo = 0
    appendInfoLine: newline$, "Generate Intonational Phonology Tiers: Log"
    appendInfoLine: "============================================", newline$
    .phono_list$ = "#'tab$'sound file'tab$'intonation string"
    for .i to size(.grids$#)
        .cur_grid = Read from file: .dir$ + .grids$#[.i] + ".Textgrid"
        Save as binary file: .dir$ + "/backup/" + .grids$#[.i] + ".Textgrid"
        @findTier:  "generatePhonoTiers.rhy_tier", .cur_grid, .rhy_tier$, 0
        @findTier:  "generatePhonoTiers.tonal_tier", .cur_grid, .tonal_tier$, 0
        if .rhy_tier and .tonal_tier
            @addPhonTiers: .cur_grid, .rhy_tier, .tonal_tier
            if forAERo
                @placeTier: .cur_grid, .rhy_tier$, "syllable", 0
                @placeTier: .cur_grid, "minPhono", .rhy_tier$, 0
                @placeTier: .cur_grid, .tonal_tier$, "minPhono", 0
                @placeTier: .cur_grid, "maxK", .tonal_tier$, 0
                @placeTier: .cur_grid, "intPhono", "minPhono", 0
            endif

            @findTier: "generatePhonoTiers.m_phon_tier",.cur_grid, "minPhono", 0
            @getMinPhonoString: "generatePhonoTiers.phono$",
            ... .cur_grid,
            ... .m_phon_tier
            .phono_list$ +=
            ... newline$ + (string$(.i) + tab$ + .grids$#[.i] + tab$ + .phono$)

            selectObject: .cur_grid
            Save as binary file: .dir$ + .grids$#[.i] + ".Textgrid"
        else
            endif
            if not(.rhy_tier)
                appendInfoLine: .grids$#[.i], " has no rhythm tier called ",
                ... .rhy_tier$
            endif
            if not(.tonal_tier)
                appendInfoLine: .grids$#[.i], " has no tone tier called ",
                ... .tonal_tier$
            endif
        endif
        removeObject: .cur_grid
    endfor
    appendInfoLine: newline$, .phono_list$
    appendInfoLine: newline$, "============================================"
    appendInfoLine: "Finished"
endproc
