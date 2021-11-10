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

## Edit TextGrids
I have added the "Edit Textgrids..." feature which allows you to flip back and forth through all the sound & textgrid pairings in a specified folder.
You can edit and save them, go forward, move back, or jump to a specific file. It's very handy for checking and editing your annotations.

* Praat > K-Max > Edit textgrids...

## Associated Publications
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


## **genIntonPhon**
The Generate Intonational phonology (genIntonPhon) component is part of my PhD work into the analysis of intonation in Derry City English in Northern Ireland.

Access genIntonPhon from the Praat menu in the objects window:

* [Praat] > [Generate Intonational Phonology...]

**NOTE**: each textgrid must have a _**rhythmic tier**_ and a _**tonal tier**_ for the script to run correctly. (See menu image here and *Annotation conventions* further down.)

![Example form menu](/images/FormMenuExample.png)

The textgrids are processed automatically, and the following tiers are added below the rhythmic tier:
Tier name | Meaning | Explanation
---|---|---
intPhono | Intermediate Phonological Tier | An intermediate form which contains the full specification or each boundary and pitch accent event.
minPhono | Minimally specified Phonological Tier | A tier using IViE [1] annotation conventions.

The Praat object window is also updated if there are spurious annotations or errors caught by the script.

**NOTE**: some of the minPhono tier annotations are derived from *expectations* about the relationship between the intermediate form and the minimally specified form. (See *Deriving minPhono tier from the intPhono tier* below.)

After processing, each textgrid should look like the example shown here.

![Example of textgrid after processing](/images/exampleTextgrid.png)

## **Annotation conventions**

1.  There is only one intonational phrase (IP) per file.
1.  The **rhythmic tier** is a point tier annotated with the following characters.

    symbols | function
    ------------ | -------------
    % | IP boundaries
    < > | show the start and end of lexical stress

1.  The **tonal tier** is a point tier which uses Autosegmental Metrical (AM) conventions and variations as shown in the table below.

    **symbols** | **Use** | **Comment**
    ------------ | ------------- | -------------
    L H | indicates a low or high tonal target | standard AM annotation
    \* | after the tonal target of a pitch accent (PA) associated with a stressed syllable ("starred tone") | standard AM annotation
    \+ | before or after a tonal target to indicate that the tone is associated with the starred tone and is part of the PA | standard AM annotation (ToBI but not IViE)
    _ | before or after a secondary tone associated with a pitch accent or boundary tone | used in ToBI for phrase accents; used here more generally
    0 | indicates a lack of tonal specification at a boundary, or an apparent end of the effect of a tonal target | originated by Ester Grabe in relation to boundary tones, but also used for slightly different purposes here
    l h | to indicate phonetic evidence of a non-salient tonal target; i.e., evidence of a "reflex" or deleted tonal deleted tonal target. | atypical use

## **Deriving minPhono tier from the intPhono tier**

1. Typically secondary tones (L\_ \_0, etc.) are removed from the minPhono tier.
2. Unspecified boundary tones (indicated by a 0) are deleted in the minPhono tier.
3. a % is added at the both the leftmost and rightmost bounday, even if there is no tonal specification.
4. "\+" symbols are deleted in the minPhone tier in line with IViE conventions.
5. Stress with no PA is annotated with an asterisk (\*) in both the intPhono and minPhono tiers.
6. Other less predictable formal derivations in the minPhono are largely a means of testing some hypotheses (and assumptions) for my PhD research. These derivations are outlined in the table below.

    **intPhono Form** | **minPhono Form** | **Comment/Hypothesis**
    ---|---|-------------------
    L\_H\* | !H* | Downstepped H* based on the observation that a sequence of H tones showing downstep must necessarily be interspersed with secondary L tones (seen in the almost literal L shaped elbows preceding a downstepped H\*)
    l\*\+H | >H\* | deleted L* tone leads to a >H* PA (delayed peak) as a predictable variant of underlying L\*H
    L\*\+h | L\* | deleted +H tone leads to an L* PA with delayed peak as a variant of underlying L\*H
    l\_H\* | H\* | indicates evidence of hypothesised leftward drift and deleted of L* in L\*H PAs with
    l\*\+h | * | occasionally there is evidence of a phonetic trace of a deleted L\*H PA but which is accompanied by the percept of any pitch accent.

## References

[1] Grabe, Esther. 2001. The IViE Labelling Guide http://www.phon.ox.ac.uk/files/apps/IViE/guide.html (last accessed 20/10/10)
(Will add the rest later.)
