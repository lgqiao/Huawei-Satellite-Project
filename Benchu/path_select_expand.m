function [Path1,Path_expand1,Min_len1,Destination] = path_select_expand(Path_expand,Min_len,W)
%PATH_SELECT_EXPAND: Compare the paths from the source node to the nodes in each sub-region, 
%                    and select the shortest path


[max_x,max_y] = size(W);
num_path = length(Path_expand);
MAP = 2*ones(max_x,max_y);
Destination = [];
k = 0;

for i = 1:num_path
    path_expand = Path_expand{i};
    min_len = Min_len(i);
    xDestination = mod(path_expand(end,1),max_x);
    yDestination = mod(path_expand(end,2),max_y);
    if MAP(xDestination+1,yDestination+1)==2
        k = k+1;
        Destination(k,:) = [xDestination,yDestination];
        Path_expand1(k) = {path_expand};
        path = [];
        path(:,1) = mod(path_expand(:,1),max_x);
        path(:,2) = mod(path_expand(:,2),max_y);
        Path1(k) = {path};
        Min_len1(k) = min_len;
        MAP(xDestination+1,yDestination+1) = 1;
    elseif MAP(xDestination+1,yDestination+1)==1
        index = 1;
        while Destination(index,1)~=xDestination || Destination(index,2)~=yDestination
            index = index+1;
        end
        if min_len<Min_len1(index)
            Path_expand1(index) = {path_expand};
            path = [];
            path(:,1) = mod(path_expand(:,1),max_x);
            path(:,2) = mod(path_expand(:,2),max_y);
            Path1(index) = {path};
            Min_len1(index) = min_len;
        end
    end
end

end
