# Create K-Max menu in the Prat menu of the Objects window.
Add menu command: "Objects", "Praat", "--",       "", 0,  ""
Add menu command: "Objects", "Praat", "K-Max",    "", 0, ""


# Add plugin functions
Add menu command: "Objects", "Praat",
              ... "Annotate tones and process contours...", "K-Max...", 1,
              ... "main_K-Max.praat"
Add menu command: "Objects", "Praat",
              ... "Generate phonology tiers...", "K-Max...", 1,
              ... "main_genIntonPhon.praat"
Add menu command: "Objects", "Praat",
              ... "Edit TextGrids...", "K-Max...", 1,
              ... "main_editTextgrids.praat"
