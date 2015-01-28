% Simulation for SCALE Wireless Sensor Box

clear;

scale_parameter;

global numNodes;
global numAPs;
global initial_power;
global wireless_range;

Nodes_list = [];
APs_list = [];

Nodes_coordinates = zeros(numNodes, 2);

% Initialize sensor direct connection to a nearest Access Point AP
% Initialize sensor status
issid = 0;
for k=1:numNodes
    Nodes_list(k).id = k;
    Nodes_list(k).x_coordinate = rand()*250; % 250 feets
    Nodes_list(k).y_coordinate = rand()*250; % 250 feets
    
    Nodes_list(k).buffer = [];
    Nodes_list(k).neighbors = [];
    Nodes_list(k).status = 0; % get_status(node_id, neighors), 0 = sleep, 1 = active
    Nodes_list(k).power = initial_power;
    Nodes_list(k).next_idle_time = rand()*5; %random 5 second when it is started
    Nodes_list(k).AP_Connections = [];
    
    AP_Connections = [];
    if(mod(round(rand(1)*100), k) == 0)
        issid = issid + 1;
        
        Connection.through_neighbor = k; % need a function for this
        Connection.num_hops = 1; % need a function for this
        AP_Connections = [AP_Connections; Connection]; 
        Nodes_list(k).AP_Connections = AP_Connections;
        clear Connection;
        clear AP_Connections;
        
        % Add new Access Point into APs_list
        AP = [];
        AP.issid = strcat('AP#', num2str(issid));
        AP.x_coordinate = Nodes_list(k).x_coordinate + 5;
        AP.y_coordinate = Nodes_list(k).y_coordinate + 5;
        APs_list = [APs_list; AP];  
    end    
end

% Display initial network topology
disp(sprintf('\n Network Initial Tepology\n'));
scale_display_nodes_info(Nodes_list);

% disp(sprintf('Before calling drawing \n')); 
% disp(Nodes_cooordinates);

% Not allow to pass a matrix to  function
scale_draw_network_topology(Nodes_list, APs_list, 250, 250);

% Initial broadcast join messages
for k=1:numNodes
    message = [];
    message.id = Nodes_list(k).id;
    message.node_x_coordinate = Nodes_list(k).x_coordinate;
    message.node_y_coordinate = Nodes_list(k).y_coordinate;
    
    if(~isempty(Nodes_list(k).AP_Connections))
        message.AP_connection = 1;
        
        node_AP_connections = Nodes_list(k).AP_Connections;
        message.AP_connection_through_node_id = node_AP_connections.through_neighbor;
        message.AP_connection_hop_count = node_AP_connections.num_hops + 1;
    else
        message.AP_connection = 0;
        message.AP_connection_through_node_id = 0;
        message.AP_connection_hop_count = 0;
    end
                
    action = [];
    action.type = 'broadcast_join';
    
   Nodes_list = scale_broadcast_join(Nodes_list, message);
   Nodes_list(k).power = scale_power_consumption(Nodes_list(k).power, action);
end

% Display nodes' info after running network initialization
disp(sprintf('\n New Network Information after Initialization\n'));
% scale_display_nodes_info(Nodes_list);

% Now, it is time to run network topology and generate events to 
% be sent to its access points, every while loop will count as 
% 1 second of sensors' clock.
