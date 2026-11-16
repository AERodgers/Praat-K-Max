# K-MAX SUBROUTINE: PITCH VARIABLES UI
# ====================================
# Written for Praat 6.0.40

# script by Antoin Eoin Rodgers
# rodgeran@tcd.ie
# Phonetics and speech Laboratory, Trinity College Dublin
# October 10 - December 18, 2019

procedure toPitchVars
	beginPause: "Variables for To Pitch (ac) built-in Praat function"
	# set "To Pitch" variables if not set in @toPitchVariables
		natural: "Max. number of candidates", 15
		positive: "Silence threshold", 0.03
		positive: "Voicing threshold", 0.45
		positive: "Octave cost", 0.01
		positive: "Octave-jump cost", 0.35
		positive: "Voiced / unvoiced cost", 0.14
	edit_choice = endPause:
		... "Continue", 1, 1
endproc
