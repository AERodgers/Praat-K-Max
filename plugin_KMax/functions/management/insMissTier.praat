# INSERT MISSING TIER
# ===================
# Written for Praat 6.0.40

# script by Antoin Eoin Rodgers
# rodgeran@tcd.ie
# Phonetics and speech Laboratory, Trinity College Dublin

procedure insMissTier: .textgrid, .tierName$, .after$, .isInterval
    # This checks .textgrid for .tierName$. If it is not found, it is added to
    # the textgrid after the tier called .after$. If .after$ does not exist,
    # .tierName$ is inserted at the bottom of the textgrid. if .isInterval = 1
    # then .tierName$ is an interval tier; otherwise, it is a point tier.
    # If the tier exists but is not the target tier type (interval or point),
    # it will be replaced with the target tier type.
    selectObject: .textgrid
    .numTiers = Get number of tiers
    .tierNum = 0
    .existsAsInt = 0
    .tierExists = 0
    .after = 0
    for .curTier to .numTiers
        .curIsInt = Is interval tier: .curTier
        .curTier$ = Get tier name: .curTier
        if .curTier$ = .tierName$
            .tierExists  = 1
            .tierNum = .curTier
            .existsAsInt = .curIsInt
            .after = .curTier - 1
        elsif .curTier$ = .after$
            .after = .curTier
        endif
    endfor

    if not .after
        .after = .numTiers
    endif

    if .tierExists and .isInterval != .existsAsInt
        Remove tier: .tierNum
        .numTiers -= 1
        .tierExists = 0
    endif

    if not .tierExists
        if .isInterval
            Insert interval tier: .after + 1, .tierName$
        else
            Insert point tier: .after + 1, .tierName$
        endif
    endif
endproc
