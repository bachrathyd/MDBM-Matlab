function graphandle=plot_mdbm(varargin)
%it polots the output of the db_mdbm function
% db_plot_mdbm(mdbm_sol)
%
% db_plot_mdbm(mdbm_sol,plotcolor)
% plotcolor='r'
% plotcolor='b'
%
% db_plot_mdbm(mdbm_sol,plotcolor,dimensionsorder)
% order of plotting:
% the dimensionsorder contains the dimenson with will be plotted along the x,y,z axes
%% e.g.:dimensionsorder=[3,1,2];
%
% db_plot_mdbm(mdbm_sol,plotcolor,dimensionsorder,plotobjdim)
% it defines the dimension of the plotting object
%   0 - points
%   1 - lines
%   2 - surfaces
%
% db_plot_mdbm(mdbm_sol,plotcolor,dimensionsorder,plotobjdim,gradplot)
% gradplot=false (0) - no gradient plot
% gradplot=true (1) - plot quiver with scalefactor 1
% gradplot=X (1.34) - plot quiver with scalefactor X (e.g.: 1.34)
%%
% db_plot_mdbm(mdbm_sol,plotcolor,dimensionsorder,plotobjdim,gradplot,originalax)
% set the majaor and minor axes based on the originalax and the final
% meshsize, respectively (if ~isempty(originalax))

% db_plot_mdbm(mdbm_sol,plotcolor,dimensionsorder,plotobjdim,gradplot,originalax,Numerofinterpolation)
% It devides each elements (line, triangle...) into Numerofinterpolation
% components for smoother plots if gradient is availble.
% Numerofinterpolation is 5 by defult
% Numerofinterpolation=0 - switch off the interpolation
%
graphandle=[];

mdbm_sol=varargin{1};

Ndim=mdbm_sol.opt.Ndim;
Ncodim=mdbm_sol.opt.Ncodim;


plotcolor=[];%default plot color and marker
if length(varargin)>1
    if ~isempty(varargin{2})
        plotcolor=varargin{2};
    end
    
end

dimensionsorder=1:(min(4,Ndim));
if length(varargin)>2
    if and(~isempty(varargin{3}),length(varargin{3})<=Ndim)
        dimensionsorder=varargin{3};
    end
    
end

%plotobjdims=mdbm_sol.opt.Ndim-mdbm_sol.opt.Ncodim; %min([length(dimensionsorder),length(mdbm_sol.DT),2]);
% plotobjdims=(mdbm_sol.opt.Ndim-mdbm_sol.opt.Ncodim):length(mdbm_sol.DT); %min([length(dimensionsorder),length(mdbm_sol.DT),2]);
plotobjdims=min([length(dimensionsorder),length(mdbm_sol.DT),mdbm_sol.opt.Ndim-mdbm_sol.opt.Ncodim,2]);
if length(varargin)>3 && ~isempty(varargin{4})
    %plotobjdim=min([plotobjdim,varargin{4}]);
    plotobjdims=varargin{4};
    if any(plotobjdims>length(mdbm_sol.DT))
        warning('For higher topologic-dimension plots, the corresponding evaluation of DTconnect is needed.')
        plotobjdims=plotobjdims(plotobjdims<=length(mdbm_sol.DT));
        warning(['Only dimensions [', num2str(plotobjdims) ,'] is/are used for plotting.'])
    end
end
for k=1:plotobjdims
    plotobjdims(isempty(mdbm_sol.DT{k}))=nan;
end
plotobjdims=plotobjdims(~isnan(plotobjdims));

gradplot=0;
if length(varargin)>4
    gradplot=varargin{5};
end

axticks=0;
if length(varargin)>5
    if ~isempty(varargin{6})
        originalax=varargin{6}(dimensionsorder);
        axticks=~isempty(originalax);
    end
end

Numerofinterpolation=5;
if length(varargin)>6
    if ~isempty(varargin{7})
        Numerofinterpolation=varargin{7};
    end
