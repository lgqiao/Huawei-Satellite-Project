function [Path,Min_len] = my_search_quad2_new(map,W,t)
%MY_SEARCH_QUAD2_NEW: Calculate the shortest path from a source node to other nodes in an area
%                     the second quadrant direction


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
    for i = 2:size(path,1)
        Path(i-1) = {path(1:i,:)};
        min_len = sum(len(1:i-1));
        Min_len = [Min_len,min_len];
    end
else
    % Label the source node as 1, the destination node as 0, and the remaining nodes as 2
    MAP(xSource+1:xDestination+1,ySource+1:yDestination+1) = 2;
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
            % Calculate the intersection of rectangle and valley
            inter = inter_square(xSource,ySource,xDestination,yDestination,t,1);
            num_valley = size(inter,1); % number of intersections
            if num_valley==0
                if W(xDestination+1,ySource+1)<=W(xSource+1,yDestination+1)
                    [path,len] = path_generate1(xSource,ySource,xDestination,yDestination,W,2);
                else
                    [path,len] = path_generate1(xSource,ySource,xDestination,yDestination,W,1);
                end
            elseif num_valley==1
                [path1,len1] = path_generate1(xSource,ySource,inter(1,1),inter(1,2),W,1);
                [path2,len2] = path_generate1(inter(1,1),inter(1,2),inter(1,3),inter(1,4),W,3);
                [path3,len3] = path_generate1(inter(1,3),inter(1,4),xDestination,yDestination,W,1);
                if path1(end,:)==path3(1,:)
                    path3(1,:) = [];
                end
                path = [path1;path2;path3];
                len = [len1;len2;len3];
            else
                [~,I] = max(abs(inter(:,3)-inter(:,1)));
                [path1,len1] = path_generate1(xSource,ySource,inter(I,1),inter(I,2),W,1);
                [path2,len2] = path_generate1(inter(I,1),inter(I,2),inter(I,3),inter(I,4),W,3);
                [path3,len3] = path_generate1(inter(I,3),inter(I,4),xDestination,yDestination,W,1);
                if path1(end,:)==path3(1,:)
                    path3(1,:) = [];
                end
                path = [path1;path2;path3];
                len = [len1;len2;len3];
            end
        end

        len_path = size(path,1);
        row_index = [];
        % Determine the shortest paths from the source node to which nodes have not 
        % been calculated according to the labels in the MAP
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
        
        % Compute the shortest path from the source node to the uncomputed node
        num_index = length(row_index);
        if num_index>0
            % end point of the path
            k = k+1;
            row = row_index(1);
            Path(k) = {path(1:row,:)};
            min_len = sum(len(1:row-1));
            Min_len = [Min_len,min_len];
            % other points of the path
            for n = 2:num_index
                k = k+1;
                row = row_index(n);
                Path(k) = {path(1:row,:)};
                min_len = min_len-len(row);
                Min_len = [Min_len,min_len];
            end
        end
    end
end