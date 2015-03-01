function [Psleep, Pactive]=scale_get_sleepActProb(currentPs, Node)
global powerWeight;
global neighborWeight;
global distanceWeight;
 
%number of neighbors
m=numel(Node.neighbors);

%number of hops to AP
if ~isempty(Node.AP_Connections)
    hop=1;
else
    hop = min([Node.neighbors.AP_connection_hop_count]) + 1;
end
         
Psleep = currentPs-powerWeight*sqrt(log(Node.power))+neighborWeight*m/(m+7)+distanceWeight*sqrt(1/hop);

% set limit to probability
if Psleep < 0.1
    Psleep = 0.1;
elseif Psleep > 0.9
    Psleep = 0.9;
end

Pactive = 1- Psleep;

