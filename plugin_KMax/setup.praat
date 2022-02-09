# Create K-Max menu in the Prat menu of the Objects window.

# Add spacer to Praat Objects menu
Add menu command: "Objects", "Praat",
              ... "--",
              ... "", 0,
              ... ""

# Create K-Max sub-menu.
Add menu command: "Objects", "Praat",
              ... "K-Max",
              ... "", 0,
              ... ""

# Add TextGrid creation scripts to K-Max sub-menu.
Add menu command: "Objects", "Praat",
              ... "Create Syllable and Comments Textgrids...",
              ... "K-Max", 1,
              ... "create_textgrids.praat"
Add menu command: "Objects", "Praat",
              ... "Add Blank IViE Tiers...",
              ... "K-Max", 1,
              ... "create_more_tiers.praat"

# Add spacer to K-Max sub-menu.
Add menu command: "Objects", "Praat",
              ... "--",
              ... "K-Max", 1,
              ... "main_editTextgrids.praat"

# Add core K-Max scripts to K-Max sub-menu.
Add menu command: "Objects", "Praat",
              ... "Annotate tones and process contours...",
              ... "K-Max", 1,
              ... "main_K-Max.praat"
Add menu command: "Objects", "Praat",
             ... "Generate phonology tiers...",
             ... "K-Max", 1,
             ... "main_genIntonPhon.praat"

# Add spacer to K-Max sub-menu.
Add menu command: "Objects", "Praat",
            ... "--",
            ... "K-Max", 1,
            ... "main_editTextgrids.praat"

# Add Edit TextGrids functionality to K-Max sub-menu.
Add menu command: "Objects", "Praat",
             ... "Edit TextGrids...",
             ... "K-Max...", 1,
             ... "main_editTextgrids.praat"
