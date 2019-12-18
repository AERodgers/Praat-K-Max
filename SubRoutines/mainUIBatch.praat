# MAX-K SUBROUTINE: BATCH PROCESSING IMAGE UI
# ===========================================
# Written for Praat 6.0.40

# script by Antoin Eoin Rodgers
# rodgeran@tcd.ie
# Phonetics and speech Laboratory, Trinity College Dublin
# October 10 - December 18, 2019

procedure mainUIBatch
	beginPause: "Select image options before running batch analysis"
        boolean: "Draw_figure",  draw_figure
        comment: "Image options"
		boolean: "Corrected contour", draw_f0_corrected
		boolean: "Curvature contour", draw_K
		boolean: "Resynthesised contour", draw_resynth
		boolean: "Tonal annotation and ideal targets", draw_tonal
        boolean: "Draw_spectrogram", drawSpectro
        boolean: "Format_for_printing", widthCoeff
	continue = endPause: "Begin Processing", 1

    #shorten UI names
	draw_f0_corrected = corrected_contour
	draw_K = curvature_contour
	draw_resynth = resynthesised_contour
	draw_tonal = tonal_annotation_and_ideal_targets
	coarse_smoothing = physiological_constraints
	fine_smoothing = fine_grained_smoothing
	pre_smoothing = praat_smooothing_bandwidth
    widthCoeff = (format_for_printing) + 1
    drawSpectro = draw_spectrogram
endproc
