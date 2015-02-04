function [Nodes_list] = scale_send_event(Nodes_list, event)
    current_node = Nodes_list(event.source);
    current_node_neighbors = current_node.neighbors;  
    if(~isempty(current_node.AP_Connections))
        node_AP_connections = current_node.AP_Connections;
        
        % Current node has direct connection to an access point
        if(node_AP_connections.through_neighbor == current_node.id)
            scale_send_to_AP(event, current_node.AP_issid);
            % need to reduce current node power due to sendig activity
            
        % find and update its path to an AP through a neighbor
        else
            best_neighbor = current_node_neighbors(1);
            for i=2:numel(current_node_neighbors)
                if(current_node_neighbors(i).status == 1 && current_node_neighbors(i).num_hops < best_neighbor.num_hops)
                    best_neighbor = current_node_neighbors(i);
                end
            end
            
            if(best_neighbor.status == 1)
                node_AP_connections.through_neighbor = best_neighbor.id;
                node_AP_connections.num_hops = best_neighbor.num_hops + 1;
            else % all neighbors are not active
                node_AP_connections.through_neighbor = 0;
                node_AP_connections.num_hops = 0;
            end
            
            if(node_AP_connections.through_neighbor ~= 0)
                Nodes_list = scale_send_to_neighbor(Nodes_list, event, node_AP_connections.through_neighbor);
            else % no neighbor is active or has connection to an AP, buffering the event
                current_node.buffer = [current_node.buffer; event];
            end
            
        end
    else
        current_node.buffer = [current_node.buffer; event];
    end
    return;
end
