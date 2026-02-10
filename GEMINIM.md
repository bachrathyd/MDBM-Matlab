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
put the updated version in FileExchange.md file next to the README.md .
There is a short README.md file.  I think it is ok for starting but we need a much more detailed version (or extension of it with subsections.)

The laex version should have its own folder.

You can also find a deprecated_MDBM_users_guide_for_v0_5.pdf (which is almost 10 years old), You can use this format it stly would be acceptable. Note, that many part of this documentattion is deprectad (it belongs to a very old initial version).

In the new version, In a short quick how-to-use. we should introduce the main features and options.

all files (mehthod) in the src folder must be stated (you should create the descroiption based on the usage in the folders "case_studies" "exampels" "feature" and "templates")

Add a detailed description to them (If you cannot fifure out proper description, then still keep it in the text and I will do the description later).

Add an important section to the mdbmset.m file. 
each filed of this struct is important and its effect must be explained. Some of them is used in the folders "case_studies" "exampels" "feature" and "templates" to demonstrate the effect. You should list these file whenn you discuss the effects.

You should also add a folder with some short description of the files in the folder
"templates" -  can be used for to initialize a new mdbm project
"feature"- show the basic usege and the method of the mdbm ecosystem
"exampels" - show more interisting applications
"case_studies" - typicaly replication of scientific problems in the literature (or analogues problems)
You can put the short description after the qucik usage, and a detailed of each files in the appendix.

I think it would be nice to present the pictures generated in matlab in the documnets. For this I would need a "m" file (which runs all the necessary files and save the correspoing images in the documnetation figures foldre). In this way I should not need to change anything the m files. In the documentation you should refres to these files (and will generate them later or you can generate them by running this m file in matlab from command line).