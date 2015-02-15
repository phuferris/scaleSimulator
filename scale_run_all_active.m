function [TotPower]=scale_run_all_active(Nodes_list, Events_list, max_run_time)
% Simulate SCALE network when all nodes are kept active

global sentEvents;
global forwardedEvents;

% Set nodes to be active
for k=1:numel(Nodes_list)
   Nodes_list(k).status = 1; 
   Nodes_list(k).on_duty = 1;
end

clock = 0;
sentEvents = 0;
forwardedEvents = 0;
scale_reset_events_arrived_at_APs();

% Loop until clock is reach 
% the maximum run time thredhold
while 1
    clock = clock + 1;
    
    % Check to see if the network topology is still active
    network_status = scale_check_topology_connectors(Nodes_list);
    if network_status == 0
       disp(sprintf('At clock %d, all nodes that have access to APs are died', clock));
       break;
    end
    
    if (clock > max_run_time)
        break;
    end
    
    events = [];
    events = scale_get_events(Events_list, events, clock);
    
    for k=1:numel(Nodes_list)
        
        action = [];
        action.type = 'active';
        action.time = 1;
        Nodes_list(k).power = scale_power_consumption(Nodes_list(k).power, action);
        
        % Send beacon message to neighbors to update
        % its current status for every 10 seconds
        if mod(clock, 10) == 0

            Nodes_list = scale_send_beacon_message(Nodes_list, k);
            
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
            %disp(sprintf('Node ID %d status %d', k, Nodes_list(k).status));
            %disp(sprintf('Event instant %d, currrent clock %d, event source %d', event.instant, clock, event.source));
            %disp(sprintf('Found 1 event for node #%d, Sent the event to its destination', k));
            %disp(event);
            
            sentEvents = sentEvents + 1;
            Nodes_list = scale_send_event(Nodes_list, event); 
        
        % Check to see if there is any event in the buffer to be sent    
        else
            if(~isempty(Nodes_list(k).buffer))
               buffered_event = Nodes_list(k).buffer(1); % pick to the oldest event 

               
               %disp(sprintf('Node ID %d status %d', k, Nodes_list(k).status));
               %disp(sprintf('Buffer Event instant %d, currrent clock %d, buffer event source %d', buffered_event.instant, clock, buffered_event.source));
               %disp(sprintf('Found 1 event for node #%d, Sent the event to its destination', k));

               %disp(buffered_event); 
               forwardedEvents = forwardedEvents + 1;

               Nodes_list(k).buffer(1) = []; % remove sent event from buffer
               Nodes_list = scale_send_event(Nodes_list, buffered_event);
            end
        end   
    end
end

%scale_display_nodes_info(Nodes_list);
TotPower=scale_power_graph(Nodes_list,'All Active');

return;