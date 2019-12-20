# MAX-K SUBROUTINE: UI WINDOW
# ==============================
# Written for Praat 6.0.40

# script by Antoin Eoin Rodgers
# rodgeran@tcd.ie
# Phonetics and speech Laboratory, Trinity College Dublin
# October 10 - December 18, 2019

procedure mainUI
	# Create temporary textgrid for editing (declutter view window)
	@textgridTemp: "textgrid", r_tier$ + " " + t_tier$ + " maxK "
		... + keepTiers$

	# show sound and textgrid
	selectObject: textgridTemp.object
	plusObject: soundobject

	Edit
	# pause to let user edit the text grid
	pauseText$ = "Displaying " + sound$
		... + " (" + curSound$ + "/" + string$(numSounds) + ")"
	beginPause: pauseText$
		comment: "Current smoothing parameters"
		natural: "Praat smooothing bandwidth", pre_smoothing
		natural: "Physiological constraints", coarse_smoothing
		comment: "General Image Options"
        boolean: "Draw_figure", draw_figure
        boolean: "Format_for_printing", format_for_printing
        comment: "Display options"
		boolean: "Draw_spectrogram", drawSpectro
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
		... ">",
		... "Exit", 4

    #shorten UI names
	draw_f0_corrected = corrected_contour
	draw_K = curvature_contour
	draw_resynth = resynthesised_contour
	draw_tonal = tonal_annotation_and_ideal_targets
	coarse_smoothing = physiological_constraints
	pre_smoothing = praat_smooothing_bandwidth
    widthCoeff = (format_for_printing) + 1
    drawSpectro = draw_spectrogram

	@textgridMerge
	feedback = 0
	warning = 0
endproc
