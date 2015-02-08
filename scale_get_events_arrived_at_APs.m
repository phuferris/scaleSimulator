function scale_get_events_arrived_at_APs()
% Display events that have arrived at all available access points
    global APs_list;
    
    totalReceived = 0;
    for k=1:numel(APs_list)
       disp(sprintf('AP issid #%d, received events: %d', k, APs_list(k).arrived_events)); 
       totalReceived = totalReceived + APs_list(k).arrived_events;
    end
    
    disp(sprintf('Total events arrived at APs: %d', totalReceived));
    
end