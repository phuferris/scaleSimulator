function [Nodes_list] = scale_send_to_neighbor(Nodes_list, event, neighbor_id);
    
    if ~isempty(Nodes_list(neighbor_id))
        if Nodes_list(neighbor_id).status == 1 && Nodes_list(neighbor_id).on_duty == 1
           % add the event into the neighbor's buffer
           Nodes_list(neighbor_id).buffer = [Nodes_list(neighbor_id).buffer, event];
        end
    end
    return;
end
