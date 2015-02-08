function scale_run_all_active(Nodes_list, Events_list, max_run_time)
% Simulate SCALE network when all nodes are kept active

global sentEvents;

% Set nodes to be active
for k=1:numel(Nodes_list)
   Nodes_list(k).status = 1; 
   Nodes_list(k).on_duty = 1;
end

clock = 0;
sentEvents = 0;
% 
while 1
    clock = clock + 1;
    
    if (clock > max_run_time)
        break;
    end
    
    events = [];
    events = scale_get_events(Events_list, events, clock);
    
    if ~isempty(events)
        sentEvents = sentEvents + numel(events);
    end
    
    for k=1:numel(Nodes_list)
        
        % Send beacon message to neighbors to update
        % its current status for every 10 seconds
        if mod(clock, 10) == 0
            message = [];
            message.id = Nodes_list(k).id;
            message.status = Nodes_list(k).status;
            message.node_x_coordinate = Nodes_list(k).x_coordinate;
            message.node_y_coordinate = Nodes_list(k).y_coordinate;
    
            if(~isempty(Nodes_list(k).AP_Connections))
                message.AP_connection = 1;
                node_AP_connections = Nodes_list(k).AP_Connections;
                message.AP_connection_through_node_id = node_AP_connections.through_neighbor;
                message.AP_connection_hop_count = node_AP_connections.num_hops + 1;
                message.AP_connection_AP_issid = node_AP_connections.AP_issid;
            else
                message.AP_connection = 0;
                message.AP_connection_through_node_id = 0;
                message.AP_connection_hop_count = 0;
                message.AP_connection_AP_issid = 0;
            end
            
            message.power_status = Nodes_list(k).power;
   
            message.sleeping_time_left = Nodes_list(k).sleeping_time_left;
            message.active_time_left = Nodes_list(k).active_time_left;    
            
            Nodes_list = scale_send_beacon_message(Nodes_list, k, message);
            
            action = [];
            action.type = 'broadcast_beacon';
            Nodes_list(k).power = scale_power_consumption(Nodes_list(k).power, action);
        end
        
        event = [];
        if ~isempty(events)
            event_index = find([events(:).source] == k, 1);
            if ~isempty(event_index)
               event = events(event_index); 
            end
        end
        
        % Check to see if it has any any event from the event queue
        if(~isempty(event) && event.instant == clock && event.source == k)
            disp(sprintf('Node ID %d status %d', k, Nodes_list(k).status));
            disp(sprintf('Event instant %d, currrent clock %d, event source %d', event.instant, clock, event.source));
            disp(sprintf('Found 1 event for node #%d, Sent the event to its destination', k));
            disp(event);   
            Nodes_list = scale_send_event(Nodes_list, event); 
        end   
    end
end

scale_display_nodes_info(Nodes_list);

return;