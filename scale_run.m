function [Nodes_list] = scale_run(Nodes_list, Events_list, max_run_time, log_file, spleeping_protocol)

clock = 0;

% 
while 1
    clock = clock + 1;
    [min_instant, min_index] = min([Events_list(:).instant]);
    event = Events_list(min_index);
    
    for k=1:numel(Nodes_list)
        if Nodes_list(k).status == 1
           Nodes_list(k).active_time_left = Nodes_list(k).active_time_left - 1;
           
           % Check to see if it has any any event from the event queue
           if(~isempty(event) && event.instant == clock && event.source == k)
               newEvents = scale_send_event(event); % get new events from sending the latest one
               Events_list(min_index) = [];
               if(~isempty(newEvents))
                   Events_list = [Events_list; newEvents];
               end
           end

           % Send out beacon message to annouce its active
           Nodes_list = scale_send_beacon_message(Nodes_list, k);
           
           if Nodes_list(k).active_time_left == 0
               Nodes_list(k).status = 0;
               Nodes_list(k).sleeping_time_left = scale_get_sleeping_time(Nodes_list, spleeping_protocol);
           end
        else
           Nodes_list(k).sleeping_time_left = Nodes_list(k).sleeping_time_left - 1;
           if Nodes_list(k).sleeping_time_left == 0
               Nodes_list(k).satus = 1;
               Nodes_list(k).active_time_left = scale_get_active_time(Nodes_list, spleeping_protocol);
           end
        end    
    end
end

return;