function visualize_expand(path_expand,W,t)
%VISUALIZE_EXPAND: Draw the shortest path in a 3x3 expanded map area


[max_x,max_y] = size(W);

set(gcf, 'Renderer', 'painters');
set(gcf, 'Position', [500, 50, 20*max_x, 20*max_y]);

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

sz_path = size(path_expand,1);

% optimal path
hold on
plot(path_expand(:,1),path_expand(:,2),'-r','LineWidth',2)
% Draw the source and sink nodes
hold on
scatter(path_expand(1,1),path_expand(1,2),[],'blue','filled')
hold on
scatter(path_expand(sz_path,1),path_expand(sz_path,2),[],'red','filled')
set(gca,'XTick',0:5:3*max_x)
set(gca,'YTick',0:5:3*max_y)
set(gca,'YDir','reverse')
set(gca,'XAxisLocation','origin')
axis equal
axis([0 3*max_x 0 3*max_y])
grid on

end
