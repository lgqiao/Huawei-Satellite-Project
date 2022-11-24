function [Path,Path_expand,Min_len,index_hor,index_ver] = my_expand_quad(map,W,t)
%MY_EXPAND_QUAD1: Compute the shortest path from the source node to other 
%                 nodes in the area on the extended map


size_map = size(map,1);
[max_x,max_y] = size(W);
W_expand = [W,W,W;W,W,W;W,W,W];

%Initialize MAP with location of the destination
xDestination = map(size_map,1);
yDestination = map(size_map,2);

%Initialize MAP with location of the obstacle
for i = 2: size_map-1
    xObstacle = map(i,1);
    yObstacle = map(i,2);
end

%Initialize MAP with location of the source
xSource = map(1,1);
ySource = map(1,2);

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
    [path_expand1,len1] = path_generate_expand2(x_s,y_s,x_d1,y_d1,W_expand,1);
    [path_expand2,len2] = path_generate_expand2(x_s,y_s,x_d2,y_d2,W_expand,1);
    
    for i = 2:length(path_expand1)
        Path_expand1(i-1) = {path_expand1(1:i,:)};
        min_len1 = sum(len1(1:i-1));
        Min_len1 = [Min_len1,min_len1];
    end
    for i = 2:length(path_expand2)
        Path_expand2(i-1) = {path_expand2(1:i,:)};
        min_len2 = sum(len2(1:i-1));
        Min_len2 = [Min_len2,min_len2];
    end

    Path_expand_full = [Path_expand1,Path_expand2];
    Min_len_full = [Min_len1,Min_len2];
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
    [path_expand1,len1] = path_generate_expand2(x_s,y_s,x_d1,y_d1,W_expand,1);
    [path_expand2,len2] = path_generate_expand2(x_s,y_s,x_d2,y_d2,W_expand,1);
    
    for i = 2:length(path_expand1)
        Path_expand1(i-1) = {path_expand1(1:i,:)};
        min_len1 = sum(len1(1:i-1));
        Min_len1 = [Min_len1,min_len1];
    end
    for i = 2:length(path_expand2)
        Path_expand2(i-1) = {path_expand2(1:i,:)};
        min_len2 = sum(len2(1:i-1));
        Min_len2 = [Min_len2,min_len2];
    end

    Path_expand_full = [Path_expand1,Path_expand2];
    Min_len_full = [Min_len1,Min_len2];
else
    % Determine the inner boundary points and outer boundary points of each subregion
    [area_inner,area_outer] = area_expand(xSource,ySource,xDestination,yDestination,max_x,max_y);
    
    % Mark points within the sub-area on the expanded map
    MAP = map_label(xSource,ySource,xDestination,yDestination,area_inner,area_outer,max_x,max_y);
    
    % Calculate and adjust boundary node
    % sub_area1
    if area_outer(1,1)>=area_inner(1,1) && area_outer(1,2)>=area_inner(1,2)
        boundary1 = boundary_expand(x_s,y_s,area_outer(1,1),area_outer(1,2),W,t);
        boundary1_adjust = boundary_adjust(boundary1,area_inner(1,:),area_outer(1,:));
        [Path_expand1,Min_len1,MAP1] = path_boundary(x_s,y_s,boundary1_adjust,MAP,W,t,1);
    else
        Path_expand1 = {};
        Min_len1 = [];
        MAP1 = MAP;
    end
    % sub_area2
    if area_outer(2,1)<=area_inner(2,1) && area_outer(2,2)<=area_inner(2,2)
        boundary2 = boundary_expand(x_s,y_s,area_outer(2,1),area_outer(2,2),W,t);
        boundary2_adjust = boundary_adjust(boundary2,area_inner(2,:),area_outer(2,:));
        [Path_expand2,Min_len2,MAP2] = path_boundary(x_s,y_s,boundary2_adjust,MAP1,W,t,1);
    else
        Path_expand2 = {};
        Min_len2 = [];
        MAP2 = MAP1;
    end
    % sub_area3
    if area_outer(3,1)>=area_inner(3,1) && area_outer(3,2)<=area_inner(3,2)
        boundary3 = boundary_expand(x_s,y_s,area_outer(3,1),area_outer(3,2),W,t);
        boundary3_adjust = boundary_adjust(boundary3,area_inner(3,:),area_outer(3,:));
        [Path_expand3,Min_len3,MAP3] = path_boundary(x_s,y_s,boundary3_adjust,MAP2,W,t,2);
    else
        Path_expand3 = {};
        Min_len3 = [];
        MAP3 = MAP2;
    end
    % sub_area4
    if area_outer(4,1)<=area_inner(4,1) && area_outer(4,2)>=area_inner(4,2)
        boundary4 = boundary_expand(x_s,y_s,area_outer(4,1),area_outer(4,2),W,t);
        boundary4_adjust = boundary_adjust(boundary4,area_inner(4,:),area_outer(4,:));
        [Path_expand4,Min_len4,MAP4] = path_boundary(x_s,y_s,boundary4_adjust,MAP3,W,t,2);
    else
        Path_expand4 = {};
        Min_len4 = [];
        MAP4 = MAP3;
    end
   
    [Path_expand5,Min_len5] = path_vacancy(x_s,y_s,MAP4,W,t);

    Path_expand_full = [Path_expand1,Path_expand2,Path_expand3,Path_expand4,Path_expand5];
    Min_len_full = [Min_len1,Min_len2,Min_len3,Min_len4,Min_len5];
end

[Path,Path_expand,Min_len,Destination] = path_select_expand(Path_expand_full,Min_len_full,W);

index_hor = find(Destination(:,2)==ySource)';
index_ver = find(Destination(:,1)==xSource)';

end
