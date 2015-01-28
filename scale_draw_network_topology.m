function scale_draw_network_topology(Nodes_list, APs_list, maxx, maxy)
% make background white, run only once

numNodes = numel(Nodes_list);
Nodes_coordinates = zeros(numNodes, 2);

numAPs = numel(APs_list);
APs_coordinates = zeros(numAPs, 2);

% Initialize sensor direct connection to a nearest Access Point AP
% Initialize sensor status 
for k=1:numNodes
    % Store node x and y coordinate to draw network topology later
    Nodes_coordinates(k,1) = Nodes_list(k).x_coordinate;
    Nodes_coordinates(k,2) = Nodes_list(k).y_coordinate;
end

for k=1:numAPs
    % Store node x and y coordinate to draw network topology later
    APs_coordinates(k,1) = APs_list(k).x_coordinate;
    APs_coordinates(k,2) = APs_list(k).y_coordinate;
end

colordef none,  whitebg

figure(1);
axis equal
hold on;
box on;

% plot wireless sensor nodes ;
plot(Nodes_coordinates(:, 1), Nodes_coordinates(:, 2), 'k.', 'MarkerSize', 30);

% plot wireless access points
plot(APs_coordinates(:, 1), APs_coordinates(:, 2), 'c.', 'MarkerSize', 50);

title('SCALE Network Topology');
    
xlabel('X Coordinate');
ylabel('Y Coordinate');

axis([0, maxx, 0, maxy]);
set(gca, 'XTick', [0; maxx]);
set(gca, 'YTick', [maxy]);


end
