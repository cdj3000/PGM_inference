%COMPUTEEXACTMARGINALSBP Runs exact inference and returns the marginals
%over all the variables (if isMax == 0) or the max-marginals (if isMax == 1). 
%
%   M = COMPUTEEXACTMARGINALSBP(F, E, isMax) takes a list of factors F,
%   evidence E, and a flag isMax, runs exact inference and returns the
%   final marginals for the variables in the network. If isMax is 1, then
%   it runs exact MAP inference, otherwise exact inference (sum-prod).
%   It returns an array of size equal to the number of variables in the 
%   network where M(i) represents the ith variable and M(i).val represents 
%   the marginals of the ith variable. 
%
% Copyright (C) Daphne Koller, Stanford University, 2012


function M = ComputeExactMarginalsBP(F, E, isMax)

% initialization
% you should set it to the correct value in your code
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% YOUR CODE HERE
%create clique tree
clique_tree= CreateCliqueTree(F,E);
if isMax==0,
final_tree=  CliqueTreeCalibrate(clique_tree, 0);
else
final_tree=  CliqueTreeCalibrate(clique_tree, 1);
end;

N=length(final_tree.cliqueList);
var_num_list=[];


for i=1:N,
var_num_list=[var_num_list  final_tree.cliqueList(i).var];
end;

num=length(unique(var_num_list));

M= repmat(struct('var', [], 'card', [], 'val', []),num,1);



for i=1:length(final_tree.cliqueList),
    var_temp= [];
    var_temp= final_tree.cliqueList(i).var;
	
	for j=1:length(var_temp);
	    var_now= var_temp(j);
	    %% if var is not marginalized, we compute marginalization
	    if length(M(var_now).var)==0,
		   [variables_out, map_out]= setdiff( var_temp, var_now);
		   if isMax==0,
		   M(var_now)=FactorMarginalization( final_tree.cliqueList(i),  variables_out );
		   M(var_now).val=M(var_now).val/sum(M(var_now).val);
		   else
		   M(var_now)=FactorMaxMarginalization( final_tree.cliqueList(i),  variables_out );
		   
		   end;
		end;
	end;
end;
		    
	
    

% Implement Exact and MAP Inference.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

end
