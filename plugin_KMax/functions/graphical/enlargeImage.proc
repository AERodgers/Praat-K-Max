# enlargeImage
# ============
# Written for Praat 6.0.40

# script by Antoin Eoin Rodgers
# rodgeran@tcd.ie
# Phonetics and speech Laboratory, Trinity College Dublin

procedure enlargeImage: .w, .h
    Font size: 1
    # Redraws current image using dimensions .w and .h
    if .w > .h
        .multiple = 12 / .w
    else
        .multiple = (12 - .h) / .h
    endif
    Save as 600-dpi PNG file: "praat_tmp.png"
    Read from file: "praat_tmp.png"
    Select outer viewport: 0, .w  * (.multiple), .h, .h * (1 + .multiple)
    Axes: 0, 1, 0, 1
    Paint image: 0, 0, 0, 0
    Select outer viewport: 0, .w  * (.multiple), .h, .h * (1 + .multiple)
    deleteFile: "praat_tmp.png"
    Remove
    Font size: 10
endproc
