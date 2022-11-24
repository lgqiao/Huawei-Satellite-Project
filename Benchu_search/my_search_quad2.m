function [Path,Min_len] = my_search_quad2(map,W,t)
%MY_SEARCH_QUAD2: Calculate the shortest path from a source node to other nodes in an area
%                 the second quadrant direction


global V

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
    % Preprocess the rectangular area to get relevant information
    % Get the intersection of the valley line with the rectangle
    inter_valley = inter_square(xSource,ySource,xDestination,yDestination,t,1);
    [num_ver,num_hor] = inter_num(inter_valley,xSource);

    path_valley1 = [];
    path_valley2 = [];

    % get the path along the valley line
    if num_ver>0
        I = num_ver;
        [path_valley1,len_valley1] = path_generate1(inter_valley(I,1),inter_valley(I,2),inter_valley(I,3),inter_valley(I,4),W,3);
        path_valley1 = [round(inter_valley(I,1)),round(inter_valley(I,2));path_valley1;round(inter_valley(I,3)),round(inter_valley(I,4))];
        [point_hor1,point_ver1] = valley_boundary(path_valley1,yDestination);
        [index_hor1,index_ver1] = index_valley_point(path_valley1,point_hor1,point_ver1);
        if isempty(point_hor1)==1 && isempty(point_ver1)==0
            point_hor1(1,1) = point_ver1(1,1);
            point_hor1(1,2) = point_ver1(1,2)+1;
            path_valley1_vir = point_hor1;
        end
        % Exclude the case where the valley line has only one point
        if isempty(len_valley1)==1
            path_valley1 = [];
        end
    end
    if num_hor>0
        I = num_ver+1;
        [path_valley2,len_valley2] = path_generate1(inter_valley(I,1),inter_valley(I,2),inter_valley(I,3),inter_valley(I,4),W,3);
        path_valley2 = [round(inter_valley(I,1)),round(inter_valley(I,2));path_valley2;round(inter_valley(I,3)),round(inter_valley(I,4))];
        [point_hor2,point_ver2] = valley_boundary(path_valley2,yDestination);
        [index_hor2,index_ver2] = index_valley_point(path_valley2,point_hor2,point_ver2);
        % Exclude the case where the valley line has only one point
        if isempty(len_valley2)==1
            path_valley2 = [];
        end
    end

    % Get the symmetric dividing line and its boundary points
    [point_sy_end,point_ver,point_hor] = symmetric_dividing(xSource,ySource,xDestination,yDestination,W,t);
    
    % point_hor is an empty set
    if isempty(point_hor)==1 && isempty(point_ver)==0 
        point_hor(1,1) = point_ver(end,1);
        point_hor(1,2) = point_ver(1,2)-1;
    end

    % If the valley line and the symmetrical dividing line coincide, 
    % then it is considered that there is no symmetrical dividing line.
    point_sy_end1 = point_sy_end;
    if isempty(point_sy_end1)==0
        if isempty(path_valley1)==0
            if point_sy_end1(2)==path_valley1(1,2)
                point_sy_end = [];
            end
        end
        if isempty(path_valley2)==0
            if point_sy_end1(1)==path_valley2(1,1)
                point_sy_end = [];
            end
        end
        if point_sy_end1(1)==point_sy_end1(3) && point_sy_end1(2)==point_sy_end1(4) % Symmetric dividing line is only one point
            point_sy_end = [];
        end
    end

    % Get the complete left and right or upper and lower boundaries of each area
    if isempty(point_sy_end)==0
        % Area 1
        if isempty(path_valley1)==0
            y_range = point_hor(1,2):-1:point_hor1(1,2)+1;
            boundary_ver2(:,2) = point_hor(end,2)-1:-1:point_hor1(end,2);
        else
            point_hor1 = [];
            y_range = point_hor(1,2):-1:yDestination;
            boundary_ver2(:,2) = point_hor(end,2)-1:-1:yDestination;
        end

        boundary_ver1(:,2) = y_range;
        boundary_ver1(:,1) = xSource;
        area1_1 = [boundary_ver1;point_hor1];

        boundary_ver2(:,1) = xDestination;
        area1_2 = [point_hor;boundary_ver2];

        [Path_area1,Len_area1] = path_generate_hor(area1_1,area1_2,W);

        % Area 2
        if isempty(path_valley2)==0
            x_range = point_ver(1,1):-1:point_ver2(1,1)+1;
            boundary_hor2(:,1) = point_ver(end,1)-1:-1:point_ver2(end,1);
        else
            point_ver2 = [];
            x_range = point_ver(1,1):-1:xDestination;
            boundary_hor2(:,1) = point_ver(end,1)-1:-1:xDestination;
        end

        boundary_hor1(:,1) = x_range;
        boundary_hor1(:,2) = ySource;
        area2_1 = [boundary_hor1;point_ver2];

        boundary_hor2(:,2) = yDestination;
        area2_2 = [point_ver;boundary_hor2];

        [Path_area2,Len_area2] = path_generate_ver(area2_1,area2_2,W);

        % Area 3
        if isempty(path_valley1)==0
            area3_1 = point_ver1;
            area3_2(:,1) = xSource:-1:point_ver1(end,1);
            area3_2(:,2) = yDestination;

            [Path_area3,Len_area3] = path_generate_ver(area3_1,area3_2,W);
        end

        % Area 4
        if isempty(path_valley2)==0
            area4_1 = point_hor2;
            area4_2(:,2) = ySource:-1:point_hor2(end,2);
            area4_2(:,1) = xDestination;

            [Path_area4,Len_area4] = path_generate_hor(area4_1,area4_2,W);
        end
    else
        % Two special cases, no valley lines go through the rectangle
        if isempty(path_valley1)==1 && isempty(path_valley2)==1
            if W(xDestination+1,ySource+1)<W(xSource+1,yDestination+1) % case 1
                x_range = xSource:-1:xDestination;
                area1_1(:,1) = x_range;
                area1_1(:,2) = ySource;
                area1_2(:,1) = x_range;
                area1_2(:,2) = yDestination;
                [Path_area1,Len_area1] = path_generate_ver(area1_1,area1_2,W);
            else % case 2
                y_range = ySource:-1:yDestination;
                area2_1(:,2) = y_range;
                area2_1(:,1) = xSource;
                area2_2(:,2) = y_range;
                area2_2(:,1) = xDestination;
                [Path_area2,Len_area2] = path_generate_hor(area2_1,area2_2,W);
            end
        elseif isempty(path_valley1)==0
            % Area 1
            area1_1 = point_ver1;
            area1_2(:,1) = xSource:-1:point_ver1(end,1);
            area1_2(:,2) = yDestination;
            [Path_area1,Len_area1] = path_generate_ver(area1_1,area1_2,W);

            % Area 2
            y_range1 = ySource:-1:point_hor1(1,2)+1;
            boundary_ver1(:,2) = y_range1;
            boundary_ver1(:,1) = xSource;
            area2_1 = [boundary_ver1;point_hor1];

            y_range2 = ySource:-1:point_hor1(end,2);
            area2_2(:,2) = y_range2;
            area2_2(:,1) = xDestination;
            [Path_area2,Len_area2] = path_generate_hor(area2_1,area2_2,W);
        elseif isempty(path_valley2)==0
            % Area 1
            x_range1 = xSource:-1:point_ver2(1,1)+1;
            boundary_hor1(:,1) = x_range1;
            boundary_hor1(:,2) = ySource;
            area1_1 = [boundary_hor1;point_ver2];

            x_range2 = xSource:-1:point_ver2(end,1);
            area1_2(:,1) = x_range2;
            area1_2(:,2) = yDestination;
            [Path_area1,Len_area1] = path_generate_ver(area1_1,area1_2,W);

            % Area 2
            area2_1 = point_hor2;
            area2_2(:,2) = ySource:-1:point_hor2(end,2);
            area2_2(:,1) = xDestination;
            [Path_area2,Len_area2] = path_generate_hor(area2_1,area2_2,W);
        end
    end

    Path1 = {};
    Path2 = {};
    Path3 = {};
    Path4 = {};

    % Calculate the shortest path from the source node to the internal nodes of each area
    if isempty(point_sy_end)==0 % The rectangle has a symmetrical dividing line
        % Area 1
        k = 0;
        % From the source node to the left intersection of the symmetrical dividing line and the rectangle
        y_range1 = ySource:-1:point_hor(1,2)+1;
        path_ver1(:,2) = y_range1;
        path_ver1(:,1) = xSource;
        sum_len_ver1 = V*size(path_ver1,1);
        % From the intersection of the symmetrical dividing line and the left of the rectangle to
        % the intersection of the valley line and the left of the rectangle
        path_ver = boundary_ver1;
        len_col = V*ones(size(path_ver,1),1);
        sz_path_ver = size(path_ver,1);
        for i = 1:sz_path_ver
            len_row = area1_1(i,1)-area1_2(i,1)+1;
            path_ver_val = path_ver(1:i,:);
            len_ver_val = sum(len_col(1:i-1));
            for j = 1:len_row
                k = k+1;
                Path1(k) = {[path_ver1;path_ver_val;Path_area1{k}]};
                min_len = sum_len_ver1+len_ver_val+Len_area1(k);
                Min_len = [Min_len,min_len];
            end
        end

        path_ver = [path_ver1;path_ver];
        sum_len_ver = sum_len_ver1+sum(len_col);
        sz_point_hor1 = size(point_hor1,1);
        n = 1;
        for i = sz_path_ver+1:sz_path_ver+sz_point_hor1
            len_row = area1_1(i,1)-area1_2(i,1)+1;
            if isempty(index_hor1)==1
                path_valley1_val = path_valley1_vir;
                len_valley1_val = 0;
            else
                path_valley1_val = path_valley1(1:index_hor1(n),:);
                len_valley1_val = sum(len_valley1(1:index_hor1(n)-1));
            end
            for j = 1:len_row
                k = k+1;
                Path1(k) = {[path_ver;path_valley1_val;Path_area1{k}]};
                min_len = sum_len_ver+len_valley1_val+Len_area1(k);
                Min_len = [Min_len,min_len];
            end
            n = n+1;
        end
        num_path_area1 = k;

        % Area 2
        k = 0;
        % From the source node to the upper intersection of the symmetrical dividing line and the rectangle
        x_range1 = xSource:-1:point_ver(1,1)+1;
        path_hor1(:,1) = x_range1;
        path_hor1(:,2) = ySource;
        sum_len_hor1 = sum(W(x_range1+1,ySource+1));
        % From the intersection of the symmetrical dividing line and the upper rectangle to
        % the intersection of the valley line and the upper rectangle
        path_hor = boundary_hor1;
        len_hor = W(x_range+1,ySource+1);
        sz_path_hor = size(path_hor,1);
        for i = 1:sz_path_hor
            len_col = area2_1(i,2)-area2_2(i,2)+1;
            path_hor_val = path_hor(1:i,:);
            len_hor_val = sum(len_hor(1:i-1));
            for j = 1:len_col
                k = k+1;
                Path2(k) = {[path_hor1;path_hor_val;Path_area2{k}]};
                min_len = sum_len_hor1+len_hor_val+Len_area2(k);
                Min_len = [Min_len,min_len];
            end
        end

        path_hor = [path_hor1;path_hor];
        sum_len_hor = sum_len_hor1+sum(len_hor);
        sz_point_ver2 = size(point_ver2,1);
        n = 1;
        for i = sz_path_hor+1:sz_path_hor+sz_point_ver2
            len_col = area2_1(i,2)-area2_2(i,2)+1;
            path_valley2_val = path_valley2(1:index_ver2(n),:);
            len_valley2_val = sum(len_valley2(1:index_ver2(n)-1));
            for j = 1:len_col
                k = k+1;
                Path2(k) = {[path_hor;path_valley2_val;Path_area2{k}]};
                min_len = sum_len_hor+len_valley2_val+Len_area2(k);
                Min_len = [Min_len,min_len];
            end
            n = n+1;
        end
        num_path_area2 = k;

        % Area 3
        if isempty(path_valley1)==0
            k = 0;
            for i = 1:size(point_ver1,1)
                len_col = area3_1(i,2)-area3_2(i,2)+1;
                path_valley1_val = path_valley1(1:index_ver1(i),:);
                len_valley1_val = sum(len_valley1(1:index_ver1(i)-1));
                for j = 1:len_col
                    k = k+1;
                    Path3(k) = {[path_ver;path_valley1_val;Path_area3{k}]};
                    min_len = sum_len_ver+len_valley1_val+Len_area3(k);
                    Min_len = [Min_len,min_len];
                end
            end
            num_path_area3 = k;
        end

        % Area 4
        if isempty(path_valley2)==0
            k = 0;
            for i = 1:size(point_hor2,1)
                len_row = area4_1(i,1)-area4_2(i,1)+1;
                path_valley2_val = path_valley2(1:index_hor2(i),:);
                len_valley2_val = sum(len_valley2(1:index_hor2(i)-1));
                for j = 1:len_row
                    k = k+1;
                    Path4(k) = {[path_hor;path_valley2_val;Path_area4{k}]};
                    min_len = sum_len_hor+len_valley2_val+Len_area4(k);
                    Min_len = [Min_len,min_len];
                end
            end
            num_path_area4 = k;
        end

        Path = [Path1,Path2,Path3,Path4];
        % remove the path from the source node to itself
        if point_sy_end(1,2)==ySource
            Path(1) = [];
            Min_len(1) = [];
        else
            Path(num_path_area1+1) = [];
            Min_len(num_path_area1+1) = [];
        end
    else % Rectangle has no symmetrical dividing line
        if isempty(path_valley1)==1 && isempty(path_valley2)==1 % No valley lines go through the rectangle
            if W(xDestination+1,ySource+1)<W(xSource+1,yDestination+1) % case 1(Area 1)
                k = 0;
                path_hor = area1_1;
                len_hor = W(x_range+1,ySource+1);
                sz_path_hor = size(path_hor,1);
                for i = 1:sz_path_hor
                    len_col = area1_1(i,2)-area1_2(i,2)+1;
                    path_hor_val = path_hor(1:i,:);
                    len_hor_val = sum(len_hor(1:i-1));
                    for j = 1:len_col
                        k = k+1;
                        Path1(k) = {[path_hor_val;Path_area1{k}]};
                        min_len = len_hor_val+Len_area1(k);
                        Min_len = [Min_len,min_len];
                    end
                end
                num_path_area1 = k;
            else % case 2(Area 2)
                k = 0;
                path_ver = area2_1;
                len_col = V*ones(size(path_ver,1),1);
                sz_path_ver = size(path_ver,1);
                for i = 1:sz_path_ver
                    len_row = area2_1(i,1)-area2_2(i,1)+1;
                    path_ver_val = path_ver(1:i,:);
                    len_ver_val = sum(len_col(1:i-1));
                    for j = 1:len_row
                        k = k+1;
                        Path2(k) = {[path_ver_val;Path_area2{k}]};
                        min_len = len_ver_val+Len_area2(k);
                        Min_len = [Min_len,min_len];
                    end
                end
                num_path_area2 = k;
            end
        elseif isempty(path_valley1)==0
            % Area 1
            k = 0;
            path_ver = boundary_ver1;
            sz_path_ver = size(path_ver,1);
            len_ver = V*ones(sz_path_ver,1);
            sum_len_ver = sum(len_ver);
            for i = 1:size(point_ver1,1)
                len_col = area1_1(i,2)-area1_2(i,2)+1;
                path_valley1_val = path_valley1(1:index_ver1(i),:);
                len_valley1_val = sum(len_valley1(1:index_ver1(i)-1));
                for j = 1:len_col
                    k = k+1;
                    Path1(k) = {[path_ver;path_valley1_val;Path_area1{k}]};
                    min_len = sum_len_ver+len_valley1_val+Len_area1(k);
                    Min_len = [Min_len,min_len];
                end
            end
            num_path_area1 = k;

            % Area 2
            k = 0;
            for i = 1:sz_path_ver
                len_row = area2_1(i,1)-area2_2(i,1)+1;
                path_ver_val = path_ver(1:i,:);
                len_ver_val = sum(len_ver(1:i-1));
                for j = 1:len_row
                    k = k+1;
                    Path2(k) = {[path_ver_val;Path_area2{k}]};
                    min_len = len_ver_val+Len_area2(k);
                    Min_len = [Min_len,min_len];
                end
            end

            sz_point_hor1 = size(point_hor1,1);
            n = 1;
            for i = sz_path_ver+1:sz_path_ver+sz_point_hor1
                len_row = area2_1(i,1)-area2_2(i,1)+1;
                if isempty(index_hor1)==1
                    path_valley1_val = path_valley1_vir;
                    len_valley1_val = 0;
                else
                    path_valley1_val = path_valley1(1:index_hor1(n),:);
                    len_valley1_val = sum(len_valley1(1:index_hor1(n)-1));
                end                
                for j = 1:len_row
                    k = k+1;
                    Path2(k) = {[path_ver;path_valley1_val;Path_area2{k}]};
                    min_len = sum_len_ver+len_valley1_val+Len_area2(k);
                    Min_len = [Min_len,min_len];
                end
                n = n+1;
            end
            num_path_area2 = k;
        elseif isempty(path_valley2)==0
            % Area 1
            k = 0;
            path_hor = boundary_hor1;
            sz_path_hor = size(path_hor,1);
            len_hor = W(x_range1+1,ySource+1);
            sum_len_hor = sum(len_hor);
            for i = 1:sz_path_hor
                len_col = area1_1(i,2)-area1_2(i,2)+1;
                path_hor_val = path_hor(1:i,:);
                len_hor_val = sum(len_hor(1:i-1));
                for j = 1:len_col
                    k = k+1;
                    Path1(k) = {[path_hor_val;Path_area1{k}]};
                    min_len = len_hor_val+Len_area1(k);
                    Min_len = [Min_len,min_len];
                end
            end

            sz_point_ver2 = size(point_ver2,1);
            n = 1;
            for i = sz_path_hor+1:sz_path_hor+sz_point_ver2
                len_col = area1_1(i,2)-area1_2(i,2)+1;
                path_valley2_val = path_valley2(1:index_ver2(n),:);
                len_valley2_val = sum(len_valley2(1:index_ver2(n)-1));
                for j = 1:len_col
                    k = k+1;
                    Path1(k) = {[path_hor;path_valley2_val;Path_area1{k}]};
                    min_len = sum_len_hor+len_valley2_val+Len_area1(k);
                    Min_len = [Min_len,min_len];
                end
                n = n+1;
            end
            num_path_area1 = k;

            % Area 2
            k = 0;
            for i = 1:size(point_hor2,1)
                len_row = area2_1(i,1)-area2_2(i,1)+1;
                path_valley2_val = path_valley2(1:index_hor2(i),:);
                len_valley2_val = sum(len_valley2(1:index_hor2(i)-1));
                for j = 1:len_row
                    k = k+1;
                    Path2(k) = {[path_hor;path_valley2_val;Path_area2{k}]};
                    min_len = sum_len_hor+len_valley2_val+Len_area2(k);
                    Min_len = [Min_len,min_len];
                end
                n = n+1;
            end
            num_path_area2 = k;
        end
        Path = [Path1,Path2];
        % remove the path from the source node to itself
        if isempty(path_valley1)==0
            Path(num_path_area1+1) = [];
            Min_len(num_path_area1+1) = [];
        else
            Path(1) = [];
            Min_len(1) = [];
        end
    end
end