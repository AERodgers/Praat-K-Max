# MAX-K SUBROUTINE: UI WINDOW
# ==============================
# Written for Praat 6.0.40

# script by Antoin Eoin Rodgers
# rodgeran@tcd.ie
# Phonetics and speech Laboratory, Trinity College Dublin
# October 10 - December 17, 2019

procedure uiWindow
	# Create temporary textgrid for editing (declutter view window)
	@temp_textgrid: "textgrid", r_tier$ + " " + t_tier$ + " maxK "
		... + keepTiers$

	# show sound and textgrid
	selectObject: temp_textgrid.object
	plusObject: soundobject

	Edit
	# pause to let user edit the text grid
	pauseText$ = "Displaying " + sound$
		... + " (" + curSound$ + "/" + string$(numSounds) + ")"
	beginPause: pauseText$
		comment: "Current smoothing parameters"
		natural: "Praat smooothing bandwidth", pre_smoothing
		natural: "Physiological constraints", coarse_smoothing
		natural: "Fine grained smoothing", fine_smoothing
		comment: "Image Drawing Options"
		boolean: "Corrected contour", draw_f0_corrected
		boolean: "Curvature contour", draw_K
		boolean: "Resynthesised contour", draw_resynth
		boolean: "Tonal annotation and ideal targets", draw_tonal
		sentence: "Comment", comment$
		integer: "Next object", curr_sound + 1
		if feedback
			comment: "ERRORS AND OBSERVATIONS"
			if warning
				selectObject: errorBeep
				Play
			endif
		endif
		for i to feedback
			comment: feedback$[i]
		endfor
	edit_choice = endPause:
		... "Smooth",
		... "Fix F0",
		... "Process",
		... "<",
		... "Next",
		... "Exit", 4

	draw_f0_corrected = corrected_contour
	draw_K = curvature_contour
	draw_resynth = resynthesised_contour
	draw_tonal = tonal_annotation_and_ideal_targets
	coarse_smoothing = physiological_constraints
	fine_smoothing = fine_grained_smoothing
	pre_smoothing = praat_smooothing_bandwidth
	@merge_textgrids
	feedback = 0
	warning = 0
endproc