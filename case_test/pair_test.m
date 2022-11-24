%% Calculate the shortest path between the source node and the destination node 
Source = [5,2]; % [xSource,ySource]
Destination = [41,8]; % [xDestination,yDestination]

map = map_construct(W,Source,Destination);

% Dijkstra algorithm
tic
[path1,min_len1] = Dijkstra_search(map,W);
toc   
figure
visualize_route(path1,W,t,0);
% visualize_expand(path1,W,t);
  
% % Symmetric geometry algorithm
% tic
% [path2,min_len2] = my_search(map,W,t);
% toc
% figure
% visualize_route(path2,W,t,0);
% % visualize_expand(path2,W,t);