end
for plotobjdim=plotobjdims
    
    % % NOW THE INTERPOLATED OBJECTS ARE PLOTTED BY DEFAULT!
    % %  <<<<<<<<<<<<<<<< YOU CAN REMOVE THIS PART >>>>>>>>>>>>>>>>>>>
    if all([mdbm_sol.opt.interporder>0,plotobjdim>0,mdbm_sol.opt.Ndim-mdbm_sol.opt.Ncodim>0,gradplot==0,~isfield(mdbm_sol,'DTbezier'),Numerofinterpolation>0])
        %disp('Note, now, the intarpolated result is plotted by default!')
        %disp('You can remove this part in the plot_mdbm.m file!')
        mdbm_sol=interpplot(mdbm_sol,Numerofinterpolation,plotobjdim);%now, a default 5 interpolatation of the data is used to provide a better graph
    end
    % %  <<<<<<<<<<<<<<<< YOU CAN REMOVE THIS PART >>>>>>>>>>>>>>>>>>>
    
    
    if isfield(mdbm_sol,'DTbezier')
        mdbm_sol.DT=mdbm_sol.DTbezier;
        mdbm_sol.posinterp=mdbm_sol.posbezier;
    end
    
    
    
    DT0=1:size(mdbm_sol.posinterp,2);
    if length(plotobjdims)>1
        hold on
        DT0=DT0(~ismember(DT0,mdbm_sol.DT{1}(:)));
        
        mdbm_sol.DT{1}=mdbm_sol.DT{1}(~ismember(mdbm_sol.DT{1},[mdbm_sol.DT{2}(:,[1,2]);mdbm_sol.DT{2}(:,[2,3]);mdbm_sol.DT{2}(:,[1,3])], 'rows'),:);
        %higher order is ignored, hence, we cannot plot it
    end
    
    
    
    
    switch Ndim%length(dimensionsorder)
        case 1
            
            switch plotobjdim
                case 0 %points
                    graphandle=plot(mdbm_sol.posinterp(DT0),mdbm_sol.posinterp(DT0)*0,[plotcolor,'.']);
                    axis([min(mdbm_sol.ax(1).val),max(mdbm_sol.ax(1).val),-1,1])
                    xlabel([num2str(dimensionsorder(1)),'. parameter'])
                case 1   %lines  //degenerate
                    if isempty(plotcolor)
                        graphandle=trimesh(mdbm_sol.DT{1},mdbm_sol.posinterp(1,:),mdbm_sol.posinterp(1,:)*0,mdbm_sol.posinterp(1,:)*0);
                    else
                        graphandle=trimesh(mdbm_sol.DT{1},mdbm_sol.posinterp(1,:),mdbm_sol.posinterp(1,:)*0,mdbm_sol.posinterp(1,:)*0,'EdgeColor',plotcolor);
                    end
            end
            if gradplot
                hold on
                colorsgrad='krgbymc';
                for k=1:Ncodim
                    gradvect=permute(mdbm_sol.gradient(:,k,:),[1,3,2]);
                    graphandle(2)=quiver(mdbm_sol.posinterp(1,DT0),mdbm_sol.posinterp(1,DT0)*0,...
                        gradvect(1,DT0),gradvect(1,DT0)*0,gradplot,colorsgrad(mod(k-1,7)+1));
                end
            end
            if axticks
                plotax = gca;
                xticks(originalax(1).val);
                plotax.XAxis.MinorTick = 'on';
                plotax.XMinorGrid = 'on';
                plotax.XAxis.MinorTickValues = mdbm_sol.ax(1).val;
            end
        case 2
            
            switch plotobjdim
                case 0%points
                    graphandle=plot(mdbm_sol.posinterp(1,DT0),mdbm_sol.posinterp(2,DT0),[plotcolor,'.']);
                case 1   %lines
                    if isempty(plotcolor)
                        graphandle=trimesh(mdbm_sol.DT{1},mdbm_sol.posinterp(1,:),mdbm_sol.posinterp(2,:),mdbm_sol.posinterp(2,:)*0);
                    else
                        graphandle=trimesh(mdbm_sol.DT{1},mdbm_sol.posinterp(1,:),mdbm_sol.posinterp(2,:),mdbm_sol.posinterp(2,:)*0,'EdgeColor',plotcolor);
                    end
                case 2 %surface //degenerate
                    if isempty(plotcolor)
                        graphandle=trisurf(mdbm_sol.DT{2},mdbm_sol.posinterp(1,:),mdbm_sol.posinterp(2,:),mdbm_sol.posinterp(2,:)*0);
                    else
                        %graphandle=trisurf(mdbm_sol.DT{2},mdbm_sol.posinterp(1,:),mdbm_sol.posinterp(2,:),mdbm_sol.posinterp(2,:)*0,'EdgeColor','none','FaceColor',plotcolor);
                        graphandle=trisurf(mdbm_sol.DT{2},mdbm_sol.posinterp(1,:),mdbm_sol.posinterp(2,:),mdbm_sol.posinterp(2,:)*0,'EdgeColor',plotcolor,'FaceColor',plotcolor);
                    end
                    
            end
            
            xlabel([num2str(dimensionsorder(1)),'. parameter'])
            ylabel([num2str(dimensionsorder(2)),'. parameter'])
            axis([min(mdbm_sol.ax(1).val),max(mdbm_sol.ax(1).val),min(mdbm_sol.ax(2).val),max(mdbm_sol.ax(2).val)])
            
            if axticks
                plotax = gca;
                xticks(originalax(1).val);
                yticks(originalax(2).val);
                plotax.XAxis.MinorTick = 'on';
                plotax.XMinorGrid = 'on';
                plotax.XAxis.MinorTickValues = mdbm_sol.ax(1).val;
                
                plotax.YAxis.MinorTick = 'on';
                plotax.YMinorGrid = 'on';
                plotax.YAxis.MinorTickValues = mdbm_sol.ax(2).val;
            end
            
            if gradplot
                hold on
                colorsgrad='krgbymc';
                for k=1:Ncodim
                    gradvect=permute(mdbm_sol.gradient(:,k,:),[1,3,2]);
                    graphandle(end+1)=quiver(mdbm_sol.posinterp(1,:),mdbm_sol.posinterp(2,:),...
                        gradvect(1,:),gradvect(2,:),gradplot,colorsgrad(mod(k-1,7)+1));
                    
                end
            end
        case 3
            switch plotobjdim
                case 0 %points
                    graphandle=plot3(mdbm_sol.posinterp(1,DT0),mdbm_sol.posinterp(2,DT0),mdbm_sol.posinterp(3,DT0),[plotcolor,'.']);
                case 1 %lines
                    if isempty(plotcolor)
                        graphandle=trimesh(mdbm_sol.DT{1},mdbm_sol.posinterp(1,:),mdbm_sol.posinterp(2,:),mdbm_sol.posinterp(3,:));
                    else
                        graphandle=trimesh(mdbm_sol.DT{1},mdbm_sol.posinterp(1,:),mdbm_sol.posinterp(2,:),mdbm_sol.posinterp(3,:),'EdgeColor',plotcolor);
                    end
                case 2 %surface
                    if isempty(plotcolor)
                        graphandle=trisurf(mdbm_sol.DT{2},mdbm_sol.posinterp(1,:),mdbm_sol.posinterp(2,:),mdbm_sol.posinterp(3,:));
                        %                         graphandle=trisurf(mdbm_sol.DT{2},mdbm_sol.posinterp(1,:),mdbm_sol.posinterp(2,:),mdbm_sol.posinterp(3,:),mdbm_sol.curvnorm)
                    else
                        %graphandle=trisurf(mdbm_sol.DT{2},mdbm_sol.posinterp(1,:),mdbm_sol.posinterp(2,:),mdbm_sol.posinterp(3,:),'EdgeColor','none','FaceColor',plotcolor);
                        graphandle=trisurf(mdbm_sol.DT{2},mdbm_sol.posinterp(1,:),mdbm_sol.posinterp(2,:),mdbm_sol.posinterp(3,:),'EdgeColor',plotcolor,'FaceColor',plotcolor);
                    end
            end
            
            
            
            xlabel([num2str(dimensionsorder(1)),'. parameter'])
            ylabel([num2str(dimensionsorder(2)),'. parameter'])
            zlabel([num2str(dimensionsorder(3)),'. parameter'])
            axis([min(mdbm_sol.ax(1).val),max(mdbm_sol.ax(1).val),min(mdbm_sol.ax(2).val),max(mdbm_sol.ax(2).val),min(mdbm_sol.ax(3).val),max(mdbm_sol.ax(3).val)])
            
            if axticks
                plotax = gca;
                xticks(originalax(1).val);
                yticks(originalax(2).val);
                zticks(originalax(3).val);
                plotax.XAxis.MinorTick = 'on';
                plotax.XMinorGrid = 'on';
                plotax.XAxis.MinorTickValues = mdbm_sol.ax(1).val;
                
                plotax.YAxis.MinorTick = 'on';
                plotax.YMinorGrid = 'on';
                plotax.YAxis.MinorTickValues = mdbm_sol.ax(2).val;
                
                plotax.ZAxis.MinorTick = 'on';
                plotax.ZMinorGrid = 'on';
                plotax.ZAxis.MinorTickValues = mdbm_sol.ax(3).val;
            end
            
            if gradplot
                hold on
                colorsgrad='krgbymc';
                for k=1:Ncodim
                    gradvect=permute(mdbm_sol.gradient(:,k,:),[1,3,2]);
                    graphandle(end+1)=quiver3(mdbm_sol.posinterp(1,:),mdbm_sol.posinterp(2,:),mdbm_sol.posinterp(3,:),...
                        gradvect(1,:),gradvect(2,:),gradvect(3,:),gradplot,colorsgrad(mod(k-1,7)+1));
                    
                end
            end
            
        otherwise %(4,5,6...) we cannot plot in higer dimensions (or it is pointles)
            switch plotobjdim
                case 0 %points
                    graphandle=plot3(mdbm_sol.posinterp(1,:),mdbm_sol.posinterp(2,:),mdbm_sol.posinterp(3,:),[plotcolor,'.']);
                case 1 %lines
                    if isempty(plotcolor)
                        graphandle=trimesh(mdbm_sol.DT{1},mdbm_sol.posinterp(1,:),mdbm_sol.posinterp(2,:),mdbm_sol.posinterp(3,:),mdbm_sol.posinterp(4,:));
                        c=colorbar('southoutside');
                        c.Label.String=[num2str(dimensionsorder(4)),'. parameter'];
                    else
                        graphandle=trimesh(mdbm_sol.DT{1},mdbm_sol.posinterp(1,:),mdbm_sol.posinterp(2,:),mdbm_sol.posinterp(3,:),'EdgeColor',plotcolor);
                    end
                    
                case 2 %surface
                    if isempty(plotcolor)
                        graphandle=trisurf(mdbm_sol.DT{2},mdbm_sol.posinterp(1,:),mdbm_sol.posinterp(2,:),mdbm_sol.posinterp(3,:),mdbm_sol.posinterp(4,:));
                        c=colorbar('southoutside');
                        c.Label.String=[num2str(dimensionsorder(4)),'. parameter'];
                    else
                        graphandle=trisurf(mdbm_sol.DT{2},mdbm_sol.posinterp(1,:),mdbm_sol.posinterp(2,:),mdbm_sol.posinterp(3,:),'EdgeColor','none','FaceColor',plotcolor);
                    end
                    %             graphandle=tetramesh(mdbm_sol.DT{3},mdbm_sol.posinterp(1:4,:)');
            end
            
            
            
            xlabel([num2str(dimensionsorder(1)),'. parameter'])
            ylabel([num2str(dimensionsorder(2)),'. parameter'])
            zlabel([num2str(dimensionsorder(3)),'. parameter'])
            axis([min(mdbm_sol.ax(1).val),max(mdbm_sol.ax(1).val),min(mdbm_sol.ax(2).val),max(mdbm_sol.ax(2).val),min(mdbm_sol.ax(3).val),max(mdbm_sol.ax(3).val)])
            if axticks
                plotax = gca;
                xticks(originalax(1).val);
                yticks(originalax(2).val);
                zticks(originalax(3).val);
                plotax.XAxis.MinorTick = 'on';
                plotax.XMinorGrid = 'on';
                plotax.XAxis.MinorTickValues = mdbm_sol.ax(1).val;
                
                plotax.YAxis.MinorTick = 'on';
                plotax.YMinorGrid = 'on';
                plotax.YAxis.MinorTickValues = mdbm_sol.ax(2).val;
                
                plotax.ZAxis.MinorTick = 'on';
                plotax.ZMinorGrid = 'on';
                plotax.ZAxis.MinorTickValues = mdbm_sol.ax(3).val;
            end
            if gradplot
                hold on
                colorsgrad='krgbymc';
                for k=1:Ncodim
                    gradvect=permute(mdbm_sol.gradient(:,k,:),[1,3,2]);
                    graphandle(end+1)=quiver3(mdbm_sol.posinterp(1,:),mdbm_sol.posinterp(2,:),mdbm_sol.posinterp(3,:),...
                        gradvect(1,:),gradvect(2,:),gradvect(3,:),gradplot,colorsgrad(mod(k-1,7)+1));
                    
                end
            end
            
    end
end

grid on