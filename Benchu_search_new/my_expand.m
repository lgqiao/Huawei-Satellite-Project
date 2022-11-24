function [Path_expand,path_expand,path,min_len] = my_expand(map,W,t)
%BENCHU_EXPAND: Calculate the shortest path using symmetric geometry on extended map 


Path_expand = {};
size_map = size(map,1);
[max_x,max_y] = size(W);

% Define the 2D grid map array.
% Source=1, Destination=0, Obstacle=-1;
% There are no obstacles if you don't consider the problem of solar transit
% MAP = 2*ones(max_x,max_y);

%Initialize MAP with location of the destination
xDestination = map(size_map,1);
yDestination = map(size_map,2);
% MAP(xDestination,yDestination)=0;

% %Initialize MAP with location of the obstacle
% for i = 2: size_map-1
%     xObstacle = map(i,1);
%     yObstacle = map(i,2);
%     MAP(xObstacle,yObstacle)=-1;
% end

%Initialize MAP with location of the source
xSource = map(1,1);
ySource = map(1,2);
% MAP(xSource,ySource) = 1;

x_s = xSource+max_x;
y_s = ySource+max_y;

if xSource==xDestination
    x_d1 = xDestination+max_x;
    y_d1 = yDestination+max_y;
    if yDestination>ySource
        x_d2 = x_d1;
        y_d2 = yDestination;        
    else
        x_d2 = x_d1;
        y_d2 = yDestination+2*max_y;
    end
    Path_expand(1) = {path_generate2(x_s,y_s,x_d1,y_d1,1)};
    Path_expand(2) = {path_generate2(x_s,y_s,x_d2,y_d2,1)};
elseif ySource==yDestination
    x_d1 = xDestination+max_x;
    y_d1 = yDestination+max_y;
    if xDestination>xSource
        x_d2 = xDestination;
        y_d2 = y_d1;
    else
        x_d2 = xDestination+2*max_x;
        y_d2 = y_d1;
    end
    Path_expand(1) = {path_generate2(x_s,y_s,x_d1,y_d1,1)};
    Path_expand(2) = {path_generate2(x_s,y_s,x_d2,y_d2,1)};
