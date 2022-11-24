function map = map_construct_multi(W,Source,Destination)
%MAP_CONSTRUCT_MULTI: Construct the map according to the distance matrix and the 
%                     location of source and destination nodes  


map = [];
num_pair = size(Destination,1);

for i = 1:num_pair
    map(1,1,i) = Source(1);
    map(1,2,i) = Source(2);

    % Find missing edges in the distance matrix and place them in the map
    k = 2;
    % todo

    map(k,1,i) = Destination(i,1);
    map(k,2,i) = Destination(i,2);
end

end

