%% Calculate the shortest path from the source node to other nodes within a rectangle
% Determine the two vertices of the rectangle
x1 = 5; 
y1 = 5; 
x2 = 55;
y2 = 25; 
vertex = [x1,y1,x2,y2];

% source node
Source = [30,20];

% Dijkstra algorithm
Destination = Dijkstra_node(vertex,Source,W,t);
map = map_construct(W,Source,Destination);
tic
[Path,Min_len] = Dijkstra_search_spt(map,W);
toc
figure
node = visualize_route_multi(Path,W,t,1);

% Symmetric Polyline Segment Method
tic
[Path,Min_len] = my_search_full(vertex,Source,W,t);
toc
figure
node = visualize_route_multi(Path,W,t,0);
