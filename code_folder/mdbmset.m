function mdbmoptionspar=mdbmset(varargin)
%mdbmset  Create/alter MDBM OPTIONS structure.
%  Any unspecified properties have default values.
mdbmoptionspar.fvectorized=true;%//TODO: it is still not implemented!!! always true is assumed
mdbmoptionspar.isconstrained=false; %f provides contrain? all the constraints are combinded!!! length C===1
mdbmoptionspar.interporder=1; % order of interpolation0,1,2
%Note, if interporder==2 , then all the neighbours is needed in all 
% direction, so 'directionalneighbouronly' must be 0 and 'cornerneighbours'
%must be 1

mdbmoptionspar.bracketingdistance=2;
mdbmoptionspar.bracketingnorm=2;

mdbmoptionspar.checkneighbourinallsteps=false;%it is necessary to check the neighbour in all interation steps (usually not necessary, but in problematic cases, where the solution can be lost, it could be usefull)
mdbmoptionspar.checkneighbour=inf;%number of maxiam consequtive neighbour check
mdbmoptionspar.directionalneighbouronly=1;%if 1 only those neighbours are checked, where a signchange can be found, if 0 all the possible neighbour is chacked
mdbmoptionspar.connections=true;

mdbmoptionspar.zerotreshold=0.;%for degenerate cases it should be larger than, the numerical precision ~1e-15

mdbmoptionspar.cornerneighbours=false; %true - > corner neighbors is alaso given ; fase -> only the face (n-1 cube) neighbours are given
%if mdbmoptionspar.interporder>1, then mdbmoptionspar.cornerneighbours should be true!!!!!!!
%!!!!!!!!!!! mdbmoptions.cornerneighbours=mdbmoptions.interporder>1; !!!!!!!

mdbmoptionspar.refinetype='all';%'all''pos''grid''object''curvature' //see in refine.m
%TODO: 'object' sould be the defalut better????

mdbmoptionspar.Ncodim=[];

mdbmoptionspar.times.interpolating_cubes=0;
mdbmoptionspar.times.refine=0;
mdbmoptionspar.times.checkneighbour=0;
mdbmoptionspar.times.DTconnect=0;

mdbmoptionspar.times.functioneval=0;

mdbmoptionspar.timelimit=30;% [seconds] - the length of the next computation step is approximated, and if it is too large, then it is cancelled

% max number of function evaluation. The number of function call in the next step is approximated, and if it is too large, then the step is cancelled.
%(In this way,we can eliminate the step with too large memory consumption. Memory usage is proportional to this amount ~50-200 x larger is bytes)
mdbmoptionspar.funcallimit=1e5;

structfields={'fvectorized','isconstrained','interporder','bracketingdistance','bracketingnorm','checkneighbourinallsteps','checkneighbour','directionalneighbouronly',...
    'connections','zerotreshold','cornerneighbours','refinetype','Ncodim','timelimit','funcallimit'};
for k=1:2:length(varargin)
    
    if any(strcmp(varargin{k},structfields)) && (k+1)<=length(varargin)
        mdbmoptionspar.(structfields{strcmp(varargin{k},structfields)})=varargin{k+1};
    else
        warning(['The parameter "', varargin{k} ,'" is not found (or the parameter is missing). It is ignored. '])
    end
    
end

if mdbmoptionspar.interporder>1
    mdbmoptionspar.directionalneighbouronly=0;
    mdbmoptionspar.cornerneighbours=1;
end