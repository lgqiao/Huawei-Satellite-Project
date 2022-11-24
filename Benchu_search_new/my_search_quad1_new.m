function [Path,Min_len] = my_search_quad1_new(map,W,t)
%MY_SEARCH_QUAD1_NEW: Calculate the shortest path from a source node to other nodes in an area,
%                     the first quadrant direction


Path = {};
Min_len = [];

size_map = size(map,1);
[max_x,max_y] = size(W);

% Define the 2D grid map array.
% Source=1, Destination=0, Obstacle=-1;
% There are no obstacles if you don't consider the problem of solar transit
MAP = -2*ones(max_x,max_y);

%Initialize MAP with location of the destination
xDestination = map(size_map,1);
yDestination = map(size_map,2);

%Initialize MAP with location of the obstacle
for i = 2: size_map-1
    xObstacle = map(i,1);
    yObstacle = map(i,2);
    MAP(xObstacle,yObstacle)=-1;
end

%Initialize MAP with location of the source
xSource = map(1,1);
ySource = map(1,2);

% Determine the relative position of the source node and the destination node
if xSource==xDestination || ySource==yDestination
    [path,len] = path_generate1(xSource,ySource,xDestination,yDestination,W,1);
    for i = 2:length(path)
        Path(i-1) = {path(1:i,:)};
        min_len = sum(len(1:i-1));
        Min_len = [Min_len,min_len];
    end
else
    % Label the source node as 1, the destination node as 0, and the remaining nodes as 2
    MAP(xSource+1:-1:xDestination+1,yDestination+1:-1:ySource+1) = 2;
    MAP(xSource+1,ySource+1) = 1;

    % Compute the boundary nodes of the rectangular region
    boundary = boundary_nodes(xSource,ySource,xDestination,yDestination,W,t);
    len_boundary = size(boundary,1);
    k = 0;

    % Compute the shortest path from the source node to the boundary nodes
    for i = 1:len_boundary
        xDestination = boundary(i,1);
        yDestination = boundary(i,2);
        if xSource==xDestination || ySource==yDestination
            [path,len] = path_generate1(xSource,ySource,xDestination,yDestination,W,1);
        else
            [S,D,delta_x,delta_y] = inter_sd(xSource,ySource,xDestination,yDestination,t); % Calculate start and end points of line segments
            cross_point = line_cross(S,D,delta_x,delta_y); % Calculate the intersection of line segments with valley and peak lines
            if isempty(cross_point)==1
                point = [xSource,ySource;xDestination,yDestination];
                % Determine the type of the shortest path between the source node and the first intersection and mark it with flag
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
            path = [];
            len = [];
            % Calculate the shortest path segment by segment and concatenate
            for j = 1:num_point-1
                [path_val,len_val] = path_generate1(point(j,1),point(j,2),point(j+1,1),point(j+1,2),W,mod(flag,2)+1);
                path_val(end,:) = [];
                path = [path;path_val];
                len = [len;len_val];
                flag = flag+1;
            end
            path = [path;xDestination,yDestination];
        end

        len_path = size(path,1);
        row_index = [];
        % Determine the shortest paths from the source node to which nodes have not been calculated
        % according to the labels in the MAP
        for m = len_path:-1:2
            x_d = path(m,1);
            y_d = path(m,2);
            if MAP(x_d+1,y_d+1)~=1
                row_index = [row_index,m];
                MAP(x_d+1,y_d+1) = 1;
            end
        end
        num_index = length(row_index);
        % Compute the shortest path from the source node to the uncomputed node
        for n = 1:num_index
            k = k+1;
            row = row_index(n);
            Path(k) = {path(1:row,:)};
            min_len = sum(len(1:row-1));
            Min_len = [Min_len,min_len];
        end
    end
    
    % Calculate the vacant nodes in a rectangular area
    MAP = MAP';
    [y_vacancy,x_vacancy] = find(MAP==2);
    x_vacancy = flip(x_vacancy);
    y_vacancy = flip(y_vacancy);
    vacancy_node = [];
    if isempty(x_vacancy)==0
        vacancy_node = [vacancy_node;x_vacancy(1),y_vacancy(1)];
        for i = 2:length(x_vacancy)
            if x_vacancy(i)~=x_vacancy(i-1) || y_vacancy(i)~=y_vacancy(i-1)-1
                vacancy_node = [vacancy_node;x_vacancy(i),y_vacancy(i)];
            end
        end
        vacancy_node = vacancy_node-1;
    end
    MAP = MAP';
    
    % Calculate the shortest path from the source node to the vacant nodes
    for i = 1:size(vacancy_node,1)
        xDestination = vacancy_node(i,1);
        yDestination = vacancy_node(i,2);
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
        path = [];
        len = [];
        for j = 1:num_point-1
            [path_val,len_val] = path_generate1(point(j,1),point(j,2),point(j+1,1),point(j+1,2),W,mod(flag,2)+1);
            path_val(end,:) = [];
            path = [path;path_val];
            len = [len;len_val];
            flag = flag+1;
        end
        path = [path;xDestination,yDestination];

        len_path = size(path,1);
        row_index = [];
        for m = len_path:-1:2
            x_d = path(m,1);
            y_d = path(m,2);
            if MAP(x_d+1,y_d+1)~=1
                row_index = [row_index,m];
                MAP(x_d+1,y_d+1) = 1;
            else
                break
            end
        end
        num_index = length(row_index);
        for n = 1:num_index
            k = k+1;
            row = row_index(n);
            Path(k) = {path(1:row,:)};
            min_len = sum(len(1:row-1));
            Min_len = [Min_len,min_len];
        end
    end
end
