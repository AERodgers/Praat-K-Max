# Praat-K-Max
A plugin for annotating and analysing intonational phrases using
points of maximum curvature estimated from the second time derivative of the
F0 contour.

Requires [Praat version 6.x.x](http://www.fon.hum.uva.nl/praat/).

To use the plugin, select "Clone or download" followed by "Download ZIP".
Extract the ZIP file and copy the folder named "plugin_KMax" to the Praat
preferences directory. See http://www.fon.hum.uva.nl/praat/manual/preferences_directory.html
for more information.

When you run Praat, you can run K-Max from the Praat menu in the objects window.

* Praat > K-Max > Annotate tones and process contours...

Don't forget to read "guide.txt" to learn how to use K-Max!

When running the main routine, the Info window also shows a short user guide if you flag it in the initial menu.

20/10/2021
## Edit TextGrids
I have added the "Edit Textgrids..." feature which allows you to flip back and forth through all the sound & textgrid pairings in a specified folder.
You can edit and save them, go forward, move back, or jump to a specific file. It's very handy for checking and editing your annotations.

* Praat > K-Max > Edit textgrids...

## Associated Publication
[The paper can be found here.](https://www.isca-speech.org/archive/SpeechProsody_2020/pdfs/287.pdf)

For citation: Rodgers, A. (2020) K-Max: a tool for estimating, analysing, and evaluating tonal targets. Proc. 10th International Conference on Speech Prosody 2020, 225-229, DOI: 10.21437/SpeechProsody.2020-46

    @inproceedings{Rodgers2020,
      author={Antoin Rodgers},
      title={{K-Max: a tool for estimating, analysing, and evaluating tonal targets}},
      year=2020,
      booktitle={Proc. 10th International Conference on Speech Prosody 2020},
      pages={225--229},
      doi={10.21437/SpeechProsody.2020-46},
      url={http://dx.doi.org/10.21437/SpeechProsody.2020-46}
    }
