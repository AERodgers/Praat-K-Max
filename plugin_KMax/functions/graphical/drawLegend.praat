# DRAW LEGEND
# ===========
# Written for Praat 6.0.40

# script by Antoin Eoin Rodgers
# rodgeran@tcd.ie
# Phonetics and speech Laboratory, Trinity College Dublin

procedure drawLegend: .xMin, .xMax, .yMin, .yMax,
    ... .xyTable, .xCol$, .yCol$, .legendTable, .threshold,  .widthCoeff

    Line width: 1
    Solid line
    Black
    Select outer viewport: 0, 6.5, 0, 3.35

    # process legendTable
    selectObject: .legendTable
    .legendLines = Get number of rows
    .fromLegend = 1
    for .i to .legendLines
        .style$[.i] = Get value: .i, "style"
        .colour$[.i] = Get value: .i, "colour"
        .text$[.i] = Get value: .i, "text"
        .size[.i] = Get value: .i, "size"
    endfor

    # calculate legend width
    .legendWidth = 0
    .legendWidth$ = ""
    for .i to .legendLines
        .len = length(.text$[.i])
        if .len > .legendWidth
            .legendWidth = .len
            .legendWidth$ =  .text$[.i]
        endif
    endfor

    # calculate box dimensions
    Axes: .xMin, .xMax, .yMin, .yMax
    .text_width = Text width (world coordinates): .legendWidth$
    .x_unit = Horizontal mm to world coordinates: 4
    .x_start = .xMin + .x_unit
    .x_end = .xMin + 4.5 * .x_unit + .text_width
    .y_unit  = Vertical mm to world coordinates: 4
    .y_start = .yMin + .y_unit
    .y_end = .yMin + .y_unit * (.legendLines + 2)

    # calculate  .hor, .vert, (hor = 0 = left; vert = 0 = bottom)
    # Get stats for graph
    .horS[1] = .x_start
    .horE[1] = .x_end
    .horS[2] = .xMax - (4.5 * .x_unit + .text_width)
    .horE[2] = .xMax - .x_unit

    .vertS[1] = .y_start
    .vertE[1] = .y_end
    .vertS[2] = .yMax - (.y_unit * (.legendLines + 2))
    .vertE[2] = .yMax - .y_unit

    bestZone## = zero##(2, 2)
    bestZoneLen## = zero##(2, 2)
    selectObject: .xyTable
    .numRows = Get number of rows
    .totalLen = 0
    for .i from 2 to .numRows
        .curX = Get value: .i, .xCol$
        .curY = Get value: .i, .yCol$
        .lastX = Get value: .i - 1, .xCol$
        .lastY = Get value: .i - 1, .yCol$

        for .j to 2
            for .k to 2
                .curLen = ((.lastY - .curY)^2 + (.lastX - .curX)^2)^0.5
                .totalLen += .curLen
                if .curX >= .horS[.j] - .x_unit * 2
                    ... and .curX <= .horE[.j] + .x_unit * 2
                    ... and .curY  >= .vertS[.k] - .y_unit * 2
                    ... and .curY <= .vertE[.k] + .y_unit * 2
                    bestZone##[.j,.k] = bestZone##[.j,.k] + 1
                    bestZoneLen##[.j,.k] = bestZoneLen##[.j,.k] + .curLen
                endif
            endfor
        endfor
    endfor

    .least# = {0,0}
    .most = 10^10
    for .j to 2
        for .k to 2
            if bestZoneLen##[.j, .k] < .most
                .most = bestZoneLen##[.j, .k]
                .least# = {.j, .k}
            endif
        endfor
    endfor

    # adjust coordinates to match horizontal and vertical alignment
    .x_end = .horE[.least#[1]]
    .x_start = .horS[.least#[1]]
    .y_start = .vertS[.least#[2]]
    .y_end = .vertE[.least#[2]]

    # Draw only main legend item if percentage of contour hidden > threshold
    if .most/.totalLen > .threshold
        # recalculate legend co-ordinates
        .fromLegend = .legendLines
        .text_width = Text width (world coordinates): .text$[.fromLegend]
        .x_start = .xMin + .x_unit
        .x_end = .xMin + 4.5 * .x_unit + .text_width
        .y_start = .yMin + .y_unit
        .y_end = .yMin + .y_unit * (3)

        .horS[1] = .x_start
        .horE[1] = .x_end
        .horS[2] = .xMax - (4.5 * .x_unit + .text_width)
        .horE[2] = .xMax - .x_unit

        .vertS[1] = .y_start
        .vertE[1] = .y_end
        .vertS[2] = .yMax - (.y_unit * (3))
        .vertE[2] = .yMax - .y_unit

        .x_end = .horE[.least#[1]]
        .x_start = .horS[.least#[1]]
        .y_start = .vertS[.least#[2]]
        .y_end = .vertE[.least#[2]]
    endif

    ### Draw box and frame
    Paint rectangle: 0.9, .x_start, .x_end,
                 ... .y_start,  .y_end
    Colour: "Black"
    Draw rectangle: .x_start, .x_end,
                 ... .y_start,  .y_end

    # Write legend text
    for .i from .fromLegend to .legendLines
        Font size: 10
        .iRef = .i - .fromLegend + 1
        # use colour text if no box
        Colour: "Black"
        Text: .x_start + 2.5 * .x_unit , "Left", .y_start + .y_unit * .iRef,
            ... "Half", "##" + .text$[.i]
    endfor


    # Draw Lines and icons
    for .i from .fromLegend to .legendLines
        Font size: 10
        Helvetica
        .iRef = .i - .fromLegend + 1
        if left$(.style$[.i], 1) = "L" or left$(.style$[.i], 1) = "l"
            Line width: .size[.i] + 2
            Colour: "White"
            Draw line: .x_start + 0.5 * .x_unit, .y_start + .y_unit * .iRef,
                ... .x_start + 2 * .x_unit, .y_start + .y_unit * .iRef
            Line width: .size[.i]
            Colour: .colour$[.i]
            Draw line: .x_start + 0.5 * .x_unit, .y_start + .y_unit * .iRef,
                ... .x_start + 2 * .x_unit, .y_start + .y_unit * .iRef
        elsif left$(.style$[.i], 1) = "D" or left$(.style$[.i], 1) = "d"
            @colourChange: .colour$[.i],  "drawLegend.lighter$", "* {2, 2, 2}"
            Paint circle: "Black", .x_start + 0.75 * .x_unit,
                ... .y_start + .y_unit * .iRef,
                ... ((.size[.i]) * .x_unit / 4)
            Paint circle: "Black", .x_start + 1.25 * .x_unit,
                ... .y_start + .y_unit * .iRef,
                ... ((.size[.i] + 0.25) * .x_unit / 4)
            Paint circle: "Black", .x_start + 1.75 * .x_unit,
                ... .y_start + .y_unit * .iRef,
                ... ((.size[.i]) * .x_unit / 4)
            Paint circle: .lighter$, .x_start + 1.75 * .x_unit,
                ... .y_start + .y_unit * .iRef,
                ... ((.size[.i] - 0.25) * .x_unit / 4)
            Paint circle: .colour$[.i], .x_start + 1.25 * .x_unit,
                ... .y_start + .y_unit * .iRef, (.size[.i] * .x_unit / 4)
            Paint circle: .lighter$, .x_start + 0.75 *.x_unit,
                ... .y_start + .y_unit * .iRef,
                ... ((.size[.i] - 0.25) * .x_unit / 4)
        else
            .temp = Create Table with column names: "table", 1, "X Y Mrk Xs Ys"
            .xS = Horizontal mm to world coordinates: 0.2
            .yS = Vertical mm to world coordinates: 0.2
            Set numeric value: 1, "X" , .x_start + 1.25 * .x_unit
            Set numeric value: 1, "Y" , .y_start + .y_unit * .iRef
            Set numeric value: 1, "Xs" , .x_start + 1.25 * .x_unit + .xS
            Set numeric value: 1, "Ys" , .y_start + .y_unit * .iRef - .yS
            Set string value: 1, "Mrk", .style$[.i]
            Line width: 2 * .widthCoeff
            Colour: "White"
            Scatter plot (mark): "Xs", .xMin, .xMax, "Ys",
                ... .yMin, .yMax, 2 + (.widthCoeff/2), "no", left$(.style$[.i], 1)
            Colour: .colour$[.i]
            Scatter plot (mark): "X", .xMin, .xMax, "Y",
                ... .yMin, .yMax, 2 + (.widthCoeff/2), "no", left$(.style$[.i], 1)
            Remove
        endif
    endfor

    Select outer viewport: 0, 6.5, 0, 4
endproc
