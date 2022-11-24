% Calculate the shortest path using symmetric geometry on extended map
Source = [10,10]; % [xSource,ySource]
Destination = [50,50]; % [xDestination,yDestination]

map = map_construct(W,Source,Destination);

% Dijkstra algorithm
% tic
% [path1,min_len1] = Dijkstra_expand(map,W);
% toc   
% figure
% visualize_route(path1,W,t,1);
% visualize_expand(path1,W,t);

% Symmetric geometry algorithm
tic
[Path_expand,path_expand,path2,min_len2] = my_expand(map,W,t);
toc
figure
visualize_route(path2,W,t,1);
figure
visualize_expand(path_expand,W,t);
figure
visualize_expand_full(Path_expand,W,t);