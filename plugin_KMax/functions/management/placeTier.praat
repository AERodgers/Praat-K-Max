procedure placeTier: .textgrid, .tierName$, .after$, .isInterval
    # Inserts or moves a named tier into a TextGrid.
        # Input variables:
        #     .textgrid    = textgrid ID
        #     .tierName$   = name of target tier to be inserted / moved
        #     .after$      = name of tier after which it will be placed.
        #                    Tier will be inserted as tier 1 if .after$ = ""
        #                    or .after$ is not a tier name.
        #     .isInterval  = tier type.
        #                    0 --> point tier
        #                    1 --> interval tier
        #
        # Output variable:
        #     placeTier.here = tier number of newly inserted tier.
        #
        # Details
        # 1. If the procedure does not find a tier called .tierName$, it will
        #    add a tier of the appropriate type after the tier named .after$.
        # 2. If the tier of an appropriate type already exists but is in the
        #    wrong position, it will move the tier to the correct position.
        # 3. It a tier of the same name but different type exists, it will be
        #    deleted and replaced with a tier of the appropriate type.
        # 4. The procedure will do nothing if there is already a tier of the
        #    appropriate type in the correct location.
        #
        # Antoin Eoin Rodgers
        # rodgeran@tcd.ie
        # Phonetics and speech Laboratory, Trinity College Dublin

    selectObject: .textgrid
    .numTiers = Get number of tiers
    .tierNum = 0
    .existsAsInt = -1
    .after = 0

    for .curTier to .numTiers
        .curIsInt = Is interval tier: .curTier
        .curTier$ = Get tier name: .curTier
        if .curTier$ = .tierName$
            .tierNum = .curTier
            .existsAsInt = .curIsInt
        elsif .curTier$ = .after$
            .after = .curTier
        endif
    endfor
    .here = .after + 1

    if (.tierNum and .isInterval != .existsAsInt)
        # remove wrong tier type
        Remove tier: .tierNum
        .numTiers -= 1
        .tierNum = 0
    elsif (.tierNum and .tierNum != (.here))
        # or move tier to correct place
        Duplicate tier: .tierNum, .here, .tierName$
        if .tierNum >= .here
            Remove tier: .tierNum + 1
        else
            Remove tier: .tierNum
            .here -= 1
        endif
    endif

    if not .tierNum
        if .isInterval
            Insert interval tier: .here, .tierName$
        else
            Insert point tier: .here, .tierName$
        endif
    endif
endproc
