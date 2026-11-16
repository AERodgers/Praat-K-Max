# GET ARRAY SIZE
# ====================================
# Written for Praat 6.0.40

# script by Antoin Eoin Rodgers
# rodgeran@tcd.ie
# Phonetics and speech Laboratory, Trinity College Dublin

# Returns the size of array (.array_name$) in the variable .output_var$.
# .array_name$ and .output_var$ must be the
# Assuming an array with complete sequence, ( i.e., no non-empty indices)

procedure arraySize: .output_var$, .array_name$
    .arraySize = 0
    .varExists = 1

    while (.varExists)
        .arraySize += 1
        .testVar$ = "'.array_name$'['.arraySize']"
        .varExists = variableExists(.testVar$)
    endwhile
    .arraySize -= 1
    '.output_var$' = .arraySize
endproc
