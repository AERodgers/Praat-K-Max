# K-MAX: VERSION, OBJECT AND VARIABLE MANAGEMENT FUNCTION LIBRARY
# ===============================================================
# Written for Praat 6.0.40

# Antoin Eoin Rodgers
# rodgeran@tcd.ie
# Phonetics and speech Laboratory, Trinity College Dublin

# VERSION MANAGEMENT
include functions/management/versionCheck.praat

# FILE READ/WRITE FUNCTIONS
include functions/management/getFilesInDir.praat

# TABLE MANAGEMENT
include functions/management/findNearestTable.praat
include functions/management/keepCols.praat
include functions/management/pitch2Table.praat
include functions/management/removeRowsWhere.praat
include functions/management/removeRowsWhereNum.praat
include functions/management/tableText2Char.praat

# TIER MANAGEMENT
include functions/management/findTier.praat
include functions/management/getToneString.praat
include functions/management/placeTier.praat
include functions/management/textgridTemp.praat
include functions/management/textgridMerge.praat

# VARIABLE MANAGEMENT
include functions/management/list2array.praat
include functions/management/updateFormLiterals.praat
include functions/management/fixEscapeChars.praat
include functions/management/formTextToVar.praat
include functions/management/variableStorage.praat
include functions/management/vector2Str.praat
