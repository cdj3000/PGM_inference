%GETNEXTCLIQUES Find a pair of cliques ready for message passing
%   [i, j] = GETNEXTCLIQUES(P, messages) finds ready cliques in a given
%   clique tree, P, and a matrix of current messages. Returns indices i and j
%   such that clique i is ready to transmit a message to clique j.
%
%   We are doing clique tree message passing, so
%   do not return (i,j) if clique i has already passed a message to clique j.
%
%	 messages is a n x n matrix of passed messages, where messages(i,j)
% 	 represents the message going from clique i to clique j. 
%   This matrix is initialized in CliqueTreeCalibrate as such:
%      MESSAGES = repmat(struct('var', [], 'card', [], 'val', []), N, N);
%
%   If more than one message is ready to be transmitted, return 
%   the pair (i,j) that is numerically smallest. If you use an outer
%   for loop over i and an inner for loop over j, breaking when you find a 
%   ready pair of cliques, you will get the right answer.
%
%   If no such cliques exist, returns i = j = 0.
%
%   See also CLIQUETREECALIBRATE
%
% Copyright (C) Daphne Koller, Stanford University, 2012


function [indexa_ indexb_] = GetNextCliques(P, messages)

% initialization
% you should set them to the correct values in your code
indexa_ = 0;
indexb_ = 0;

%%%%% P.edges,   P.cliqueList

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% YOUR CODE HERE

resulted_list=[];
searched_list=[];
temp_check_num=[];

for i=1:length(P.cliqueList),
     a_temp=P.edges(i,:);
	 a_temp(i)=0;
     temp_check_num =sum(a_temp);
	 searched_list= find(a_temp);
	 
	 for j=1:length(searched_list),
	     %temp=[temp  P.cliqueList(i,j)];
		 temp_count=0;
		 for k=1:length(searched_list),
		     if searched_list(j)!=searched_list(k);
			 
		     if length(messages(searched_list(k),i).var)!=0,
		         temp_count+=1;
			 
	         end;
			 end;
	
	     end;
	    if temp_count==temp_check_num-1,
		if length(messages(i,searched_list(j)).var)==0,
            resulted_list=[resulted_list {[i searched_list(j)]}];
			    %disp([i searched_list(j)])
				%disp('above is result')
		end;
		end;
		
	end;
end;
if length(resulted_list)!=0,
random_interger= randi(length(resulted_list));
indexa_=resulted_list{random_interger}(1);
indexb_=resulted_list{random_interger}(2);
end;

%temp_find_smallest=[];
%resulted_list
%for i=1:length(resulted_list),
%a=resulted_list{i}(1);
%b=resulted_list{i}(2);
%P.cliqueList(a).val;
%P.cliqueList(b).val;
%resulted_list{i};
%temp_find_smallest=[temp_find_smallest  (mean([P.cliqueList(a).val P.cliqueList(b).val]))]
%end;
%index_temp=find(temp_find_smallest==min(temp_find_smallest))


%if length(index_temp)>1,

%index_random=randi(length(index_temp));
%indexa_=resulted_list{index_temp(index_random)}(1);
%indexb_=resulted_list{index_temp(index_random)}(2);
%else
%indexa_=resulted_list{index_temp}(1);
%indexb_=resulted_list{index_temp}(2);
%end;



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



return;
