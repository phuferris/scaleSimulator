function scale_display_nodes_info(Nodes_list)
% Display nodes' current info
    
    for k=1:numel(Nodes_list)
       disp(sprintf('--- Node ID:  %d, X coordinate: %g, Y coordinate: %g', Nodes_list(k).id,  Nodes_list(k).x_coordinate,  Nodes_list(k).y_coordinate));
       disp(sprintf('--- Status:  %d, Initial Power: %g mAh, Next idle time: %g seconds', Nodes_list(k).status, Nodes_list(k).power, Nodes_list(k).next_idle_time));
       
       % Display connection to AP list
       for index = 1:numel(Nodes_list(k).AP_Connections)
           AP_connection = Nodes_list(k).AP_Connections(index);
           disp(sprintf('--- AP connection: through node ID# %d by %d hops', AP_connection.through_neighbor, AP_connection.num_hops));
       end
       
       
       % Display neighbors list
       for index = 1:numel(Nodes_list(k).neighbors)
           neighbor = Nodes_list(k).neighbors(index);
           disp(sprintf('Neighbor ID# %d: connect to an AP %d, through node ID# %d, Hops count %d', neighbor.id, neighbor.AP_connection, neighbor.AP_connection_through_node_id, neighbor.AP_connection_hop_count));
       end
       
       disp(sprintf('\n'));   
    end
end