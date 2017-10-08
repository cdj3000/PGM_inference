%CLIQUETREECALIBRATE Performs sum-product or max-product algorithm for 
%clique tree calibration.

%   P = CLIQUETREECALIBRATE(P, isMax) calibrates a given clique tree, P 
%   according to the value of isMax flag. If isMax is 1, it uses max-sum
%   message passing, otherwise uses sum-product. This function 
%   returns the clique tree where the .val for each clique in .cliqueList
%   is set to the final calibrated potentials.
%
% Copyright (C) Daphne Koller, Stanford University, 2012

function P = CliqueTreeCalibrate(P, isMax)


% Number of cliques in the tree.
N = length(P.cliqueList);

% Setting up the messages that will be passed.
% MESSAGES(i,j) represents the message going from clique i to clique j. 
MESSAGES = repmat(struct('var', [], 'card', [], 'val', []), N, N);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% We have split the coding part for this function in two chunks with
% specific comments. This will make implementation much easier.
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% YOUR CODE HERE
% While there are ready cliques to pass messages between, keep passing
% messages. Use GetNextCliques to find cliques to pass messages between.
% Once you have clique i that is ready to send message to clique
% j, compute the message and put it in MESSAGES(i,j).
% Remember that you only need an upward pass and a downward pass.
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 if isMax!=1,
    while sum(GetNextCliques(P, MESSAGES))!=0,
	
	    [indexa indexb] =GetNextCliques(P, MESSAGES);
		%%% next message tobe reocorded is      indexa----->indexb
		temp_list1=MESSAGES(:,indexa);
		
		
		temp_list1(indexa)=struct('var', [], 'card', [], 'val', []);
		temp_list1(indexb)=struct('var', [], 'card', [], 'val', []);
		%%% replace indexa and indexb with empty
		
		
		temp_length=0; 
		
		temp_check_index=[];
		for i=1:length(temp_list1),
		
		    if length(temp_list1(i).var)!=0,
			    temp_length+=1;
				temp_check_index=[temp_check_index i];
			end;
		end;
		
		%%% temp_check_index is index for messages.
		
		if  temp_length==0,
		    temp_product=P.cliqueList(indexa);
		%%% i is a end node,ready to marginalize
		else
		%%% i is not a end node, and ready to marginalize
		    temp_product = struct('var', [], 'card', [], 'val', []);
			temp_product=  P.cliqueList(indexa);
			
		    for i=1:temp_length,
			
			  temp_massage= temp_list1(temp_check_index(i));
			  temp_massage.val= temp_massage.val/sum(temp_massage.val);
			
			  temp_product = FactorProduct( temp_massage, temp_product );
			%temp_product= FactorProduct(temp_list1(temp_check_index(i)), temp_product );
			
			end;
		end;
		
		[variables_sumed_out, map_]=setdiff(P.cliqueList(indexa).var,  P.cliqueList(indexb).var);
		
	    MESSAGES(indexa,indexb)= FactorMarginalization(temp_product,  variables_sumed_out );
		
    end;
  
		%MESSAGES(indexa,indexb).val= MESSAGES(indexa,indexb).val/(sum(MESSAGES(indexa,indexb).val));
		
		
		
			

	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % YOUR CODE HERE_____compute_belief

    for i=1:length(P.cliqueList),
	    messages_list= MESSAGES(:,i);
        messages_list(i)=struct('var', [], 'card', [], 'val', []);
        temp_list_z=[];
        for j=1:length(messages_list),
	
	        if length(messages_list(j).var)!=0,
		        
		        temp_list_z=[temp_list_z j];
		    end;
	    end;
	
         %%temp_list is index for ith messages_list has value
        temp_product_10=P.cliqueList(i);
	    for k=1:length(temp_list_z),
	
	        temp_massage_2= messages_list(temp_list_z(k));
		
		    %temp_massage_2.val = temp_massage_2.val/sum(temp_massage_2.val);
		
	        temp_product_10= FactorProduct( temp_massage_2 , temp_product_10);
	    end;
	    P.cliqueList(i)=temp_product_10;
        P.cliqueList(i).val=P.cliqueList(i).val/sum(P.cliqueList(i).val);
    end;
end;
		





% Now the clique tree has been calibrated. 
% Compute the final potentials for the cliques and place them in P.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



return
