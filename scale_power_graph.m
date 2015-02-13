function scale_power_graph(Nodes_list)
global initial_power;
figure;
b=bar([Nodes_list.id],[Nodes_list.power]);
set(gca, 'XTick', [Nodes_list.id])

title('SCALE Power Level');
    
xlabel('Node ID');
ylabel('Power (mAh)');


%label percentage

x = get(b,'XData');
y = get(b,'YData');
ygap =2;  % vertical gap between the bar and label


ylim([ 0, initial_power+500]);% Increase y limit for labels

    for n = 1:length(x)  
            xpos = x(n);        
            ypos = y(n) + ygap; 
            percent=round(Nodes_list(n).power/initial_power*100);
            text(xpos,ypos,[num2str(percent), '%'],'HorizontalAlignment','left','Rotation',90);        
    end









