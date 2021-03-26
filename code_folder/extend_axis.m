function mdbm_sol=extend_axis(mdbm_sol,axis_index,ax_before, ax_after)
% The axis is exteded by the vectors 'before' and the vectors 'after':
% formally:
% mdbm_sol.ax(axis_index).val=[ax_before(:).',mdbm_sol.ax(axis_index).val,ax_after(:).']
%
% The function handels the correspinding changes in the indexes
%
% Note, thet the monotonicity is not check, it must be done
% by the user.
% eg.: be sure, that the connected valuse do not repeates the value at the
% connection.

if any([axis_index<1,axis_index>length(mdbm_sol.ax)])
    error('The axis index refers to a non-exsisting axis.')
end

newaxis=[ax_before(:).',mdbm_sol.ax(axis_index).val,ax_after(:).'];
mdbm_sol.ax(axis_index).val=newaxis;

if any( [  all(diff(newaxis)>0) ,  all(diff(newaxis)<0) ])%monoton increase or decrease
    warning('The new axis is no monitonic!!!')
end

mdbm_sol.ncubevect(axis_index)=mdbm_sol.ncubevect(axis_index)+length(ax_before);
mdbm_sol.vectindex(axis_index)=mdbm_sol.vectindex(axis_index)+length(ax_before);


Ndim=mdbm_sol.opt.Ndim;
%% computing the length of the axeses, and indexes in advance
mdbm_sol.opt.NaxN=zeros(Ndim,1);
for kdim=1:Ndim
    mdbm_sol.opt.NaxN(kdim)=length(mdbm_sol.ax(kdim).val);
end
%initialization, fot the functions ind2sub_mdbm and sub2ind_mdbm
%the distances in the linear indexing
mdbm_sol.opt.NaxNprod=[1;cumprod(mdbm_sol.opt.NaxN(1:end-1))];



mdbm_sol.ncubelin=sub2ind_mdbm(mdbm_sol.ncubevect,mdbm_sol.opt.NaxN);
mdbm_sol.linindex=sub2ind_mdbm(mdbm_sol.vectindex,mdbm_sol.opt.NaxN);

end


