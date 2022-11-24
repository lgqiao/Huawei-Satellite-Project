function visualize_route(path,W,t,type)
%VISUALIE_ROUTE: Draw the shortest path between a pair of source and sink nodes in the original map area


[max_x,max_y] = size(W);

set(gcf, 'Renderer', 'painters');
set(gcf, 'Position', [500, 50, 20*max_x, 20*max_y]);

%     % obstacle
%     obst_sz = max(2500/sz_map, 36);
%     obst_cnt = 2: size(map, 1) - 1;
%     obst_color = [55,184,157]/255;
%     scatter(map(obst_cnt, 1)-1,map(obst_cnt, 2)-1,obst_sz,obst_color,'filled');

% % plot the grid
% for i = 0:max_x
%     for j = 0:max_y
%         hold on
%         plot([i,i+1],[j,j],'k')
%         if W(i+1,j+1)~=0
%             hold on
%             plot([i,i],[j,j+1],'k')
%         end
%     end
% end

% Rectangle upper and lower borders
hold on
plot([0,max_x],[0,0],[0,max_x],[max_y,max_y],'Color','#EDB120','LineWidth',2)
% Rectangle left and right borders
hold on
plot([0,0],[0,max_y],[max_x,max_x],[0,max_y],'Color','#7E2F8E','LineWidth',2)

% plot peaks(red) and valleys(blue)
inter_valley = inter_square(0,0,max_x,max_y,t,1);
inter_peak = inter_square(0,0,max_x,max_y,t,2);
num_valley = size(inter_valley,1);
num_peak = size(inter_peak,1);
for i = 1:num_valley
    hold on
    plot([inter_valley(i,1),inter_valley(i,3)],[inter_valley(i,2),inter_valley(i,4)],'--b')
end
for i = 1:num_peak
    hold on
    plot([inter_peak(i,1),inter_peak(i,3)],[inter_peak(i,2),inter_peak(i,4)],'--r')
end

sz_path = size(path,1);

% optimal path
if type==0
    hold on
    plot(path(:,1),path(:,2),'-r','LineWidth',2)
elseif type==1
    path1 = path;
    for i = 1:sz_path-1
        if path(i,1)-path(i+1,1) == max_x-1
            path1(i+1,1) = max_x;
            hold on
            plot([path1(i,1),path1(i+1,1)],[path(i,2),path(i+1,2)],'-r','LineWidth',2);
        elseif path(i,1)-path(i+1,1) == 1-max_x
            path1(i,1) = max_x;
            hold on
            plot([path1(i,1),path1(i+1,1)],[path(i,2),path(i+1,2)],'-r','LineWidth',2);
        elseif path(i,2)-path(i+1,2) == max_y-1
            path1(i+1,2) = max_y;
            hold on
            plot([path(i,1),path(i+1,1)],[path1(i,2),path1(i+1,2)],'-r','LineWidth',2);
        elseif path(i,2)-path(i+1,2) == 1-max_y
            path1(i,2) = max_y;
            hold on
            plot([path(i,1),path(i+1,1)],[path1(i,2),path1(i+1,2)],'-r','LineWidth',2);
        else
            hold on
            plot([path(i,1),path(i+1,1)],[path(i,2),path(i+1,2)],'-r','LineWidth',2);
        end
    end
end

hold on
scatter(path(1,1),path(1,2),[],'blue','filled')
hold on
scatter(path(sz_path,1),path(sz_path,2),[],'red','filled')
set(gca,'XTick',0:5:max_x)
set(gca,'YTick',0:5:max_y)
set(gca,'YDir','reverse')
set(gca,'XAxisLocation','origin')
axis equal
axis([0 max_x 0 max_y])
grid on

end
