# C3POGRAM: INITIALISE DRAWING
# ============================
# Written for Praat 6.0.40

# script by Antoin Eoin Rodgers
# rodgeran@tcd.ie
# Phonetics and speech Laboratory, Trinity College Dublin

# dependencies: @pitch2Table, @cpp, @findNearestTable

procedure c3Po1stDraw: .sound, .paintSpectro, .minT, .maxT, .refTier
    Erase all
    Black
    10
    Solid line
    Select outer viewport: 0, 6.5, 0, 3.35
    selectObject: .sound
    noprogress To Spectrogram: 0.005, 5000, 0.002, 20, "Gaussian"
    specky = selected()
    if .paintSpectro
        Paint: .minT, .maxT, 0, 0, 100, "yes", 50, 6, 0, "no"
    endif
    Remove
    Line width: 1
    Draw inner box

    if .refTier
        Select outer viewport: 0, 6.5, 0, 4
        selectObject: .refTier
    Draw: .minT, .maxT, "yes", "yes", "no"
    endif

    Marks bottom every: 1, 0.2, "yes", "yes", "no"
    Line width: 1
    Marks bottom every: 1, 0.1, "no", "yes", "no"
    Text bottom: "yes", "Time (secs)"
endproc
