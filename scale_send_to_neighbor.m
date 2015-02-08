function [Nodes_list] = scale_send_to_neighbor(Nodes_list, event, neighbor_id)
% Send an event to a neighbor node    
    if isempty(neighbor_id)
        return;
    end
    
    disp(sprintf('neighbor ID %d', neighbor_id));
    
    if ~isempty(Nodes_list(neighbor_id))
        if Nodes_list(neighbor_id).status == 1 && Nodes_list(neighbor_id).on_duty == 1
           % add the event into the neighbor's buffer
           event.source = neighbor_id;
           Nodes_list = scale_send_event(Nodes_list, event); 
        else
           Nodes_list(neighbor_id).buffer = [Nodes_list(neighbor_id).buffer, event];
        end
    end
    return;
end
