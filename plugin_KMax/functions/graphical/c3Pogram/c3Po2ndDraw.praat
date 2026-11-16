# C3POGRAM: FINISH DRAWING
# ========================
# Written for Praat 6.0.40

# script by Antoin Eoin Rodgers
# rodgeran@tcd.ie
# Phonetics and speech Laboratory, Trinity College Dublin

procedure c3Po2ndDraw: .type, .pitch_scale, .title$, .subtitle$
    Select outer viewport: 0, 6.5, 0, 3.35
    if .pitch_scale = 2
        .leftMajor = 5
        .leftText$ = "%f_0 (ST re 100 Hz)"
    else
        .leftMajor = 50
        .leftText$ = "%f_0 (Hz)"
    endif
    Line width: 2
    Marks left every: 1, .leftMajor, "yes", "yes", "no"
    Line width: 1
    Marks left every: 1, .leftMajor / 5, "no", "yes", "no"
    Text left: "yes", .leftText$
    Select outer viewport: 0, 6.5, 0, 4
    # add title
    Font size: 14
    Text top: "yes", "##" + .title$
    Font size: 12
    Text top: "no", .subtitle$
    Font size: 10
endproc
