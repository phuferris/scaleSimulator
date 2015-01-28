function scale_draw_network_topology(Nodes_coordinates, maxx, maxy)

% make background white, run only once
colordef none,  whitebg

figure(1);
axis equal
hold on;
box on;

disp(sprintf('original nodes'));
disp(Nodes_coordinates);

nodes = rand(25,2);
nodes(:,1) = nodes(:,1)*maxx;
nodes(:,2) = nodes(:,2)*maxy;

disp(sprintf('random nodes'));
disp(nodes);

% grid on;
plot(nodes(:, 1), nodes(:, 2), 'k.', 'MarkerSize', 30);
title('SCALE Network Topology');
    
xlabel('X Coordinate');
ylabel('Y Coordinate');

axis([0, maxx, 0, maxy]);
set(gca, 'XTick', [0; maxx]);
set(gca, 'YTick', [maxy]);

return;
