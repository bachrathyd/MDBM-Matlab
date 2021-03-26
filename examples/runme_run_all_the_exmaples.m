%runall
close all
clear all
clc
waitfor(msgbox('Be sure to add the path of the code folder (use ''addpath'')'))
waitfor(msgbox('Follow the comments in the code of each example to learn the ''best preactice''.'))
waitfor(msgbox('This should be less than 10 min (if you just walk trhogh). Note, at some point you have to push a button to continue (watch the titles of the figures)!'))

files_to_run=dir;
for kfiles=3:length(files_to_run)
    disp(files_to_run(kfiles).name)
    if files_to_run(kfiles).name(1:4)>0
        if strcmp(files_to_run(kfiles).name(1:4),'run_')
            waitfor(msgbox(['Press OK for the next example: ',files_to_run(kfiles).name]))
            close all
            clc
            eval(files_to_run(kfiles).name(1:end-2))
        end
    end
end