function [Path,Min_len] = my_search_quad3(map,W,t)
%MY_SEARCH_QUAD3: Calculate the shortest path from a source node to other nodes in an area
%                 the third quadrant direction


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

    % Compute duplicate path nodes for the lower and left boundaries of the rectangle
    [duplicate_hor,duplicate_ver] = duplicate_nodes(xSource,ySource,xDestination,yDestination,t);
    sz_node_hor = size(duplicate_hor,1);
    sz_node_ver = size(duplicate_ver,1);

    % Exclude the coincidence of the beginning and end points of repeated paths
    if sz_node_hor>0
        if duplicate_hor(end,1)==xSource
            duplicate_hor(end,:) = [];
            sz_node_hor = sz_node_hor-1;
        end
    end
    if sz_node_ver>0
        if duplicate_ver(end,1)==ySource
            duplicate_ver(end,:) = [];
            sz_node_ver = sz_node_ver-1;
        end
    end

%     % If the duplicate path node on the left border of the rectangle contains the vertex
%     % in the lower left corner of the rectangle, remove this point to prevent double calculation
%     if sz_node_ver>0
%         if yDestination==duplicate_ver(1,1)
%             duplicate_ver(1,:) = [];
%             sz_node_ver = sz_node_ver-1;
%         end
%     end

    % The lower and left borders of the rectangle
    x_hor = xDestination:xSource-1;
    y_ver = yDestination-1:-1:ySource+1;

    % Remove duplicate path nodes for the lower and left borders of the rectangle
    for i = 1:sz_node_hor
        k_hor = find(x_hor>=duplicate_hor(i,1) & x_hor<=duplicate_hor(i,2));
        x_hor(k_hor) = [];
    end
    for i = 1:sz_node_ver
        k_ver = find(y_ver>=duplicate_ver(i,2) & y_ver<=duplicate_ver(i,1));
        y_ver(k_ver) = [];
    end

    len_hor = length(x_hor);
    len_ver = length(y_ver);

    k = 0;
    % First calculate the shortest path from the source node to the points 
    % on the right and upper bounds of the rectangle
    % right bound
    [path,len] = path_generate1(xSource,ySource,xSource,yDestination,W,1);
    for i = 2:length(path)
        k = k+1;
        Path(k) = {path(1:i,:)};
        min_len = sum(len(1:i-1));
        Min_len = [Min_len,min_len];
    end
    MAP(xSource+1,ySource+2:yDestination+1) = 1;

    % upper bound
    [path,len] = path_generate1(xSource,ySource,xDestination,ySource,W,1);
    for i = 2:length(path)
        k = k+1;
        Path(k) = {path(1:i,:)};
        min_len = sum(len(1:i-1));
        Min_len = [Min_len,min_len];
    end
    MAP(xDestination+1:xSource,ySource+1) = 1;

    % Calculate the shortest path from the source node to the non-repeated
    % path nodes on the upper boundary of the rectangle
    for i = 1:len_hor
        [S,D,delta_x,delta_y] = inter_sd(xSource,ySource,x_hor(i),yDestination,t); % Calculate start and end points of line segments
        cross_point = line_cross(S,D,delta_x,delta_y); % Calculate the intersection of line segments with valley and peak lines
        if isempty(cross_point)==1
            point = [xSource,ySource;x_hor(i),yDestination];
            % Determine the type of the shortest path between the source node and the first intersection and mark it with flag
            if ySource==S(2) && x_hor(i)==D(1)
                flag = 1;
            else
                flag = 2;
            end
        else
            point = [xSource,ySource;cross_point;x_hor(i),yDestination];
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
        path = [path;x_hor(i),yDestination];
        num_node = size(path,1);
        row_index = [];
        % Determine the shortest paths from the source node to which nodes have not been calculated
        % according to the labels in the MAP
        for m = 2:num_node
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

    % Compute the shortest path from the source node to the duplicate
    % path node on the upper boundary of the rectangle
    for i = 1:sz_node_hor
        [S,D,delta_x,delta_y] = inter_sd(xSource,ySource,duplicate_hor(i,1),yDestination,t);
        cross_point = line_cross(S,D,delta_x,delta_y);
        if isempty(cross_point)==1
            point = [xSource,ySource;duplicate_hor(i,1),yDestination];
            if ySource==S(2) && duplicate_hor(i,1)==D(1)
                flag = 1;
            else
                flag = 2;
            end
        else
            point = [xSource,ySource;cross_point;duplicate_hor(i,1),yDestination];
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
        path = [path;duplicate_hor(i,1),yDestination];
        num_node = size(path,1);
        row_index = [];
        for m = 2:num_node
            x_d = path(m,1);
            y_d = path(m,2);
            if MAP(x_d+1,y_d+1)~=1
                row_index = [row_index,m];
                MAP(x_d+1,y_d+1) = 1;
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

    % Calculate the shortest path from the source node to the non-repeated
    % path nodes on the upper boundary of the rectangle
    for i = 1:len_ver
        [S,D,delta_x,delta_y] = inter_sd(xSource,ySource,xDestination,y_ver(i),t);
        cross_point = line_cross(S,D,delta_x,delta_y);
        if isempty(cross_point)==1
            point = [xSource,ySource;xDestination,y_ver(i)];
            if ySource==S(2) && xDestination==D(1)
                flag = 1;
            else
                flag = 2;
            end
        else
            point = [xSource,ySource;cross_point;xDestination,y_ver(i)];
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
        path = [path;xDestination,y_ver(i)];
        num_node = size(path,1);
        row_index = [];
        for m = 2:num_node
            x_d = path(m,1);
            y_d = path(m,2);
            if MAP(x_d+1,y_d+1)~=1
                row_index = [row_index,m];
                MAP(x_d+1,y_d+1) = 1;
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

    % Compute the shortest path from the source node to the duplicate
    % path node on the right boundary of the rectangle
    for i = 1:sz_node_ver
        [S,D,delta_x,delta_y] = inter_sd(xSource,ySource,xDestination,duplicate_ver(i,1),t);
        cross_point = line_cross(S,D,delta_x,delta_y);
        if isempty(cross_point)==1
            point = [xSource,ySource;xDestination,duplicate_ver(i,1)];
            if ySource==S(2) && xDestination==D(1)
                flag = 1;
            else
                flag = 2;
            end
        else
            point = [xSource,ySource;cross_point;xDestination,duplicate_ver(i,1)];
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
        path = [path;xDestination,duplicate_ver(i,1)];
        num_node = size(path,1);
        row_index = [];
        for m = 2:num_node
            x_d = path(m,1);
            y_d = path(m,2);
            if MAP(x_d+1,y_d+1)~=1
                row_index = [row_index,m];
                MAP(x_d+1,y_d+1) = 1;
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
        [S,D,delta_x,delta_y] = inter_sd(xSource,ySource,vacancy_node(i,1),vacancy_node(i,2),t);
        cross_point = line_cross(S,D,delta_x,delta_y);
        if isempty(cross_point)==1
            point = [xSource,ySource;vacancy_node(i,1),vacancy_node(i,2)];
            if ySource==S(2) && vacancy_node(i,1)==D(1)
                flag = 1;
            else
                flag = 2;
            end
        else
            point = [xSource,ySource;cross_point;vacancy_node(i,1),vacancy_node(i,2)];
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
        path = [path;vacancy_node(i,1),vacancy_node(i,2)];
        num_node = size(path,1);
        row_index = [];
        for m = num_node:-1:2
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
