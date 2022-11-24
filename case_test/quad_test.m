%% Compute the shortest path from a source node to other nodes in a quadrant
x1 = 55; % 0~74
y1 = 5; % 0~74
x2 = 5; % 0~74
y2 = 25; % 0~74
Source = [x1,y1];
Destination = [x2,y2];
map = map_construct(W,Source,Destination);

% Symmetric Polyline Segment Method
dx = x2-x1;
dy = y2-y1;

if dx>=0 && dy<=0 % first quadrant
    tic
    [Path,Min_len] = my_search_quad1_new(map,W,t);
    toc
elseif dx<=0 && dy<=0 % second quadrant
    tic
    [Path,Min_len] = my_search_quad2_new(map,W,t);
    toc
elseif dx<=0 && dy>=0 % third quadrant
    tic
    [Path,Min_len] = my_search_quad3_new(map,W,t);
    toc
elseif dx>=0 && dy>=0 % fourth quadrant
    tic
    [Path,Min_len] = my_search_quad4_new(map,W,t);
    toc
end
figure
node = visualize_route_multi(Path,W,t,0);