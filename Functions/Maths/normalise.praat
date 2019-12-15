# NORMALISE
# =========
# Written for Praat 6.0.40

# script by Antoin Eoin Rodgers
# rodgeran@tcd.ie
# Phonetics and speech Laboratory, Trinity College Dublin

# dependencies: @removeRowsWhere

procedure normalise: .table, .col$
    selectObject: .table
    .temp = Copy: "temp"
    @removeRowsWhere: normalise.temp, .col$, "= ""--undefined--"""
    .yMin = Get minimum: .col$
    .yMax = Get maximum: .col$
    Remove
    selectObject: .table
    Formula: .col$, "(self - .yMin)/(.yMax-.yMin)"
endproc
