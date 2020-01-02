# MAX-K SUBROUTINE: BATCH PROCESSING IMAGE UI
# ===========================================
# Written for Praat 6.0.40

# script by Antoin Eoin Rodgers
# rodgeran@tcd.ie
# Phonetics and speech Laboratory, Trinity College Dublin
# October 10 - December 18, 2019

procedure mainUIBatch
	beginPause: "Select image options before running batch analysis"
        boolean: "Draw figure",  draw_figure
        comment: "Image display options"
		boolean: "Draw spectrogram", drawSpectro
		boolean: "Corrected contour", draw_f0_corrected
		boolean:  "Second time derivative contour", draw_K
		boolean: "Resynthesised contour", draw_resynth
		boolean: "Tonal annotation and ideal targets", draw_tonal
        boolean: "Format for printing", format_for_printing
	continue = endPause: "Begin Processing", 1

    #shorten UI names
	draw_f0_corrected = corrected_contour
	draw_K = second_time_derivative_contour
	draw_resynth = resynthesised_contour
	draw_tonal = tonal_annotation_and_ideal_targets
	coarse_smoothing = physiological_constraints
	pre_smoothing = praat_smooothing_bandwidth
    widthCoeff = (format_for_printing) + 1
    drawSpectro = draw_spectrogram
endproc
