function [Nodes_list] = scale_send_to_neighbor(Nodes_list, event, neighbor_id)
% Send an event to a neighbor node    
    if isempty(neighbor_id)
        return;
    end
    
    % Drop the message if the node is its originator
    if event.originator == neighbor_id
        return
    end
    
    %disp(sprintf('EVENT with message id# %d FORWARDED TO Neighbor ID %d', neighbor_id, event.id));
    
    if ~isempty(Nodes_list(neighbor_id))
        if Nodes_list(neighbor_id).status == 1
           % add the event into the neighbor's buffer
           event.source = neighbor_id;
           
           action = [];
           action.type = 'receiving';
           action.packet_size = event.size;
           Nodes_list(neighbor_id).power = scale_power_consumption(Nodes_list(neighbor_id).power, action);

           disp(sprintf('NEIGHBOR Node ID# %d sending forwarded event with message id# %d', neighbor_id, event.id));

           Nodes_list = scale_send_event(Nodes_list, event); 
        else
           disp(sprintf('NEIGHBOR Node ID# %d BUFFERING forwarded event with message id# %d', neighbor_id, event.id));
           Nodes_list(neighbor_id).buffer = [Nodes_list(neighbor_id).buffer, event];
        end
    end
    return;
end
