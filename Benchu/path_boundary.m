function [Path_expand,Min_len,MAP_new] = path_boundary(x_s,y_s,boundary,MAP,W,t,type)
%PATH_BOUNDARY: Calculate the shortest path from source node to boundary nodes


Path_expand = {};
Min_len = [];

[max_x,max_y] = size(W);
W_expand = [W,W,W;W,W,W;W,W,W];

xSource = x_s-max_x;
ySource = y_s-max_y;
k = 0;
len_boundary = size(boundary,1);

if type==1
    % Compute the shortest path from the source node to the boundary nodes
    for i = 1:len_boundary
        x_d = boundary(i,1);
        y_d = boundary(i,2);
        xDestination = mod(x_d,max_x);
        yDestination = mod(y_d,max_y);
        if x_s==x_d || y_s==y_d
            [path,len] = path_generate_ex(x_s,y_s,x_d,y_d,W_expand,1);
        else
            % Calculate the intersection of rectangle and valley
            inter = inter_square_valley(x_s,y_s,x_d,y_d,t);
            num_valley = size(inter,1); % number of intersections
            if num_valley==0
                if W(xDestination+1,ySource+1)<=W(xSource+1,yDestination+1)
                    [path,len] = path_generate_ex(x_s,y_s,x_d,y_d,W_expand,2);
                else
                    [path,len] = path_generate_ex(x_s,y_s,x_d,y_d,W_expand,1);
                end
            elseif num_valley==1
                [path1,len1] = path_generate_ex(x_s,y_s,inter(1,1),inter(1,2),W_expand,1);
                [path2,len2] = path_generate_ex(inter(1,1),inter(1,2),inter(1,3),inter(1,4),W_expand,3);
                [path3,len3] = path_generate_ex(inter(1,3),inter(1,4),x_d,y_d,W_expand,1);
                if path1(end,:)==path3(1,:)
                    path3(1,:) = [];
                end
                path = [path1;path2;path3];
                len = [len1;len2;len3];
            else
                dx_inter = abs(inter(:,3)-inter(:,1));
                I = find(dx_inter==max(dx_inter), 1, 'last' );
                [path1,len1] = path_generate_ex(x_s,y_s,inter(I,1),inter(I,2),W_expand,1);
                [path2,len2] = path_generate_ex(inter(I,1),inter(I,2),inter(I,3),inter(I,4),W_expand,3);
                [path3,len3] = path_generate_ex(inter(I,3),inter(I,4),x_d,y_d,W_expand,1);
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
            elseif mod(x_d,max_x)==xSource && mod(y_d,max_y)==ySource
                continue
            else
                break
            end
        end

        % Compute the shortest path from the source node to the uncomputed node
        num_index = length(row_index);
        for n = 1:num_index
            k = k+1;
            row = row_index(n);
            Path_expand(k) = {path(1:row,:)};
            min_len = sum(len(1:row-1));
            Min_len = [Min_len,min_len];
        end
    end
elseif type==2
    % Compute the shortest path from the source node to the boundary nodes
    for i = 1:len_boundary
        x_d = boundary(i,1);
        y_d = boundary(i,2);
        if x_s==x_d || y_s==y_d
            [path,len] = path_generate_ex(x_s,y_s,x_d,y_d,W_expand,1);
        else
            [S,D,delta_x,delta_y] = inter_sd_pair(x_s,y_s,x_d,y_d,t); % Calculate start and end points of line segments
            cross_point = line_cross(S,D,delta_x,delta_y); % Calculate the intersection of line segments with valley and peak lines
            if isempty(cross_point)==1
                point = [x_s,y_s;x_d,y_d];
                % Determine the type of the shortest path between the source node and the first intersection and mark it with flag
                if y_s==S(2) && x_d==D(1)
                    flag = 1;
                else
                    flag = 2;
                end
            else
                point = [x_s,y_s;cross_point;x_d,y_d];
                y_1 = fx_valley_ex(point(2,1),t);
                k_1 = find(y_1>point(2,2)-0.5 & y_1<point(2,2)+0.5,1);
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
                [path_val,len_val] = path_generate_ex(point(j,1),point(j,2),point(j+1,1),point(j+1,2),W_expand,mod(flag,2)+1);
                path_val(end,:) = [];
                path = [path;path_val];
                len = [len;len_val];
                flag = flag+1;
            end
            path = [path;x_d,y_d];
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
            Path_expand(k) = {path(1:row,:)};
            min_len = sum(len(1:row-1));
            Min_len = [Min_len,min_len];
        end
    end
end

MAP_new = MAP;

end
