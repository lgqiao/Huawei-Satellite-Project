%% Calculate the shortest path from the source node to other nodes within a rectangle(expand)
% Determine the two vertices of the rectangle
x1 = 0;
y1 = 0; 
x2 = 59; 
y2 = 29;
vertex = [x1,y1,x2,y2];

% source node
Source1 = [35,19];

% Dijkstra algorithm
% Destination = Dijkstra_node(vertex,Source,W,t);
% map = map_construct(W,Source,Destination);
% tic
% [Path,Min_len] = Dijkstra_expand_spt(map,W,vertex,2);
% toc
% Path = path_remove(Path,vertex);
% figure
% node = visualize_route_multi(Path,W,t,1);

% Symmetric geometry algorithm
tic
[Path,Path_expand,Min_len] = my_expand_spt(vertex,Source1,W,t);
toc
% figure
% node = visualize_route_multi(Path,W,t,1);
% figure
% node_expand = visualize_expand_multi(Path_expand,W,t);
