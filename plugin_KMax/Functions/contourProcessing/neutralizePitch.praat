# Neutralize Pitch
# ================
# Written for Praat 6.2.07

# script by Antoin Eoin Rodgers
# rodgeran@tcd.ie
# Phonetics and speech Laboratory, Trinity College Dublin
# May 27, 2022

# resynthesizes selections of sound object with f0 neutralised to mean.

procedure PlayNeutralizePitch: .cur_selected#
    .sounds# = selected#("Sound")
    .new_sounds# = zero#(size(.sounds#))

    for .i to size(.sounds#)
        selectObject: .sounds#[.i]
        .cur_s_t = Get start time
        .cur_e_t = Get end time
        .cur_pitch_obj = To Pitch (ac): 0, 75, 15, "no", 0.03, 0.45, 0.01, 0.35, 0.14, 600
        .cur_mean = Get mean: 0, 0, "Hertz"
        removeObject: .cur_pitch_obj
        selectObject: .sounds#[.i]
        .cur_manip_obj = noprogress To Manipulation: 0.01, 75, 600
        Edit
        editor: .cur_manip_obj
            Move cursor to: .cur_s_t
            Move end of selection by: (.cur_e_t - .cur_s_t)
            Remove pitch point(s)
            Add pitch point at: (.cur_e_t - .cur_s_t) / 2, .cur_mean
        endeditor
        Play (overlap-add)
        Remove
    endfor

    selectObject: .cur_selected#
endproc
