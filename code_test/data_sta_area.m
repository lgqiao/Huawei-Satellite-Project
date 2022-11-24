function [Path,Min_len,area_T,node_T] = data_sta_area(vertex,Source,W,t,type)
%DATA_STA_AREA: Calculate the shortest path from a source node to other nodes in a rectangular area, 
%               possibly multiple source nodes and multiple rectangular areas
% type = 1: Dijkstra_search_spt
% type = 2: my_search_full


Path = {};
Min_len = {};

% Multiple source nodes in one area or multiple source nodes in multiple areas
num_area = size(vertex,1);
num_node = size(Source,1);

if type==1 % Dijkstra_search_spt
    Destination = Dijkstra_node(vertex,Source,W,t);
    for i = 1:num_node
        map = map_construct(W,Source(i,:),Destination(i,:));
        tic
        [Path1,Min_len1] = Dijkstra_search_spt(map,W);
        area_T(i,:) = toc;
        num_node_area = length(Path1);
        node_T(i,:) = area_T(i,:)/num_node_area;
        Path{i,1} = Path1;
        Min_len{i,1} = Min_len1;
    end
elseif type==2 % my_search_full
    if num_area==1
        for i = 1:num_node
            tic
            [Path1,Min_len1] = my_search_full(vertex,Source(i,:),W,t);
            area_T(i,:) = toc;
            num_node_area = length(Path1);
            node_T(i,:) = area_T(i,:)/num_node_area;
            Path{i,1} = Path1;
            Min_len{i,1} = Min_len1;
        end
    else
        for i = 1:num_node
            tic
            [Path1,Min_len1] = my_search_full(vertex(i,:),Source(i,:),W,t);
            area_T(i,:) = toc;
            num_node_area = length(Path1);
            node_T(i,:) = area_T(i,:)/num_node_area;
            Path{i,1} = Path1;
            Min_len{i,1} = Min_len1;
        end
    end
elseif type==3 % Dijkstra_expand_spt
    % Dijkstra algorithm
    Destination = Dijkstra_node(vertex,Source,W,t);
    if num_area==1
        for i = 1:num_node
            map = map_construct(W,Source(i,:),Destination(i,:));
            tic
            [Path1,Min_len1] = Dijkstra_expand_spt(map,W,vertex,2);
            area_T(i,:) = toc;
            num_node_area = length(Path1);
            node_T(i,:) = area_T(i,:)/num_node_area;
            Path{i,1} = Path1;
            Min_len{i,1} = Min_len1;
        end
    else
        for i = 1:num_node
            map = map_construct(W,Source(i,:),Destination(i,:));
            tic
            [Path1,Min_len1] = Dijkstra_expand_spt(map,W,vertex(i,:),2);
            area_T(i,:) = toc;
            num_node_area = length(Path1);
            node_T(i,:) = area_T(i,:)/num_node_area;
            Path{i,1} = Path1;
            Min_len{i,1} = Min_len1;
        end
    end
elseif type==4 % my_expand_full
    if num_area==1
        for i = 1:num_node
            tic
            [Path1,~,Min_len1] = my_expand_full_new(vertex,Source(i,:),W,t);
            area_T(i,:) = toc;
            num_node_area = length(Path1);
            node_T(i,:) = area_T(i,:)/num_node_area;
            Path{i,1} = Path1;
            Min_len{i,1} = Min_len1;
        end
    else
        for i = 1:num_node
            tic
            [Path1,~,Min_len1] = my_expand_full_new(vertex(i,:),Source(i,:),W,t);
            area_T(i,:) = toc;
            num_node_area = length(Path1);
            node_T(i,:) = area_T(i,:)/num_node_area;
            Path{i,1} = Path1;
            Min_len{i,1} = Min_len1;
        end
    end
end

end
