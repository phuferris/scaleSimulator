% Simulation for SCALE Wireless Sensor Box

clear;
close all;

scale_parameter;

global numNodes;
global initial_power;
global maxx;
global maxy;
global maxEvents;
global eventsPeriod;
global maxRandomActiveTime;
global APs_list;
global sentEvents;
global forwardedEvents;
global totalReceived;
global lifeTime;
global activeTime;
global cyclePeriod;
global numCycles;
global DutyTime;


Nodes_list = [];

sentStatistics = [];

APs_list = [];
sentEvents = 0;
forwardedEvents = 0;
totalReceived = 0;



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
    Nodes_list(k).on_duty = 0; % 0 is not fowarding neighbors' traffic, 1 is
    Nodes_list(k).power = initial_power;
    Nodes_list(k).active_time_left = 0; % initial value
    Nodes_list(k).sleeping_time_left = 0; % 0 initial value
    Nodes_list(k).beacon_broadcasted = 0; % 0 initial value
    Nodes_list(k).AP_Connections = [];
    
    AP_Connections = [];
    random_AP = mod(round(rand(1)*100), k);
    if(random_AP == 0 || random_AP == 1 || random_AP == 1)
        issid = issid + 1;
        
         % Add new Access Point into APs_list
        AP = [];
        AP.issid = issid;
        AP.connect_node_id = k;     %direct connection node id
        AP.x_coordinate = Nodes_list(k).x_coordinate + 5;
        AP.y_coordinate = Nodes_list(k).y_coordinate + 5;
        AP.arrived_events = 0;
        APs_list = [APs_list; AP]; 
        
        Connection.through_neighbor = k; % need a function for this
        Connection.num_hops = 1; % need a function for this
        Connection.AP_issid = AP.issid;
        AP_Connections = [AP_Connections; Connection]; 
        Nodes_list(k).AP_Connections = AP_Connections;
        
        clear Connection;
        clear AP_Connections;
        clear AP;
         
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
Events_list = scale_generate_initial_events(Events_list, numNodes, maxEvents, eventsPeriod);

% Now, it is time to run network topology and generate events to 
% be sent to its access points, every while loop will count as 
% 1 second of sensors' clock.


%{
cyclePeriod = 100;
numCycles = 60;
max_run_time = cyclePeriod*numCycles;
%}



max_run_time = 500;

%{
% First sleeping schema: every node stay awake
ActPower = scale_run_all_active(Nodes_list, Events_list, max_run_time);
ActLife=lifeTime;
ActDuty=100;

scale_get_events_arrived_at_APs();
sentStatistics.act_sentEvent = sentEvents;
sentStatistics.act_forwardedEvents = forwardedEvents;
sentStatistics.act_totalReceived = totalReceived;

% First sleeping schema: every node stay active/sleeping 
% in random interval fron 1 to 5 mins
RandPower = scale_run_random_sleep(Nodes_list, Events_list, max_run_time);
%RandPower = scale_run_randSleep_duty(Nodes_list, Events_list, max_run_time);
RandLife=lifeTime;
RandDuty=0;
%}

%{

%{
%compute average duty cycle
if (RandLife~=0)
RandDuty=floor(sum(DutyTime(:))/numNodes/RandLife*100);
else
    RandDuty=floor(sum(DutyTime(:))/numNodes/max_run_time*100);
end
%}

%compute average duty cycle
if (RandLife~=0)
RandDuty=floor(sum(activeTime)/numNodes/RandLife*100);
else
    RandDuty=floor(sum(activeTime)/numNodes/max_run_time*100);
end


scale_get_events_arrived_at_APs();
scale_total_power_graph(numel(Nodes_list),'All Active', 'Random','Customize', ActPower, RandPower, 0);

sentStatistics.random_sentEvent = sentEvents;
sentStatistics.random_forwardedEvents = forwardedEvents;
sentStatistics.random_totalReceived = totalReceived;

disp(sprintf('Sent Statistics'));
disp(sentStatistics);

CustLife=0;
sentStatistics.cust_sentEvent = 1;
sentStatistics.cust_forwardedEvents = 0;
sentStatistics.cust_totalReceived = 0;
CustDuty=0;


scale_draw_events(sentStatistics);
scale_percent_compare(numel(Nodes_list),'All Active', 'Random','Customize', ActPower, RandPower, 0, sentStatistics);


if (lifeTime~=0)
    scale_lifetime_graph('All Active', 'Random','Customize', ActLife, RandLife, CustLife);
    scale_lifeThroughput_graph('All Active', 'Random','Customize', ActLife, RandLife, CustLife,sentStatistics);
    scale_dutyLifetime_graph('All Active', 'Random','Customize', ActLife, RandLife, CustLife, ActDuty, RandDuty, CustDuty);
end
%}

% Optimized sleeping schema with Marko chain

CustPower = scale_run_custom_sleep(Nodes_list, Events_list, max_run_time);
