# MAX-K: DRAW CURVATURE
# =====================
# Written for Praat 6.0.40

# script by Antoin Eoin Rodgers
# rodgeran@tcd.ie
# Phonetics and speech Laboratory, Trinity College Dublin

# dependency: @draw_table_line

procedure drawK: .kMaxTable, .kTable, .normalise, .minT, .maxT, .col$
	.yAxisMin = 0
	.yAxisMax = pi * 1.1
	.rightText$ = "Curvature [%F_0''(t)]"
	selectObject: .kTable
	.yAxisMin = Get maximum: "K"
	.yAxisMax = Get minimum: "K"
	.yAxisMin += 1
	.yAxisMax -= 1

	#Draw maxK points and magnitudes
	selectObject: .kMaxTable
	.numRows = Get number of rows
	Axes: .minT, .maxT, .yAxisMin, .yAxisMax
	Solid line
	Line width: 2
	Colour: .col$

for .i to .numRows
	.tempVal = Get value: .i, "Time"
	.tempK = Get value: .i, "K"
	Line width: 1
	Solid line
	Draw line: .tempVal, 0, .tempVal, .tempK
endfor

	# Draw horizontal line at 0
		Draw line: .minT, 0, .maxT, 0

	#Draw K contour
	@draw_table_line: .kTable, "Time", "K", .minT, .maxT, 0
	Marks right every: 1, ceiling((.yAxisMin - .yAxisMax)/12),
		...  "yes", "yes", "no"
	Text right: "yes", .rightText$

	Select outer viewport: 0, 6.5, 0, 4
endproc
