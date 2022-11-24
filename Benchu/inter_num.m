function [num_ver,num_hor] = inter_num(inter,xSource)
%INTER_NUM: Count the number of intersections that fall on the four sides of the rectangle


num_inter = size(inter,1);

% if it is forward, num_ver = num_left, num_hor = num_top
% if it is reverse, num_ver = num_right, num_hor = num_bottom
num_ver = 0;
num_hor = 0;

for i = 1:num_inter
    if inter(i,1)==xSource
        num_ver = num_ver+1;
    else
        num_hor = num_hor+1;
    end
end

end

