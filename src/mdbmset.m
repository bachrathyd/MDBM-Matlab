function mdbmoptionspar=mdbmset(varargin)
%mdbmset  Create/alter MDBM OPTIONS structure.
%
%   OPTS = mdbmset('field1', value1, 'field2', value2, ...) creates an 
%   options structure with the specified parameters.
%
%   Each field in the OPTIONS structure significantly impacts the solver's 
%   behavior, robustness, and performance. Below is a detailed description 
%   of each parameter and where to find demonstrations of their effects:
%
%   fvectorized - (Boolean) [Default: true]
%       Currently always assumed to be true. The solver expects the user 
%       function to accept a matrix of points and return a matrix of values.
%
%   isconstrained - (Boolean) [Default: false]
%       If true, the last equation in the function output is treated as 
%       a domain constraint. Solutions are only valid where this value is 
%       positive.
%       Demo: features/constrained_problems_simple.m, 
%             features/constrained_problems_complex.m
%
%   interporder - (0, 1, or 2) [Default: 1]
%       Order of root interpolation within a grid cell. 
%       0: No interpolation (returns the grid point closest to the root).
%       1: Linear interpolation (standard).
%       2: Quadratic interpolation (smoother, higher accuracy).
%       Demo: features/interpolation_order.m
%
%   bracketingdistance - (Positive Double) [Default: 2]
%       Relative distance (in grid units) used to identify if an n-cube 
%       contains a root (bracketing). Larger values make the solver more 
%       robust to non-smoothness but increase computation time.
%       Demo: features/bracketing_ncube_detection.m
%
%   bracketingnorm - (Positive Double) [Default: 2]
%       The p-norm used for the bracketing distance calculation.
%       Demo: features/bracketing_ncube_detection.m
%
%   checkneighbourinallsteps - (Boolean) [Default: false]
%       If true, the neighbor check logic is executed at every iteration. 
%       Essential for discovering disconnected solution branches.
%       Demo: features/neighbor_check_demo.m
%
%   checkneighbour - (Double/Inf) [Default: Inf]
%       Limits the number of consecutive neighbor check steps.
%       Demo: features/neighbor_check_demo.m
%
%   directionalneighbouronly - (Boolean) [Default: true]
%       If true, only checks neighbors in directions where the function 
%       gradient suggests a root might exist.
%       Demo: features/neighbor_check_demo.m
%
%   connections - (Boolean) [Default: true]
%       If true, calculates the Delaunay connectivity needed for 
%       visualizing surfaces and curves.
%       Demo: features/connection_of_points_to_simplex.m
%
%   zerotreshold - (Positive Double) [Default: 0]
%       Value below which a function evaluation is considered exactly zero. 
%       Crucial for handling degenerate or non-smooth functions.
%       Demo: features/degenerate_function_1.m
%
%   cornerneighbours - (Boolean) [Default: false]
%       If true, includes diagonal neighbors in the search. Automatically 
%       set to true if interporder > 1.
%       Demo: features/interpolation_order.m
%
%   refinetype - ('all', 'pos', 'grid', 'object', 'curvature') [Default: 'all']
%       Determines which cells are refined in the next step.
%       'all': Standard bisection (refine all cells with roots).
%       'pos': Refine only within a specific coordinate range.
%       'object': Refine only specific solution branches.
%       Demo: features/local_refinement_nonsmooth_mandelbrot.m
%
%   Ncodim - (Integer) [Default: []]
%       Manually specifies the number of equations if it cannot be 
%       automatically determined.
%
%   timelimit - (Seconds) [Default: 30]
%       Maximum time allowed for a single refinement step.
%       Demo: case_studies/Delay_Mathieu_simulation_based_stability_chart/...
%
%   funcallimit - (Integer) [Default: 1e5]
%       Safety limit for the number of function evaluations to prevent 
%       memory exhaustion.

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