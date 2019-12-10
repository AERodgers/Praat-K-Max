### STH GRAPHICAL FUNCTIONS: C3POGRAM
# ===================================
# Written for Praat 6.0.40

# script by Antoin Eoin Rodgers
# rodgeran@tcd.ie
# Phonetics and speech Laboratory, Trinity College Dublin

# dependencies: @find_nearest_table

procedure drawC3pogram: .pitchTable, .secondParam,
    ... .minT, .maxT, .minF0, .maxF0, .type, .pitch_scale

    # adjust F0 if pitch scale set to semitones
    selectObject: .pitchTable
    if .pitch_scale = 2
        Formula: "F0", "log2(self/100)*12"
        .minF0 = log2(.minF0/100) * 12
        .maxF0 = log2(.maxF0/100) * 12
    endif
    selectObject: .secondParam
    .minPar2  = Get minimum: "value"
    .maxPar2 = Get maximum: "value"
    Append column: "shade"
    Formula: "shade", "1-(self[""value""] - .minPar2) / (.maxPar2 - .minPar2)"

    Select outer viewport: 0, 6.5, 0, 3.35
    Axes: .minT, .maxT, .minF0, .maxF0
    .diam = Horizontal mm to world coordinates: 0.9
    Font size: 10
    Helvetica
    Solid line

    selectObject: .pitchTable
    .numPitchPts = Get number of rows

    Colour: "Black"
    for .i to .numPitchPts
        selectObject: .pitchTable
        .curT = Get value: .i, "Time"
        .curF0 = Get value: .i, "F0"
        @find_nearest_table: .curT, .secondParam, "time"
        .curShade = Get value: find_nearest_table.index, "shade"
        .curShadeT = Get value: find_nearest_table.index, "time"
        if not(abs(.curShadeT - .curT)*1000 > 5.5555)
            if .type  = 1
                Paint circle: "{'.curShade','.curShade','.curShade'}",
                   ... .curT, .curF0, .diam * 0.1 + .diam * (1 - .curShade)
            elsif .type  = 2
                Paint circle: "{'.curShade','.curShade','.curShade'}",
                   ... .curT, .curF0, .diam * 0.1 + .diam * (1 - .curShade)
            else
                Paint circle: "{'.curShade','.curShade',1-'.curShade'}",
                   ... .curT, .curF0, .diam * 0.1 + .diam * (1 - .curShade)
            endif
            Line width: 0.5
            Colour: "blue"
            Draw circle: .curT, .curF0, .diam * 0.1 + .diam * (1 - .curShade)
        else
            Paint circle: "{1,0,0}", .curT, .curF0, .diam * 0.1
            Line width: 0.5
            Red
            Draw circle: .curT, .curF0, .diam * 0.1
        endif
        Line width: 1
        Colour: "Black"
    endfor
endproc
