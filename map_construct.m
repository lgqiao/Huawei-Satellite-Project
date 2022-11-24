function map = map_construct(W,Source,Destination)
%MAP_CONSTRUCT: Construct the map according to the distance matrix and the location of source 
%               and destination nodes 


map = [];
map(1,1) = Source(1);
map(1,2) = Source(2);

% Find missing edges in the distance matrix and place them in the map
k = 2;
% todo

map(k,1) = Destination(1);
map(k,2) = Destination(2);

end

