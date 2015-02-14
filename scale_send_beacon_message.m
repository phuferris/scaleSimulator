function [nodes_list] = scale_send_beacon_message(nodes_list, k, message)

for n=1:numel(nodes_list(k).neighbors)
    %check to see if neighbor is active
    if(nodes_list(nodes_list(k).neighbors(n).id).status == 1)
       
       %check if node already in neighbors list
        idx=find([nodes_list(nodes_list(k).neighbors(n).id).neighbors.id] == k);
        if(isempty(idx))
             %add node to neighbors list 
             new_neighbor_info = message;
             disp(sprintf('Add node ID %d into neighbor list of node ID %d \n', k, nodes_list(k).neighbors(n).id));       
             current_neighbors_list = nodes_list(nodes_list(k).neighbors(n).id).neighbors;
             new_neighbors_list = scale_add_remove_neighbor(current_neighbors_list, new_neighbor_info, 'add');
             nodes_list(nodes_list(k).neighbors(n).id).neighbors = new_neighbors_list;
             clear new_neighbor_info;
             clear current_neighbors_list;
             clear new_neighbors_list;
        else
            %update the existing node status in neighbors list
             nodes_list(nodes_list(k).neighbors(n).id).neighbors(idx) = message;
        end
    end
end


end
