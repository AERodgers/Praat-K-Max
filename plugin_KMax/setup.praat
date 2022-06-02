# Create K-Max menu in the Praat menu of the Objects window.
Add menu command: "Objects", "Praat", "--",       "", 0,  ""
Add menu command: "Objects", "Praat", "K-Max",    "", 0, ""


# Add plugin Functions
Add menu command: "Objects", "Praat",
              ... "Annotate tones and process contours...", "K-Max...", 1,
              ... "main_K-Max.praat"
Add menu command: "Objects", "Praat",
              ... "Generate phonology tiers...", "K-Max...", 1,
              ... "main_genIntonPhon.praat"
Add menu command: "Objects", "Praat",
              ... "Edit TextGrids...", "K-Max...", 1,
              ... "main_editTextgrids.praat"

## Play Neutralized Pitch
Add action command:
... "Sound", 1,
... "TextGrid", 0,
... "", 0,
... " ",
... "", 0,
... ""

Add action command:
... "Sound", 1,
... "TextGrid", 1,
... "", 0,
... "K-Max",
... "", 0,
... ""

Add action command:
... "Sound", 1,
... "TextGrid", 1,
... "", 0,
... "Play Neutralized Pitch...",
... "K-Max", 0,
... "main_neutralize_pitch.praat"
