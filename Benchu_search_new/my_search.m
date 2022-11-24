function [path,min_len] = my_search(map,W,t)
%MY_SEARCH: Use the Symmetric Polyline Segment Method to Calculate 
%           the Shortest Path of Message Forwarding Between Satellites  


size_map = size(map,1);
% [max_x,max_y] = size(W);

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

min_len = 0;
path = [];

% Determine the relative position of the source node and the destination node
if xSource==xDestination || ySource==yDestination
    [path,min_len] = path_generate(xSource,ySource,xDestination,yDestination,W,1);
else
    k_l = (yDestination-ySource)/(xDestination-xSource); % slope
    if k_l>0
        % Calculate the intersection of rectangle and valley
        inter = inter_square(xSource,ySource,xDestination,yDestination,t,1);
        num_valley = size(inter,1); % number of intersections
        if num_valley==0
            if W(xDestination+1,ySource+1)<=W(xSource+1,yDestination+1)
                [path,min_len] = path_generate(xSource,ySource,xDestination,yDestination,W,2);
            else
                [path,min_len] = path_generate(xSource,ySource,xDestination,yDestination,W,1);
            end
        elseif num_valley==1
            [path1,len1] = path_generate(xSource,ySource,inter(1,1),inter(1,2),W,1);
            [path2,len2] = path_generate(inter(1,1),inter(1,2),inter(1,3),inter(1,4),W,3);
            [path3,len3] = path_generate(inter(1,3),inter(1,4),xDestination,yDestination,W,1);
            if path1(end,:)==path3(1,:)
                path3(1,:) = [];
            end
            path = [path1;path2;path3];
            min_len = len1+len2+len3;
        else
            [~,I] = max(abs(inter(:,3)-inter(:,1)));
            [path1,len1] = path_generate(xSource,ySource,inter(I,1),inter(I,2),W,1);
            [path2,len2] = path_generate(inter(I,1),inter(I,2),inter(I,3),inter(I,4),W,3);
            [path3,len3] = path_generate(inter(I,3),inter(I,4),xDestination,yDestination,W,1);
            if path1(end,:)==path3(1,:)
                path3(1,:) = [];
            end
            path = [path1;path2;path3];
            min_len = len1+len2+len3;
        end
    elseif k_l<0
        [S,D,delta_x,delta_y] = inter_sd(xSource,ySource,xDestination,yDestination,t);
        cross_point = line_cross(S,D,delta_x,delta_y);
        if isempty(cross_point)==1
            point = [xSource,ySource;xDestination,yDestination];
            if ySource==S(2) && xDestination==D(1)
                flag = 1;
            else
                flag = 2;
            end
        else
            point = [xSource,ySource;cross_point;xDestination,yDestination];
            y_1 = fx_valley(point(2,1),t);
            k_1 = find(y_1>point(2,2)-0.5 & y_1<point(2,2)+0.5);
            if isempty(k_1)==1
                flag = 1;
            else
                flag = 2;
            end
            point = round(point);
        end
        num_point = size(point,1);
        for i = 1:num_point-1
            [path1,len] = path_generate(point(i,1),point(i,2),point(i+1,1),point(i+1,2),W,mod(flag,2)+1);
            path1(end,:) = [];
            path = [path;path1];
            min_len = min_len+len;
            flag = flag+1;
        end
        path = [path;xDestination,yDestination];
    end
end
