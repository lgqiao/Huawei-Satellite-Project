function [point_hor,point_ver] = valley_boundary(path_valley,yDestination)
%VALLEY_BOUNDARY: Calculate the right boundary point and the lower boundary 
%                 point of the valley line  


% if it is forward, point_hor = point_right, point_ver = point_bottom
% if it is reverse, point_hor = point_left, point_ver = point_top
x_s = path_valley(1,1);
x_d = path_valley(end,1);
dx = x_d-x_s;
point_ver = [];
row_ver = [];
if path_valley(end,2)==yDestination
    if dx>0
        dx = dx-1;
    elseif dx<0
        dx = dx+1;
    end
end
if dx>=0 % forward
    for i = 0:dx
        row = find(path_valley(:,1)==x_s+i);
        max_row = max(row);
        row_ver = [row_ver,max_row];
        point_ver = [point_ver;path_valley(max_row,:)];
    end
elseif dx<0 % reverse
    for i = 0:-dx
        row = find(path_valley(:,1)==x_s-i);
        max_row = max(row);
        row_ver = [row_ver,max_row];
        point_ver = [point_ver;path_valley(max_row,:)];
    end
end
path_valley(row_ver,:) = [];
point_hor = path_valley;

end
