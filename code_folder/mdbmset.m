function mdbmoptionspar=mdbmset(varargin)
%mdbmset  Create/alter MDBM OPTIONS structure.
%  Any unspecified properties have default values.
mdbmoptionspar.fvectorized=true;%//TODO: it is still not implemented!!! always true is assumed
mdbmoptionspar.isconstrained=false; %f provides contrain? all the constraints are combinded!!! length C===1
mdbmoptionspar.interporder=1; % order of interpolation0,1,2


mdbmoptionspar.bracketingdistance=2;
mdbmoptionspar.bracketingnorm=2;

mdbmoptionspar.checkneighbour=inf;%number of maxiam consequtive neighbour check
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



mdbmoptionspar.dodisplay=1;% - 1 (true) show the details of the computation, 0 (false) show no details



structfields={'fvectorized','isconstrained','interporder','bracketingdistance','bracketingnorm','checkneighbour',...
    'connections','zerotreshold','cornerneighbours','refinetype','Ncodim','timelimit','funcallimit','dodisplay'};
for k=1:2:length(varargin)
    
    if any(strcmp(varargin{k},structfields)) && (k+1)<=length(varargin)
        mdbmoptionspar.(structfields{strcmp(varargin{k},structfields)})=varargin{k+1};
    else
        warning(['The parameter "', varargin{k} ,'" is not found (or the parameter is missing). It is ignored. '])
    end
    
end