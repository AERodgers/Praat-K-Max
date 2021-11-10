procedure versionCheck
    # Procedure check that a current version of Praat is being used.
    #
    # Antoin Eoin Rodgers
    # rodgeran@tcd.ie
    # Phonetics and speech Laboratory, Trinity College Dublin
    version$ = praatVersion$
    if number(left$(version$, 1)) < 6
        echo You are running Praat 'praatVersion$'.
        ... 'newline$'This script runs on Praat version 6.0.40 or later.
        ... 'newline$'To run this script, update to the latest
        ... version at praat.org
        exit
    endif
endproc
