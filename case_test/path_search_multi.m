function [Path,Path_expand,Min_len,T] = path_search_multi(vertex,Source,W,t,type)
%DIJKSTRA_SEARCH_MULTI: Calculate the shortest path of message forwarding between
%                       satellites, multiple destination nodes


x1 = vertex(1);
y1 = vertex(2);
x2 = vertex(3);
y2 = vertex(4);

k = 0;
x_s = Source(1);
y_s = Source(2);
Destination = [];

for i = x1:x2
    for j = y1:y2
        k = k+1;
        Destination(k,:) = [i,j];
    end
end

index_Source = (y2-y1+1)*(x_s-x1)+y_s-y1+1;
Destination(index_Source,:) = [];

% Source = [x1,y1];
% Destination = [];
% 
% dx = x2-x1;
% dy = y2-y1;
% 
% if dx==0 || dy==0 % segment area
%     if dy>0 || dx>0
%         for i = x1:x2
%             for j = y1:y2
%                 Destination = [Destination;i,j];
%             end
%         end
%     elseif dy<0 || dx<0
%         for i = x2:x1
%             for j = y2:y1
%                 Destination = [Destination;i,j];
%             end
%         end
%     end
% else % rectangular area
%     k_l = dy/dx; % slope
%     if k_l>0 % Along the peak and valley direction
%         if dy>0 % Forward
%             for i = x1:x2
%                 for j = y1:y2
%                     Destination = [Destination;i,j];
%                 end
%             end
%         elseif dy<0 % Reverse
%             for i = x1:-1:x2
%                 for j = y1:-1:y2
%                     Destination = [Destination;i,j];
%                 end
%             end
%         end
%     elseif k_l<0 % Not along the peak and valley direction
%         if dy<0 % Forward
%             for i = x1:x2
%                 for j = y1:-1:y2
%                     Destination = [Destination;i,j];
%                 end
%             end
%         elseif dy>0 % Reverse
%             for i = x1:-1:x2
%                 for j = y1:y2
%                     Destination = [Destination;i,j];
%                 end
%             end
%         end
%     end
% end
% 
% Destination(1,:) = []; % The destination node should not be the source node

% Initialize the shortest path and its length
Path = {};
Path_expand = {};
Min_len = [];

map = map_construct_multi(W,Source,Destination); 
num_pair = size(map,3); % The number of source and destination pairs

% Choose an algorithm to compute the shortest path
% type = 1: Dijkstra_search
% type = 2: Dijkstra_expand
% type = 3: my_search
% type = 4: my_expand
if type==1
    tic 
    for i = 1:num_pair
        [path,min_len] = Dijkstra_search(map(:,:,i),W);
        Path(i) = {path};
        Min_len = [Min_len,min_len];
    end
    T = toc;
elseif type==2
    tic 
    for i = 1:num_pair
        [path,min_len] = Dijkstra_expand(map(:,:,i),W);
        Path(i) = {path};
        Min_len = [Min_len,min_len];
    end
    T = toc;
elseif type==3
    tic
    for i = 1:num_pair
        [path,min_len] = my_search(map(:,:,i),W,t);
        Path(i) = {path};
        Min_len = [Min_len,min_len];
    end
    T = toc;
elseif type==4
    tic
    for i = 1:num_pair
        [~,path_expand,path,min_len] = my_expand(map(:,:,i),W,t);
        Path_expand(i) = {path_expand};
        Path(i) = {path};
        Min_len = [Min_len,min_len];
    end
    T = toc;
end

end

