function node = visualize_expand_multi(Path,W,t)
%VISUALIZE_EXPAND_MULTI: Draw the shortest path from one source node to multiple 
%                        sink nodes in the expanded map


[max_x,max_y] = size(W);

set(gcf, 'Renderer', 'painters');
set(gcf, 'Position', [500, 50, 20*max_x, 20*max_y]);

% Count the number of paths
num_path = length(Path);

% Determine the source node (x_s, y_s)
path = Path{1};
x_s = path(1,1);
y_s = path(1,2);

% Horizontal boundaries in the expanded map
hold on
plot([0,3*max_x],[0,0],[0,3*max_x],[max_y,max_y],[0,3*max_x],[2*max_y,2*max_y], ...
    [0,3*max_x],[3*max_y,3*max_y],'Color','#EDB120','LineWidth',2)

% Vertical boundaries in the expanded map
hold on
plot([0,0],[0,3*max_y],[max_x,max_x],[0,3*max_y],[2*max_x,2*max_x],[0,3*max_y], ...
    [3*max_x,3*max_x],[0,3*max_y],'Color','#7E2F8E','LineWidth',2)

% plot peaks(red) and valleys(blue)
% original map
inter_valley = inter_square_valley(0,0,max_x,max_y,t,1);
inter_peak = inter_square_valley(0,0,max_x,max_y,t,2);
num_valley = size(inter_valley,1);
num_peak = size(inter_peak,1);

% expanded map
k = 0;
for i = 0:2
    for j = 0:2
        k = k+1;
        inter_valley_val = inter_valley;
        inter_peak_val = inter_peak;
        inter_valley_val(:,[1,3]) = inter_valley_val(:,[1,3])+i*max_x;
        inter_valley_val(:,[2,4]) = inter_valley_val(:,[2,4])+j*max_y;
        inter_peak_val(:,[1,3]) = inter_peak_val(:,[1,3])+i*max_x;
        inter_peak_val(:,[2,4]) = inter_peak_val(:,[2,4])+j*max_y;
        Inter_valley(:,:,k) = inter_valley_val;
        Inter_peak(:,:,k) = inter_peak_val;
    end
end

for k = 1:9
    for i = 1:num_valley
        hold on
        plot([Inter_valley(i,1,k),Inter_valley(i,3,k)],[Inter_valley(i,2,k),Inter_valley(i,4,k)],'--b')
    end
    for i = 1:num_peak
        hold on
        plot([Inter_peak(i,1,k),Inter_peak(i,3,k)],[Inter_peak(i,2,k),Inter_peak(i,4,k)],'--r')
    end
end

node = [];

% optimal path
for i = 1:num_path
    path = Path{i};
    sz_path = size(path,1);
    hold on
    plot(path(:,1),path(:,2),'-r','LineWidth',2)
    node = [node;path(sz_path,:)];
end

% Determine node color change
sz = 20;
c = linspace(1,10,num_path); 
% Draw the nodes for which the shortest path has been determined
hold on
scatter(node(:,1),node(:,2),sz,c,'filled');
% Draw the source and sink nodes
hold on
scatter(path(1,1),path(1,2),[],'blue','filled')
hold on
scatter(path(sz_path,1),path(sz_path,2),[],'red','filled')
% % Divide the rectangular area into several parts with the source node as the center node
% hold on
% plot([0,3*max_x],[y_s,y_s],[x_s,x_s],[0,3*max_y],'Color','#A2142F','LineWidth',2)

set(gca,'XTick',0:5:3*max_x)
set(gca,'YTick',0:5:3*max_y)
set(gca,'YDir','reverse')
set(gca,'XAxisLocation','origin');
axis equal
axis([0 3*max_x 0 3*max_y])
grid on

end
