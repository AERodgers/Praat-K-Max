# VERSION, OBJECT AND VARIABLE MANAGEMENT FUNCTIONS
# =================================================
# Written for Praat 6.0.40

# script by Antoin Eoin Rodgers
# rodgeran@tcd.ie
# Phonetics and speech Laboratory, Trinity College Dublin

# version management
include Functions/Management/versionCheck.praat

# Table management
include Functions/Management/find_nearest_table.praat
include Functions/Management/keepCols.praat
include Functions/Management/pitch2Table.praat
include Functions/Management/removeRowsWhere.praat
include Functions/Management/removeRowsWhereNum.praat

# Tier management
include Functions/Management/findTier.praat
include Functions/Management/getTonal.praat
include Functions/Management/insMissTier.praat
include Functions/Management/merge_textgrids.praat
include Functions/Management/temp_textgrid.praat

# Variable management
include Functions/Management/list2array.praat
