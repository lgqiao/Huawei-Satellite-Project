function [Path_new,Min_len_new] = path_sorting(Path,Min_len,vertex)
%PATH_SORTING: Reorder shortest paths and shortest path lengths


Path_new = {};
Min_len_new = {};
num_area = size(vertex,1);

if num_area==1
    x1 = vertex(1);
    y1 = vertex(2);
    x2 = vertex(3);
    y2 = vertex(4);
    num_area_node = (x2-x1+1)*(y2-y1+1)-1;
    for i = 1:length(Path)
        Path_val = Path{i}; % Shortest path from source node i to other nodes in the region
        Min_len_val = Min_len{i}; % The length of the shortest path from source node i to other nodes in the region
        num_node = length(Path_val);
        % Initialize new path and path length
        Path_val_new = cell(1,num_area_node);
        Min_len_val_new = zeros(1,num_area_node);
        % The source node and the index of the source node in the rectangular area
        path_val = Path_val{1};
        Source = path_val(1,:);
        index_Source = (Source(2)-y1)*(x2-x1+1)+(Source(1)-x1+1);
        for j = 1:num_node
            path_val = Path_val{j};
            Destination = path_val(end,:);
            if ~(Destination(1)>=x1 && Destination(1)<=x2 && Destination(2)>=y1 && Destination(2)<=y2)
                Path_val{j} = [];
                continue
            end
            min_len_val = Min_len_val(j);
            index_Destination = (Destination(2)-y1)*(x2-x1+1)+(Destination(1)-x1+1);
            if index_Destination<index_Source
                Path_val_new{index_Destination} = path_val;
                Min_len_val_new(index_Destination) = min_len_val;
            else
                Path_val_new{index_Destination-1} = path_val;
                Min_len_val_new(index_Destination-1) = min_len_val;
            end
        end
        Path_new{i,1} = Path_val_new;
        Min_len_new{i,1} = Min_len_val_new;
    end
else
    for i = 1:num_area
        x1 = vertex(i,1);
        y1 = vertex(i,2);
        x2 = vertex(i,3);
        y2 = vertex(i,4);
        num_area_node = (x2-x1+1)*(y2-y1+1)-1;
        % path and path length in region i
        Path_val = Path{i};
        Min_len_val = Min_len{i};
        % number of nodes in region i (excluding source nodes)
        num_node = length(Path_val);
        % Initialize new path and path length
        Path_val_new = cell(1,num_area_node);
        Min_len_val_new = zeros(1,num_area_node);
        % The source node and the index of the source node in the rectangular area
        path_val = Path_val{1};
        Source = path_val(1,:);
        index_Source = (Source(2)-y1)*(x2-x1+1)+(Source(1)-x1+1);
        for j = 1:num_node
            path_val = Path_val{j};
            Destination = path_val(end,:);
            if ~(Destination(1)>=x1 && Destination(1)<=x2 && Destination(2)>=y1 && Destination(2)<=y2)
                Path_val{j} = [];
                continue
            end
            min_len_val = Min_len_val(j);
            index_Destination = (Destination(2)-y1)*(x2-x1+1)+(Destination(1)-x1+1);
            if index_Destination<index_Source
                Path_val_new{index_Destination} = path_val;
                Min_len_val_new(index_Destination) = min_len_val;
            else
                Path_val_new{index_Destination-1} = path_val;
                Min_len_val_new(index_Destination-1) = min_len_val;
            end
        end
        Path_new{i,1} = Path_val_new;
        Min_len_new{i,1} = Min_len_val_new;
    end
end

end

