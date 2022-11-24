function boundary = boundary_nodes(x1,y1,x2,y2,W,t)
%BOUNDARY_NODES: Calculate the boundary nodes of each area in the rectangle

xSource = x1;
ySource = y1;
xDestination = x2;
yDestination = y2;
dx = xDestination-xSource;
dy = yDestination-ySource;
k_l = dy/dx;

if k_l>0
    % Get the intersection of the valley line with the rectangle
    inter_valley = inter_square(xSource,ySource,xDestination,yDestination,t,1);
    [num_ver,num_hor] = inter_num(inter_valley,xSource);

    % get the end of the valley line
    if num_ver>0
        I = num_ver;
        point_valley1_end = round(inter_valley(I,:));
    end
    if num_hor>0
        I = num_ver+1;
        point_valley2_end = round(inter_valley(I,:));
    end

    % Get the symmetric dividing line and its boundary points
    [point_sy_end,point_ver,point_hor] = symmetric_dividing(xSource,ySource,xDestination,yDestination,t);

    % point_hor is an empty set
    if isempty(point_hor)==1 && isempty(point_ver)==0
        point_hor(1,1) = point_ver(end,1);
        point_hor(1,2) = point_ver(1,2)+1;
    end

%     % If the valley line and the symmetrical dividing line coincide,
%     % then it is considered that there is no symmetrical dividing line.
%     point_sy_end1 = point_sy_end;
%     if isempty(point_sy_end1)==0
%         if isempty(point_valley1_end)==0
%             if point_sy_end1(2)==point_valley1_end(2)
%                 point_sy_end = [];
%             end
%         end
%         if isempty(point_valley2_end)==0
%             if point_sy_end1(1)==point_valley2_end(1)
%                 point_sy_end = [];
%             end
%         end
%         if point_sy_end1(1)==point_sy_end1(3) && point_sy_end1(2)==point_sy_end1(4) % Symmetric dividing line is only one point
%             point_sy_end = [];
%         end
%     end

    boundary1 = [];
    boundary2 = [];
    boundary3 = [];
    boundary4 = [];

    % Get the boundaries of each area
    if dx>0 % the fourth quadrant direction
        if isempty(point_sy_end)==0
            % Area 1
            if isempty(point_valley1_end)==0
                boundary1(:,2) = point_hor(end,2)+1:point_valley1_end(4);
            else
                boundary1(:,2) = point_hor(end,2)+1:yDestination;
            end
            boundary1(:,1) = xDestination;
            boundary1 = [point_hor;boundary1];

            % Shift the point_hor left one space
            point_hor(:,1) = point_hor(:,1)-1;
            boundary1 = [point_hor;boundary1];

            % Area 2
            if isempty(point_valley2_end)==0
                boundary2(:,1) = point_ver(end,1)+1:point_valley2_end(3);
            else
                boundary2(:,1) = point_ver(end,1)+1:xDestination;
            end
            boundary2(:,2) = yDestination;
            boundary2 = [point_ver;boundary2];

            % Shift the point_hor up one space
            point_ver(:,2) = point_ver(:,2)-1;
            boundary2 = [point_ver;boundary2];

            % Area 3
            if isempty(point_valley1_end)==0
                boundary3(:,1) = xSource:point_valley1_end(3);
                boundary3(:,2) = yDestination;
            end

            % Area 4
            if isempty(point_valley2_end)==0
                boundary4(:,2) = ySource:point_valley2_end(4);
                boundary4(:,1) = xDestination;
            end
        else
            if isempty(point_valley1_end)==1 && isempty(point_valley2_end)==1
                if W(xDestination+1,ySource+1)<W(xSource+1,yDestination+1)
                    % Area 1
                    boundary1(:,1) = xSource:xDestination;
                    boundary1(:,2) = yDestination;
                else
                    % Area 2
                    boundary2(:,2) = ySource:yDestination;
                    boundary2(:,1) = xDestination;
                end
            elseif isempty(point_valley1_end)==0
                % Area 1
                boundary1(:,1) = xSource:point_valley1_end(3);
                boundary1(:,2) = yDestination;

                % Area 2
                boundary2(:,2) = ySource:point_valley1_end(4);
                boundary2(:,1) = xDestination;
            elseif isempty(point_valley2_end)==0
                % Area 1
                boundary1(:,1) = xSource:point_valley2_end(3);
                boundary1(:,2) = yDestination;

                % Area 2
                boundary2(:,2) = ySource:point_valley2_end(4);
                boundary2(:,1) = xDestination;
            end
        end
    elseif dx<0 % the second quadrant direction
        if isempty(point_sy_end)==0
            % Area 1
            if isempty(point_valley1_end)==0
                boundary1(:,2) = point_hor(end,2)-1:-1:point_valley1_end(4);
            else
                boundary1(:,2) = point_hor(end,2)-1:-1:yDestination;
            end
            boundary1(:,1) = xDestination;
            boundary1 = [point_hor;boundary1];

            % Shift the point_hor right one space
            point_hor(:,1) = point_hor(:,1)+1;
            boundary1 = [point_hor;boundary1];

            % Area 2
            if isempty(point_valley2_end)==0
                boundary2(:,1) = point_ver(end,1)-1:-1:point_valley2_end(3);
            else
                boundary2(:,1) = point_ver(end,1)-1:-1:xDestination;
            end
            boundary2(:,2) = yDestination;
            boundary2 = [point_ver;boundary2];

            % Shift the point_hor down one space
            point_ver(:,2) = point_ver(:,2)+1;
            boundary2 = [point_ver;boundary2];

            % Area 3
            if isempty(point_valley1_end)==0
                boundary3(:,1) = xSource:-1:point_valley1_end(3);
                boundary3(:,2) = yDestination;
            end

            % Area 4
            if isempty(point_valley2_end)==0
                boundary4(:,2) = ySource:-1:point_valley2_end(4);
                boundary4(:,1) = xDestination;
            end
        else
            if isempty(point_valley1_end)==1 && isempty(point_valley2_end)==1
                if W(xDestination+1,ySource+1)<W(xSource+1,yDestination+1)
                    % Area 1
                    boundary1(:,1) = xSource:-1:xDestination;
                    boundary1(:,2) = yDestination;
                else
                    % Area 2
                    boundary2(:,2) = ySource:-1:yDestination;
                    boundary2(:,1) = xDestination;
                end
            elseif isempty(point_valley1_end)==0
                % Area 1
                boundary1(:,1) = xSource:-1:point_valley1_end(3);
                boundary1(:,2) = yDestination;

                % Area 2
                boundary2(:,2) = ySource:-1:point_valley1_end(4);
                boundary2(:,1) = xDestination;
            elseif isempty(point_valley2_end)==0
                % Area 1
                boundary1(:,1) = xSource:-1:point_valley2_end(3);
                boundary1(:,2) = yDestination;

                % Area 2
                boundary2(:,2) = ySource:-1:point_valley2_end(4);
                boundary2(:,1) = xDestination;
            end
        end
    end
    
    boundary = [boundary1;boundary2;boundary3;boundary4];

