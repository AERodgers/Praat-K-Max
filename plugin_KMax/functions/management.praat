# K-MAX: VERSION, OBJECT AND VARIABLE MANAGEMENT FUNCTION LIBRARY
# ===============================================================
# Written for Praat 6.0.40

# Antoin Eoin Rodgers
# rodgeran@tcd.ie
# Phonetics and speech Laboratory, Trinity College Dublin

# VERSION MANAGEMENT
include functions/management/versionCheck.proc

# FILE READ/WRITE FUNCTIONS
include functions/management/getFilesInDir.proc

# TABLE MANAGEMENT
include functions/management/findNearestTable.proc
include functions/management/keepCols.proc
include functions/management/pitch2Table.proc
include functions/management/removeRowsWhere.proc
include functions/management/removeRowsWhereNum.proc
include functions/management/tableText2Char.proc

# TIER MANAGEMENT
include functions/management/findTier.proc
include functions/management/getToneString.proc
include functions/management/placeTier.proc
include functions/management/textgridTemp.proc
include functions/management/textgridMerge.proc

# VARIABLE MANAGEMENT
include functions/management/list2array.proc
include functions/management/updateFormLiterals.proc
include functions/management/fixEscapeChars.proc
include functions/management/formTextToVar.proc
