function [Path,Len] = path_generate_hor(area_1,area_2,W)
%PATH_GENERATE_HOR: Generate horizontal paths within an area  


% if it is forward, 1 = left, 2 = right
% if it is reverse, 1 = right, 2 = left
Path = {};
Len = [];
num_row = size(area_1,1);
num_point = 0;

for i = 1:num_row
    [path,len] = path_generate1(area_1(i,1),area_1(i,2),area_2(i,1),area_2(i,2),W,1);
    len_path = size(path,1);
    for j = 1:len_path
        num_point = num_point+1;
        Path(num_point) = {path(2:j,:)}; 
        Len(num_point) = sum(len(1:j-1));
    end
end

end

