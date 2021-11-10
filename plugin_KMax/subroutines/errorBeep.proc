# Create error Beep
# =================
# Written for Praat 6.0.40

# script by Antoin Eoin Rodgers
# rodgeran@tcd.ie
# Phonetics and speech Laboratory, Trinity College Dublin

procedure errorBeep
    .c7 = Create Sound as pure tone: "tone", 1, 0, 0.1, 10000,
        ...  13.75*2^7*(2^(3/12)), 0.2, 0.01, 0.01
    .ab6 = Create Sound as pure tone: "tone", 1, 0, 0.1, 10000,
        ... 13.75*2^6*(2^(11/12)), 0.2, 0.01, 0.01
    plusObject: .c7
    .sound = Concatenate
    selectObject: .c7
    plusObject: .ab6
    Remove
endproc