elseif k_l<0
    boundary1 = [xSource,yDestination;xDestination,ySource];

    % Compute duplicate path nodes for the upper and right boundaries of the rectangle
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

    if dx>0 % the first quadrant direction
        % The upper and right borders of the rectangle
        x_hor = xDestination:-1:xSource+1;
        y_ver = yDestination+1:ySource-1;

        % Remove duplicate path nodes for the upper and right borders of the rectangle
        for i = 1:sz_node_hor
            k_hor = x_hor>=duplicate_hor(i,2) & x_hor<=duplicate_hor(i,1);
            x_hor(k_hor) = [];
        end
        for i = 1:sz_node_ver
            k_ver = y_ver>=duplicate_ver(i,1) & y_ver<=duplicate_ver(i,2);
            y_ver(k_ver) = [];
        end
    elseif dx<0 % the third quadrant direction
        % The lower and left borders of the rectangle
        x_hor = xDestination:xSource-1;
        y_ver = yDestination-1:-1:ySource+1;

        % Remove duplicate path nodes for the upper and right borders of the rectangle
        for i = 1:sz_node_hor
            k_hor = x_hor>=duplicate_hor(i,1) & x_hor<=duplicate_hor(i,2);
            x_hor(k_hor) = [];
        end
        for i = 1:sz_node_ver
            k_ver = y_ver>=duplicate_ver(i,2) & y_ver<=duplicate_ver(i,1);
            y_ver(k_ver) = [];
        end
    end

    boundary2(:,1) = x_hor;
    boundary2(:,2) = yDestination;
    boundary3(:,2) = y_ver;
    boundary3(:,1) = xDestination;

    for i = 1:sz_node_hor
        boundary2 = [boundary2;duplicate_hor(i,1),yDestination];
    end
    for i = 1:sz_node_ver
        boundary3 = [boundary3;xDestination,duplicate_ver(i,1)];
    end

    boundary = [boundary1;boundary2;boundary3];

end
