function [Path,Path_expand,Min_len] = my_expand_spt(vertex,Source,W,t)
%MY_EXPAND_SPT: Compute shortest paths from one source node to other nodes in an area in the extended map
%               Directions include all four directions


% source node
x_s = Source(1);
y_s = Source(2);

% vertex records the vertices of the second and fourth quadrants
x1 = vertex(1);
y1 = vertex(2);
x2 = vertex(3);
y2 = vertex(4);

% four vertices of a rectangle
vertex1 = [x2,y1]; % first quadrant
vertex2 = [x1,y1]; % second quadrant
vertex3 = [x1,y2]; % third quadrant
vertex4 = [x2,y2]; % fourth quadrant

if x_s>x1 && x_s<x2 && y_s>y1 && y_s<y2 % case1, the source node is inside the rectangle
    % first quadrant
    [Path1,Path_expand1,Min_len1,index_hor1,index_ver1] = my_quad_spt(Source,vertex1,W,t);
    index_boundary1 = [index_hor1,index_ver1];
    Path1(index_boundary1) = [];
    Path_expand1(index_boundary1) = [];
    Min_len1(index_boundary1) = [];
    
    % second quadrant
    [Path2,Path_expand2,Min_len2,~,~] = my_quad_spt(Source,vertex2,W,t);

    % third quadrant
    [Path3,Path_expand3,Min_len3,index_hor3,index_ver3] = my_quad_spt(Source,vertex3,W,t);
    index_boundary3 = [index_hor3,index_ver3];
    Path3(index_boundary3) = [];
    Path_expand3(index_boundary3) = [];
    Min_len3(index_boundary3) = [];
    
    % fourth quadrant
    [Path4,Path_expand4,Min_len4,~,~] = my_quad_spt(Source,vertex4,W,t);

    Path_expand = [Path_expand1,Path_expand2,Path_expand3,Path_expand4];
    Path = [Path1,Path2,Path3,Path4];
    Min_len = [Min_len1,Min_len2,Min_len3,Min_len4];
elseif x_s>x1 && x_s<x2 && y_s==y1 % case2, the source node is on the upper bound of the rectangle
    % third quadrant
    [Path3,Path_expand3,Min_len3,~,index_ver3] = my_quad_spt(Source,vertex3,W,t);
    index_boundary3 = index_ver3;
    Path3(index_boundary3) = [];
    Path_expand3(index_boundary3) = [];
    Min_len3(index_boundary3) = [];
    
    % fourth quadrant
    [Path4,Path_expand4,Min_len4,~,~] = my_quad_spt(Source,vertex4,W,t);
    
    Path_expand = [Path_expand3,Path_expand4];
    Path = [Path3,Path4];
    Min_len = [Min_len3,Min_len4];
elseif x_s>x1 && x_s<x2 && y_s==y2 % case3, the source node is on the lower bound of the rectangle
    % first quadrant
    [Path1,Path_expand1,Min_len1,~,index_ver1] = my_quad_spt(Source,vertex1,W,t);
    index_boundary1 = index_ver1;
    Path1(index_boundary1) = [];
    Path_expand1(index_boundary1) = [];
    Min_len1(index_boundary1) = [];
    
    % second quadrant
    [Path2,Path_expand2,Min_len2,~,~] = my_quad_spt(Source,vertex2,W,t);
    
    Path_expand = [Path_expand1,Path_expand2];
    Path = [Path1,Path2];
    Min_len = [Min_len1,Min_len2];
elseif y_s>y1 && y_s<y2 && x_s==x1 % case4, the source node is on the left bound of the rectangle
    % first quadrant
    [Path1,Path_expand1,Min_len1,index_hor1,~] = my_quad_spt(Source,vertex1,W,t);
    index_boundary1 = index_hor1;
    Path1(index_boundary1) = [];
    Path_expand1(index_boundary1) = [];
    Min_len1(index_boundary1) = [];

    % fourth quadrant
    [Path4,Path_expand4,Min_len4,~,~] = my_quad_spt(Source,vertex4,W,t);
    
    Path_expand = [Path_expand1,Path_expand4];
    Path = [Path1,Path4];
    Min_len = [Min_len1,Min_len4];
elseif y_s>y1 && y_s<y2 && x_s==x2 % case5, the source node is on the right bound of the rectangle
    % second quadrant
    [Path2,Path_expand2,Min_len2,~,~] = my_quad_spt(Source,vertex2,W,t);

    % third quadrant
    [Path3,Path_expand3,Min_len3,index_hor3,~] = my_quad_spt(Source,vertex3,W,t);
    index_boundary3 = index_hor3;
    Path3(index_boundary3) = [];
    Path_expand3(index_boundary3) = [];
    Min_len3(index_boundary3) = [];
    
    Path_expand = [Path_expand2,Path_expand3];
    Path = [Path2,Path3];
    Min_len = [Min_len2,Min_len3];
elseif x_s==x1 && y_s==y2 % case6, the source node is the lower left vertex of the rectangle
    % first quadrant
    [Path,Path_expand,Min_len,~,~] = my_quad_spt(Source,vertex1,W,t);
elseif x_s==x2 && y_s==y2 % case7, the source node is the lower right vertex of the rectangle
    % second quadrant
    [Path,Path_expand,Min_len,~,~] = my_quad_spt(Source,vertex2,W,t);
elseif x_s==x2 && y_s==y1 % case8, the source node is the top right vertex of the rectangle
    % third quadrant
    [Path,Path_expand,Min_len,~,~] = my_quad_spt(Source,vertex3,W,t);
elseif x_s==x1 && y_s==y1 % case9, the source node is the top left vertex of the rectangle
    % fourth quadrant
    [Path,Path_expand,Min_len,~,~] = my_quad_spt(Source,vertex4,W,t);
end

end