else
    [x_d,y_d] = destination_expand(xSource,ySource,xDestination,yDestination,max_x,max_y); 
    % Along the peak-to-valley direction
    Inter = inter_expand(xSource,ySource,xDestination,yDestination,max_x,max_y,t);   
    inter1 = Inter{1}; % forward
    inter2 = Inter{2}; % reverse
    num_valley1 = size(inter1,1);
    num_valley2 = size(inter2,1);
    % forward
    if num_valley1==0
        if W(xDestination+1,ySource+1)<=W(xSource+1,yDestination+1)
            Path_expand(1) = {path_generate2(x_s,y_s,x_d(1),y_d(1),2)};
        else
            Path_expand(1) = {path_generate2(x_s,y_s,x_d(1),y_d(1),1)};
        end
    elseif num_valley1==1
        path_expand1 = path_generate2(x_s,y_s,inter1(1,1),inter1(1,2),1);
        path_expand2 = path_generate2(inter1(1,1),inter1(1,2),inter1(1,3),inter1(1,4),3);
        path_expand3 = path_generate2(inter1(1,3),inter1(1,4),x_d(1),y_d(1),1);
        if path_expand1(end,:)==path_expand3(1,:)
            path_expand3(1,:) = [];
        end
        Path_expand(1) = {[path_expand1;path_expand2;path_expand3]};
    else
        dx_inter = inter1(:,3)-inter1(:,1);
        I = find(dx_inter==max(dx_inter), 1, 'last' );
        path_expand1 = path_generate2(x_s,y_s,inter1(I,1),inter1(I,2),1);
        path_expand2 = path_generate2(inter1(I,1),inter1(I,2),inter1(I,3),inter1(I,4),3);
        path_expand3 = path_generate2(inter1(I,3),inter1(I,4),x_d(1),y_d(1),1);
        if path_expand1(end,:)==path_expand3(1,:)
            path_expand3(1,:) = [];
        end
        Path_expand(1) = {[path_expand1;path_expand2;path_expand3]};
    end
    % reverse
    if num_valley2==0
        if W(xDestination+1,ySource+1)<=W(xSource+1,yDestination+1)
            Path_expand(2) = {path_generate2(x_s,y_s,x_d(2),y_d(2),2)};
        else
            Path_expand(2) = {path_generate2(x_s,y_s,x_d(2),y_d(2),1)};
        end
    elseif num_valley2==1
        path_expand1 = path_generate2(x_s,y_s,inter2(1,1),inter2(1,2),1);
        path_expand2 = path_generate2(inter2(1,1),inter2(1,2),inter2(1,3),inter2(1,4),3);
        path_expand3 = path_generate2(inter2(1,3),inter2(1,4),x_d(2),y_d(2),1);
        if path_expand1(end,:)==path_expand3(1,:)
            path_expand3(1,:) = [];
        end
        Path_expand(2) = {[path_expand1;path_expand2;path_expand3]};
    else
        dx_inter = inter2(:,1)-inter2(:,3);
        I = find(dx_inter==max(dx_inter), 1, 'last' );
        path_expand1 = path_generate2(x_s,y_s,inter2(I,1),inter2(I,2),1);
        path_expand2 = path_generate2(inter2(I,1),inter2(I,2),inter2(I,3),inter2(I,4),3);
        path_expand3 = path_generate2(inter2(I,3),inter2(I,4),x_d(2),y_d(2),1);
        if path_expand1(end,:)==path_expand3(1,:)
            path_expand3(1,:) = [];
        end
        Path_expand(2) = {[path_expand1;path_expand2;path_expand3]};
    end

    % Not along the peak-to-valley direction
    [S1,S2,D1,D2,delta1,delta2] = inter_sd_expand(xSource,ySource,xDestination,yDestination,max_x,max_y,t);
    [cross_point1,cross_point2] = line_cross_expand(S1,S2,D1,D2,delta1,delta2);
    % forward
    if isempty(cross_point1)==1
        point1 = [x_s,y_s;x_d(3),y_d(3)];
        if y_s==S1(2) && x_d(3)==D1(1)
            flag = 1;
        else
            flag = 2;
        end
    else
        point1 = [x_s,y_s;cross_point1;x_d(3),y_d(3)];
        y_1 = fx_valley(mod(point1(2,1),max_x),t);
        k_1 = find(y_1>mod(point1(2,2),max_y)-0.5 & y_1<mod(point1(2,2),max_y)+0.5);
        if isempty(k_1)==1
            flag = 1;
        else
            flag = 2;
        end
        point1 = round(point1);
    end
    num_point1 = size(point1,1);
    path_expand1 = [];
    for i = 1:num_point1-1
        path_val = path_generate2(point1(i,1),point1(i,2),point1(i+1,1),point1(i+1,2),mod(flag,2)+1);
        path_val(end,:) = [];
        path_expand1 = [path_expand1;path_val];
        flag = flag+1;
    end
    Path_expand(3) = {[path_expand1;x_d(3),y_d(3)]};
    % reverse
    if isempty(cross_point2)==1
        point2 = [x_s,y_s;x_d(4),y_d(4)];
        if y_s==S2(2) && x_d(4)==D2(1)
            flag = 1;
        else
            flag = 2;
        end
    else
        point2 = [x_s,y_s;cross_point2;x_d(4),y_d(4)];
        y_1 = fx_valley(mod(point2(2,1),max_x),t);
        k_1 = find(y_1>mod(point2(2,2),max_y)-0.5 & y_1<mod(point2(2,2),max_y)+0.5);
        if isempty(k_1)==1
            flag = 1;
        else
            flag = 2;
        end
        point2 = round(point2);
    end
    num_point2 = size(point2,1);
    path_expand2 = [];
    for i = 1:num_point2-1
        path_val = path_generate2(point2(i,1),point2(i,2),point2(i+1,1),point2(i+1,2),mod(flag,2)+1);
        path_val(end,:) = [];
        path_expand2 = [path_expand2;path_val];
        flag = flag+1;
    end
    Path_expand(4) = {[path_expand2;x_d(4),y_d(4)]};
end

% Calculate the length of each path and select the one with the shortest length
[path_expand,path,min_len,flag] = path_select(Path_expand,W);
