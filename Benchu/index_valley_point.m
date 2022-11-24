function [index_hor,index_ver] = index_valley_point(path_valley,point_hor,point_ver)
%INDEX_VALLEY_POINT: Calculate the index of the horizontal and vertical points of the valley or peak line


% if it is forward, hor = right, ver = bottom
% if it is reverse, hor = left, ver = top
index_hor = [];
index_ver = [];

sz_right = size(point_hor,1);
sz_bottom = size(point_ver,1);

% index_right
index = 1;
for i = 1:sz_right
    while path_valley(index,1)~=point_hor(i,1) || path_valley(index,2)~=point_hor(i,2)
        index = index+1;
    end
    index_hor = [index_hor;index];
end

% index bottom
index = 1;
for i = 1:sz_bottom
    while path_valley(index,1)~=point_ver(i,1) || path_valley(index,2)~=point_ver(i,2)
        index = index+1;
    end
    index_ver = [index_ver;index];
end

end

