%% Compute the shortest path from a source node to other nodes in a quadrant
x1 = 0;
y1 = 0; 
x2 = 55; 
y2 = 5; 
Source = [x1,y1];
Destination = [x2,y2];
map = map_construct(W,Source,Destination);

tic
[Path,Path_expand,Min_len,~,~] = my_expand_quad_new(map,W,t);
toc

figure
node = visualize_route_multi(Path,W,t,1);
figure
node_expand = visualize_expand_multi(Path_expand,W,t);
