# K-MAX: Tone Tier Analysis functions
# ================================
# Written for Praat 6.0.40

# Antoin Eoin Rodgers
# rodgeran@tcd.ie
# Phonetics and speech Laboratory, Trinity College Dublin
#
# The library of functions here assume that there is a TextGrid with:
#     1. only one intonational phrase;
#     2. a rhythm point tier annotated with  % to show IP boundaries and
#        < > to show the start and end of lexical stress.
#     3. a tone point tier using AM conventions:
#            a. LH  for tonal targets;
#            b. *   after tonal targets associated with a stressed syll-
#                   able (a starred tone / main tone of a pitch accent);
#            c. a + sign before or after a tonal target to indicate
#                   an association with a starred tone;
#        In addition, the following annotations can be used:
#            d. _   to indicate a secondary tone associated with a pitch
#                   accent or boundary tone;
#            e. 0   to indicate a lack of tonal specification at a
#                   boundary, or an apparent end of the effect of a
#                   tonal target
#            f  lh  to indicate phonetic evidence of a non-salient
#                   tonal target; i.e., evidence of a "reflex" or
#                   deleted tonal target.
# praat error message line offset =~ -89

include functions/phonoTierGeneration/addPhonTiers.praat
include functions/phonoTierGeneration/analyseRhythmTier.praat
include functions/phonoTierGeneration/asIViEPhon.praat
include functions/phonoTierGeneration/findEventCores.praat
include functions/phonoTierGeneration/generatePhonoTiers.praat
include functions/phonoTierGeneration/getMinPhonoString.praat
include functions/phonoTierGeneration/insertPhonoTier.praat
