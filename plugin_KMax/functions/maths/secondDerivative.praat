# SECOND DERIVATIVE OF A DISCRETE CONTOUR
# =========================================
# Written for Praat 6.0.40

# script by Antoin Eoin Rodgers
# rodgeran@tcd.ie
# Phonetics and speech Laboratory, Trinity College Dublin
# October 10 - December 18, 2019

procedure secondDerivative: .table, .x$, .y$, .d2ydx2Col$
    # Calculates the second time derivative of a discrete contour.
        # @secondDerivative calculates the second derivative of a discrete
        # contour in .table using columns .x$ and .y$. It outputs the result in
        # the column .d2ydx2Col$. If there is no column called .d2ydx2Col$, it
        # is created by the procedure.
        #
        # Note that:
        #     - the 1st and last rows columns will be undefined;
        #     - the procedure also stores the intercept of f(x) and f'(x)
        #       in the variables .i_fx and .i_dydx.
        #
        # The second derivative is calculated as follows:
        #
        #   N - 1
        #  ------
        #  \      d2y     1      /                    \
        #   |     ---- = ---- * |  y     + y    - 2y   | ,   n  = NaN , n  = NaN
        #  /      dx^2   dx^2    \  n+1     n-1     n /       1          N
        #  ------
        #   n = 2

    selectObject: .table
    .x1 = Get value: 1, .x$
    .x2 = Get value: 2, .x$
	  .dx = .x2 - .x1

    selectObject: .table
    .i_fx = Get value: 1, .y$
    .y2 = Get value: 2, .y$
    .i_dydx =  (.y2 - .i_fx) /( .dx)

    selectObject: .table
    Append row
    Insert row: 1
    .y0$ = .y$ + "0"
    .y2$ = .y$ + "2"
    Append column: .y0$
    Append column: .y2$

    .d2ydx2Exists = Get column index: .d2ydx2Col$
    if not .d2ydx2Exists
        Append column: .d2ydx2Col$
    endif
    numRows = Get number of rows
    for  .i from 2 to numRows - 1
        .curY = Get value: .i, .y$
        Set numeric value: .i + 1, .y0$ , .curY
        Set numeric value: .i - 1, .y2$ , .curY
    endfor
    Remove row: 1
    Remove row: numRows - 1
    Formula: .d2ydx2Col$, "(self[.y0$] + self[.y2$] - 2 * self[.y$]) / .dx ^ 2"
    Remove column: .y0$
    Remove column: .y2$
endproc
