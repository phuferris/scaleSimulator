% Simulation for SCALE Wireless Sensor Box

clear;

scale_parameter;

global numNodes;
global initial_power;
global maxx;
global maxy;
global maxEvents;
global eventsPeriod;
global maxRandomActiveTime;

Nodes_list = [];
APs_list = [];

Nodes_coordinates = zeros(numNodes, 2);

% Initialize sensor direct connection to a nearest Access Point AP
% Initialize sensor status
issid = 0;
for k=1:numNodes
    Nodes_list(k).id = k;
    Nodes_list(k).x_coordinate = rand()*maxx; % 250 feets
    Nodes_list(k).y_coordinate = rand()*maxy; % 250 feets
    
    Nodes_list(k).buffer = [];
    Nodes_list(k).neighbors = [];
    Nodes_list(k).status = 0; % get_status(node_id, neighors), 0 = sleep, 1 = active
    Nodes_list(k).power = initial_power;
    Nodes_list(k).active_time_left = round(rand()*maxRandomActiveTime); %random 5 second when it is started
    Nodes_list(k).sleeping_time_left = 0; % 0 seconds when it is started
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
        AP.connect_nodeid = k;     %direct connection node id
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
%scale_draw_network_topology(Nodes_list, APs_list, maxx, maxy);

% Initial broadcast join messages
Nodes_list = scale_initial_broadcast_join(Nodes_list);

% Display nodes' info after running network initialization
disp(sprintf('\n New Network Information after Initialization\n'));
scale_display_nodes_info(Nodes_list);
scale_draw_network_topology(Nodes_list, APs_list, maxx, maxy); % draw network with neighbor connections

%Generate initial events which could occur within the SCALE network
% within 1 hour

Events_list = [];
Eevents_list = scale_generate_initial_events(Events_list, numNodes, maxEvents, eventsPeriod);




% Now, it is time to run network topology and generate events to 
% be sent to its access points, every while loop will count as 
% 1 second of sensors' clock.

% Create Andy branch

