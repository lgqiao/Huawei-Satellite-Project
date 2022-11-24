function [Path,Min_len] = my_search_full(vertex,Source,W,t)
%MY_SEARCH_FULL: Calculate the shortest path from a source node to other nodes in an area
%                Directions include all four directions


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
    map1 = map_construct(W,Source,vertex1);
    [Path1,Min_len1] = my_search_quad1(map1,W,t);   
    dx_quad1 = x2-x_s;
    dy_quad1 = y_s-y1;
    num_duplicate1 = dx_quad1+dy_quad1;
    Path1(1:num_duplicate1) = [];
    Min_len1(1:num_duplicate1) = [];

    % second quadrant
    map2 = map_construct(W,Source,vertex2);
    [Path2,Min_len2] = my_search_quad2(map2,W,t);

    % third quadrant
    map3 = map_construct(W,Source,vertex3);
    [Path3,Min_len3] = my_search_quad3(map3,W,t);
    dx_quad3 = x_s-x1;
    dy_quad3 = y2-y_s;
    num_duplicate3 = dx_quad3+dy_quad3;
    Path3(1:num_duplicate3) = [];
    Min_len3(1:num_duplicate3) = [];

    % fourth quadrant
    map4 = map_construct(W,Source,vertex4);
    [Path4,Min_len4] = my_search_quad4(map4,W,t);

    Path = [Path1,Path2,Path3,Path4];
    Min_len = [Min_len1,Min_len2,Min_len3,Min_len4];
elseif x_s>x1 && x_s<x2 && y_s==y1 % case2, the source node is on the upper bound of the rectangle
    % third quadrant
    map3 = map_construct(W,Source,vertex3);
    [Path3,Min_len3] = my_search_quad3(map3,W,t);
    dy_quad3 = y2-y_s;
    num_duplicate3 = dy_quad3;
    Path3(1:num_duplicate3) = [];
    Min_len3(1:num_duplicate3) = [];

    % fourth quadrant
    map4 = map_construct(W,Source,vertex4);
    [Path4,Min_len4] = my_search_quad4(map4,W,t);
    
    Path = [Path3,Path4];
    Min_len = [Min_len3,Min_len4];
elseif x_s>x1 && x_s<x2 && y_s==y2 % case3, the source node is on the lower bound of the rectangle
    % first quadrant
    map1 = map_construct(W,Source,vertex1);
    [Path1,Min_len1] = my_search_quad1(map1,W,t);   
    dy_quad1 = y_s-y1;
    num_duplicate1 = dy_quad1;
    Path1(1:num_duplicate1) = [];
    Min_len1(1:num_duplicate1) = [];

    % second quadrant
    map2 = map_construct(W,Source,vertex2);
    [Path2,Min_len2] = my_search_quad2(map2,W,t);

    Path = [Path1,Path2];
    Min_len = [Min_len1,Min_len2];
elseif y_s>y1 && y_s<y2 && x_s==x1 % case4, the source node is on the left bound of the rectangle
    % first quadrant
    map1 = map_construct(W,Source,vertex1);
    [Path1,Min_len1] = my_search_quad1(map1,W,t);   
    dx_quad1 = x2-x_s;
    dy_quad1 = y_s-y1;
    num_duplicate1 = dx_quad1+dy_quad1;
    Path1(dy_quad1+1:num_duplicate1) = [];
    Min_len1(dy_quad1+1:num_duplicate1) = [];

    % fourth quadrant
    map4 = map_construct(W,Source,vertex4);
    [Path4,Min_len4] = my_search_quad4(map4,W,t);

    Path = [Path1,Path4];
    Min_len = [Min_len1,Min_len4];
elseif y_s>y1 && y_s<y2 && x_s==x2 % case5, the source node is on the right bound of the rectangle
    % second quadrant
    map2 = map_construct(W,Source,vertex2);
    [Path2,Min_len2] = my_search_quad2(map2,W,t);

    % third quadrant
    map3 = map_construct(W,Source,vertex3);
    [Path3,Min_len3] = my_search_quad3(map3,W,t);
    dx_quad3 = x_s-x1;
    dy_quad3 = y2-y_s;
    num_duplicate3 = dx_quad3+dy_quad3;
    Path3(dy_quad3+1:num_duplicate3) = [];
    Min_len3(dy_quad3+1:num_duplicate3) = [];
    
    Path = [Path2,Path3];
    Min_len = [Min_len2,Min_len3];
elseif x_s==x1 && y_s==y2 % case6, the source node is the lower left vertex of the rectangle
    % first quadrant
    map1 = map_construct(W,Source,vertex1);
    [Path,Min_len] = my_search_quad1(map1,W,t);
elseif x_s==x2 && y_s==y2 % case7, the source node is the lower right vertex of the rectangle
    % second quadrant
    map2 = map_construct(W,Source,vertex2);
    [Path,Min_len] = my_search_quad2(map2,W,t);
elseif x_s==x2 && y_s==y1 % case8, the source node is the top right vertex of the rectangle
    % third quadrant
    map3 = map_construct(W,Source,vertex3);
    [Path,Min_len] = my_search_quad3(map3,W,t);
elseif x_s==x1 && y_s==y1 % case9, the source node is the top left vertex of the rectangle
    % fourth quadrant
    map4 = map_construct(W,Source,vertex4);
    [Path,Min_len] = my_search_quad4(map4,W,t);
end

end
