%% Calculate the shortest path from a source node to other nodes in an area
x1 = 0; 
y1 = 0; 
x2 = 59; 
y2 = 59; 
vertex = [x1,y1,x2,y2];

% source node
Source = [10,10];

% type = 1: Dijkstra_search
% type = 2: Dijkstra_expand
% type = 3: my_search
% type = 4: my_expand

% type = 3;
% tic
% [Path,~,Min_len,Time] = path_search_multi(vertex,Source,W,t,type);
% toc
% figure
% node = visualize_route_multi(Path,W,t,0);

type = 4;
tic
[Path,Path_expand,Min_len,Time] = path_search_multi(vertex,Source,W,t,type);
toc
% figure
% node = visualize_route_multi(Path,W,t,1);
figure
node_expand = visualize_expand_multi(Path_expand,W,t);
