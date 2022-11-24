function [Path,Min_len,T] = data_sta_node(Source,Destination,W,t,type)
%DATA_STA_NODE: Calculate the length of the shortest path between multiple pairs of nodes and the time 
% to find the shortest path, and calculate the average value


Path = {};
Min_len = [];

num_pair = size(Source,1);

% Choose an algorithm to compute the shortest path
% type = 1: Dijkstra_search
% type = 2: Dijkstra_expand
% type = 3: my_search
% type = 4: my_expand
if type==1
    for i = 1:num_pair
        map = map_construct(W,Source(i,:),Destination(i,:));
        tic
        [path,min_len] = Dijkstra_search(map,W);
        T(i) = toc;
        Path(i) = {path};
        Min_len(i) = min_len;
    end
elseif type==2
    for i = 1:num_pair
        map = map_construct(W,Source(i,:),Destination(i,:));
        tic
        [path,min_len] = Dijkstra_expand(map,W);
        T(i) = toc;
        Path(i) = {path};
        Min_len(i) = min_len;
    end
elseif type==3
    for i = 1:num_pair
        map = map_construct(W,Source(i,:),Destination(i,:));
        tic
        [path,min_len] = my_search(map,W,t);
        T(i) = toc;
        Path(i) = {path};
        Min_len(i) = min_len;
    end
elseif type==4
    for i = 1:num_pair
        map = map_construct(W,Source(i,:),Destination(i,:));
        tic
        [~,~,path,min_len] = my_expand(map,W,t);
        T(i) = toc;
        Path(i) = {path};
        Min_len(i) = min_len;
    end
end

% mean_time = sum(T)/num_pair;
% mean_length = sum(Min_len)/num_pair;

end
