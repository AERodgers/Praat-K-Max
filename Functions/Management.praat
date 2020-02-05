# K-MAX: VERSION, OBJECT AND VARIABLE MANAGEMENT FUNCTIONS
# ========================================================
# Written for Praat 6.0.40

# script by Antoin Eoin Rodgers
# rodgeran@tcd.ie
# Phonetics and speech Laboratory, Trinity College Dublin

# version management
include Functions/Management/versionCheck.proc

# Table management
include Functions/Management/findNearestTable.proc
include Functions/Management/keepCols.proc
include Functions/Management/pitch2Table.proc
include Functions/Management/removeRowsWhere.proc
include Functions/Management/removeRowsWhereNum.proc

# Tier management
include Functions/Management/findTier.proc
include Functions/Management/insMissTier.proc
include Functions/Management/textgridTemp.proc
include Functions/Management/textgridMerge.proc
include Functions/Management/getTonal.proc

# Variable management
include Functions/Management/list2array.proc
