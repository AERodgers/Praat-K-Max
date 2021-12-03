# K-MAX: Generate Intonational Phonology
# ======================================
# Version 0.1.0
#
# A plug-in extension for K-Max
#
# Written for Praat 6.0.40

# script by Antoin Eoin Rodgers
# rodgeran@tcd.ie
# Phonetics and speech Laboratory, Trinity College Dublin
# October 19, 2021
#
# The procedure adds an intermediate phonological tier and a minimal (IViE) tier
# to any Textgrid in a file which has:
#     A. only one intonational phrase;

#     B. a rhythm point tier annotated with:
#            1.   %     - to show IP boundaries;
#            2.   < >   - to show the start and end of lexical stress.

#     C. a tone point tier using AM conventions:
#            1.   L H   - for tonal targets;
#            2.   *     - after tonal targets associated with a stressed syll-
#                         able (a starred tone / main tone of a pitch accent);
#            3.   +     - sign before or after a tonal target to indicate an
#                         association with a starred tone;
#
#     D. The following annotations can be also be used in the tone tier:
#            1.   _     - to indicate a secondary tone associated with a pitch
#                         accent or boundary tone;
#            2.   0     - to indicate a lack of tonal specification at a
#                         boundary, or an apparent end of the effect of a tonal
#                         target;
#            3.   l h   - to indicate phonetic evidence of a non-salient tonal
#                         target; i.e., evidence of a "reflex" or deleted tonal
#                         deleted tonal target.

form STH ToneTierAnalysis
    sentence Directory_with_TextGrid_files example
    word Rhythmic_tier rhythm
    word Tonal_tier tones
endform

@versionCheck
@updateFormLiterals("main_genIntonPhon.praat")

# CORRECT DIRECTORY NAME ERRORS
dir$ = directory_with_TextGrid_files$
if (right$(dir$, 1) != "/" or right$(dir$, 1) != "\")
    dir$ = dir$ + "/"
endif

# RUN MAIN LOOP
@generatePhonoTiers: dir$, rhythmic_tier$, tonal_tier$

# FUNCTION LIBRARIES
include functions/management.praat
include functions/phonoTierGeneration.praat
