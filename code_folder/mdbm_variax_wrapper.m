function mdbm_sols=mdbm_variax_wrapper(ax,variax,functionname,varargin)
mdbm_sols={};

    if length(varargin)<2
        isconstrained=false;
    else
        if isempty(varargin{2})
            isconstrained=false;
        else
            isconstrained=varargin{2}.isconstrained;
        end
    end

for k=1:length(variax)
    variaxlimits(k,:)=[min(variax(k).val),max(variax(k).val)];
end

Nax=length(ax);
Nvariax=length(variax);

%---------determinening the number of equations (co-dimension)
axtest1=zeros(Nax+Nvariax,1);
for kdim=1:length(ax)
    axtest1(kdim,1)=ax(1,kdim).val(1);
end
for kdim=1:length(variax)
    axtest1(kdim+Nax,1)=variax(1,kdim).val(1);
end
Ncodim=size(feval(functionname,axtest1,varargin{3:end}),1)-isconstrained;
%------------


%possible variation of the sweeping parameters
combinations=ind2sub_mdbm(1:3^Nvariax,3*ones(Nvariax,1))-2;%inside too
%assuring to create a codimension-1 problem
combinations=combinations(:,sum(combinations==0,1)>=(Ncodim-1));% ha ez nincs, akkor legfeljebb pontokat is v�gigsz�mol
%vagy az "alatti" objektumokat - teh�t elvben nem baj, csak �ppen a kezdeti
%h�l�t is v�gigsz�molja!!!

for kcomb=1:size(combinations,2)
    % for kcomb=size(combinations,2):-1:1
    axvariax=[ax,variax(combinations(:,kcomb)==0)];
    loccombinations=combinations(:,kcomb);
    
    extraparamindex=find(loccombinations==0);
    if sum(loccombinations==0)>(Ncodim-1)
        equationparameter=db_combnk(extraparamindex,sum(loccombinations==0));%-(Ncodim-1));
    else
        equationparameter=0;
    end
    
    localextraequations=equationparameter;
    
    view(2)
    %    title({kcomb;'-----------';loccombinations';localextraequations'})
    title({[num2str(kcomb),' / ',num2str(size(combinations,2))],num2str(loccombinations)'})
    %    drawnow;

    mdbm_sols{kcomb}=mdbm(axvariax,@wrapper,varargin{:});

    
    mdbm_sols{kcomb}=mdbm_pos_extension(mdbm_sols{kcomb});
    
    
    
    
    
    
    %    ourh=plot_mdbm(mdbm_sols{kcomb});
    %    set(ourh,'LineWidth',3);
    %    %    set(ourh,'EdgeColor','k');
    %    %    set(ourh,'Color','k');
    %    %    shading interp
    %    axis tight;
    %
    %    drawnow;
    
end

    function Hfunctionoutputvalues=wrapper(axvariax,varargin)
        axloc=axvariax(1:end-sum(loccombinations==0),:);%original axes
        knextvariax_index=0;
        Naparms=size(axloc,1);
        for kparam_type=1:length(loccombinations)%constructing the necceasry ax paramteres
            switch loccombinations(kparam_type)
                case 1
                    axloc(Naparms+kparam_type,:)=variaxlimits(kparam_type,1);
                case 0
                    knextvariax_index=knextvariax_index+1;
                    axloc(Naparms+kparam_type,:)=axvariax(Naparms+knextvariax_index,:);
                case -1
                    axloc(Naparms+kparam_type,:)=variaxlimits(kparam_type,2);
            end
        end
        
        Hfunctionoutputvalues=feval(functionname,axloc,varargin{:});
        if ~any(localextraequations==0)
            HfunctionoutputvaluesDELTA=zeros(0,size(Hfunctionoutputvalues,2));
            
            for kparam_extraeq=localextraequations'%adding the extra equations
                epsilon_parturbation=diff(variaxlimits(kparam_extraeq,:))*1e-5;
                axloc(Naparms+kparam_extraeq,:)=axloc(Naparms+kparam_extraeq,:)+epsilon_parturbation;%delat modification
                Hnew=feval(functionname,axloc,varargin{:});
                HfunctionoutputvaluesDELTA=cat(1,HfunctionoutputvaluesDELTA,(Hnew(1:end-isconstrained,:)-Hfunctionoutputvalues(1:end-isconstrained,:))/epsilon_parturbation);%the approximated derivative
                axloc(Naparms+kparam_extraeq,:)=axloc(Naparms+kparam_extraeq,:)-epsilon_parturbation;
            end
            
            %          added_fun_value=zeros(length(localextraequations),size(Hfunctionoutputvalues,2));
            added_fun_value=zeros(1,size(Hfunctionoutputvalues,2));
            for kallpoints=1:size(HfunctionoutputvaluesDELTA,2)
                A=reshape(HfunctionoutputvaluesDELTA(:,kallpoints),size(Hfunctionoutputvalues,1)-isconstrained,[]);
                for kparalleles=0:diff(size(A))
                    %added_fun_value(kparalleles,kallpoints)=prod(svd(A));
                    added_fun_value(kparalleles+1,kallpoints)=det(A(:,(1:size(A,1))+kparalleles));
                end
            end
            Hfunctionoutputvalues=cat(1,added_fun_value,Hfunctionoutputvalues);
        end
    end


    function mdbm_sparse=mdbm_pos_extension(mdbm_sparse)
        axloc=mdbm_sparse.ax(1:end-sum(loccombinations==0));
        posinterploc=mdbm_sparse.posinterp(1:end-sum(loccombinations==0),:);%original axes
        knextvariax_index=0;
        Naparms=size(posinterploc,1);
        for kparam_type=1:length(loccombinations)%constructing the necceasry ax paramteres
            switch loccombinations(kparam_type)
                case 1
                    posinterploc(Naparms+kparam_type,:)=variaxlimits(kparam_type,1);
                    axloc(Naparms+kparam_type).val=[variaxlimits(kparam_type,1),variaxlimits(kparam_type,1)]
                case 0
                    knextvariax_index=knextvariax_index+1;
                    posinterploc(Naparms+kparam_type,:)=mdbm_sparse.posinterp(Naparms+knextvariax_index,:);
                    axloc(Naparms+kparam_type)=mdbm_sparse.ax(Naparms+knextvariax_index);
                case -1
                    posinterploc(Naparms+kparam_type,:)=variaxlimits(kparam_type,2);
                    axloc(Naparms+kparam_type).val=[variaxlimits(kparam_type,2),variaxlimits(kparam_type,2)];
            end
        end
        
        mdbm_sparse.posinterp=posinterploc;
        mdbm_sparse.opt.Ndim=mdbm_sparse.opt.Ndim+size(loccombinations,1);
    end
end

