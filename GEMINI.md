Now I have finnished the update of my MDBM matlab method. 
-Do not chage any of the exsisting m files in the foldres: "src" "case_studies" "exampels" "feature" and "templates"

Before I upload it to the GitHub and File exchange. I would like to make a proper documnetation in Markdown and in Latex (Overleaf compatiblve).
The is the description now in Fileexchange. I need to udapte it:
"
Multi-Dimensional Bisection Method (MDBM) finds all the solutions/roots of a system of implicit equations efficiently, where the number of unknowns is larger than the number of equations.

This function is an alternative to the contourplot or the isosurface in higher dimensions (higher number of parameters). The main advantage: it can handle multiple functions. (contour plot or the isosurface can handle scalar values only)
In addition, MDBM uses much less function evaluation than the brute-force method, so for complex tasks, it is much faster and uses far less memory.

Extensive examples can be found in the "examples" folder
Run the "runme_run_all_the_exmaples.m" file here.
The "run_test_...." files should be tested. Don't forget to add the "code_folder" to the path, in which the main code files can be found.
Unfortunately, the documentation was written for an old version, so please, read the comments in these example files to understand the special function in the method and learn the 'best practice'. In this way, you can finetune it for your special needs.
Be sure to check the possible options defined by the mdbmoptions=mdbmset(). (Note, if an option is not commented, then it is just an internal variable.)

Note 1: As a consequence of the change in the "vectorized +" function, The MDBM is compatible with the newer Matlab versions only.
Note 2: I would protect my work, thus I use '*.p' files (some of you may dislike it, sorry).
In my opinion, the code is far too long and far too complex to understand. I spent more than 10 years on it, and sometimes it is hard even for me to understand the code (I am bad at commenting, I am a mechanical engineer and not a professional programmer :-) ).
But those files, which might be needed to modify for special needs are '*.m' file. And If you have any question or problems you can easily find me!

Cite As
Bachrathy, Daniel, and Gabor Stepan. “Bisection Method in Higher Dimensions and the Efficiency Number.” Periodica Polytechnica Mechanical Engineering, vol. 56, no. 2, Periodica Polytechnica Budapest University of Technology and Economics, 2012, p. 81, doi:10.3311/pp.me.2012-2.01.
"

The laex version should have its own folder inside the documentation folder.
The readme.md is placed in the documentation folder

You can also find a deprecated_MDBM_users_guide_for_v0_5.pdf (which is almost 10 years old), You can use this format it stly would be acceptable. Note, that many part of this documentattion is deprectad (it belongs to a very old initial version).

In the new version, In a short quick how-to-use. we should introduce the main features and options.

- IMPORTANT: all files (mehthod) in the src folder must be stated and described in details in the latex and in the readme.md file(you should create the description based on the usage in the folders "case_studies" "exampels" "feature" and "templates")

Add a detailed description to them (If you cannot fifure out proper description, then still keep it in the text and I will do the description later).

- IMPORTANT: Add an important section to the mdbmset.m file. after the main usega
each filed of this struct is important and its effect must be explained. Some of them is used in the folders "case_studies" "exampels" "feature" and "templates" to demonstrate the effect. You should list these file whenn you discuss the effects.

You should also add a folder with some short description of the files in the folder
"templates" -  can be used for to initialize a new mdbm project
"feature"- show the basic usege and the method of the mdbm ecosystem
"exampels" - show more interisting applications
"case_studies" - typicaly replication of scientific problems in the literature (or analogues problems)
You can put the short description after the qucik usage, and a detailed of each files in the appendix.

The content quatly between the original: deprecated_10y_old_MDBM_users_guide_for_v0_5.pdf and the pdf and readme.md file should be similar. I would like to keep that same quality and content. Please copy as much description as possible from the original pfd (how to use par as an inpt), (how the Niteration affect the resolution and the number of evaluated points - you might refer to the original article about the mehtod). Don't just add a few picures as a galery (we can keep it in the pfornt page as an advertismenet), but I need a detaild descriptino of ALL the files in the given folder, and with the correspoing figeur of ALL of them!

I think it would be nice to present the pictures generated in matlab in the documnets. For this I would need a "m" file (which runs all the necessary files and save the correspoing images in the documnetation figures foldre). In this way I should not need to change anything the m files. In the documentation you should refres to these files (and will generate them later or you can generate them by running this m file in matlab from command line).

For the figure generation. The legens appers next to the figure thus the subplots are very compressed. I would like to have the lagend above the figures. Please check all the m file for the legend
   definition and add ",'Location','northeast'" (or similar if needed) to place the legend on the to.

There should be a documentation forer, in which I should have a marknown file and a pdf (with similar content). the pdf is should be generated by a (overleaf compatile) latex files, which are placed in a subfolder of the documentaion folder.
The figures generated should be placed in a "figures" folder inside the documentation folder 

(For p files, make the desciption as you can based on the used, and flag if we have some ambiguous thing - I will extend the description later)

The description should contain a History section (before the appendix maybe? it is not that important:) Copy the main correspoinnd thing for the pervouse description.
We should add:
History section (use my tone, and keep close to my words - only reprase them):
-the core idea is occured duinr my MSc theis (written in Bristol university Erasmus - Thank you for that) at 2006. It ws updated in larger and smaller burst though the last 20 years. Leading to my most cited paper.
-The motivation was the soltuion of the charateristic equation of a DDE in which we have 2+1 parameters and 2 equatio (real and imaginary part of the char.eq.) And there was no direct method at that time to solve it automaticall, in a robust way, and detecing closed manifods for non-differnatiable functions. And as far as i know still ther is non of them. (for known alternatives are linsted in the introductions.)

In the Disclamer section:
(TODO: stay close my languge style)
we should add the description about the p files 
We should state that a newer version is availabe in Julia. Althog not all the feature available in Matlab version is migrated to Julia version (due to that they are not the crutional) they have similar capabilityes. However, currently onyl the Julia version is mantian, uptated and developer. So, there greate features will comes. The sub-cube interpolation is already availble and the error based non-uniform refinement ("best and most needed feature ever" : {TODO use these words exactly}) is already in a usable beta version.

Know Alternatives:
(TODO: here you can exted this desctiption, more details, and info(and linkes) from the web)
- Mathematica do the contour plot by interatively refie the grid (traingel based) which is simiar to my method, As far I know , it do it in 3D too. However it can handel only one equation (this is the easy problem)
- There are version in which you solve first equation in higher dimension, then triangulat it, and solve the second equation on that, and repet. It creates a robust solution, however the complexity it very-very high. (almost just the same as the brute force)
- The are method, which provides garantied soltuion (In MDBM, it is inevitable that a piece of the solution will be lost in higher dimensions - in contrast to the tradition 1D bisectino problem ). See: the great works of P. Sander: Intervall arithmetic (TODO: add some reference and description to his work)
(- TODO: If you can find some more alternative you can add it here)