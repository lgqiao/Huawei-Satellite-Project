function Destination = Dijkstra_node(vertex,Source,W,t)
%DIJKSTRA_NODE: Determines which vertex of the rectangle is the farthest 
%               from the source node within the rectangle.
% vertex = (x1,y1,x2,y2)


Destination = [];

num_area = size(vertex,1);
num_node = size(Source,1);

if num_area==1 % a rectangle
    x1 = vertex(1);
    y1 = vertex(2);
    x2 = vertex(3);
    y2 = vertex(4);
    destination(1,:) = [x2,y1];
    destination(2,:) = [x1,y1];
    destination(3,:) = [x1,y2];
    destination(4,:) = [x2,y2];
    for i = 1:num_node
        min_len = [];
        for j = 1:4
            map = map_construct(W,Source(i,:),destination(j,:));
            [~,min_len1] = my_search(map,W,t);
            min_len = [min_len,min_len1];
        end
        [~,I] = max(min_len);
        Destination(i,:) = destination(I,:);
    end
else % multiple rectangles, num_area = num_node
    for i = 1:num_node
        x1 = vertex(i,1);
        y1 = vertex(i,2);
        x2 = vertex(i,3);
        y2 = vertex(i,4);
        destination(1,:) = [x2,y1];
        destination(2,:) = [x1,y1];
        destination(3,:) = [x1,y2];
        destination(4,:) = [x2,y2];
        min_len = [];
        for j = 1:4
            map = map_construct(W,Source(i,:),destination(j,:));
            [~,min_len1] = my_search(map,W,t);
            min_len = [min_len,min_len1];
        end
        [~,I] = max(min_len);
        Destination(i,:) = destination(I,:);
    end
end

end
