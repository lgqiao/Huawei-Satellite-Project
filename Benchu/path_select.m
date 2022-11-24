function [path_expand,path,min_len,flag] = path_select(Path_expand,W)
%LENGTH_PATH: Calculate the length of each path and select the one with the shortest length


global V

[max_x,max_y] = size(W);
num_path = length(Path_expand);
min_len = 1000000;

for i = 1:num_path
    len = 0;
    path_expand1 = Path_expand{i};
    path1 = [];
    path1(:,1) = mod(path_expand1(:,1),max_x);
    path1(:,2) = mod(path_expand1(:,2),max_y);
    len_path = size(path1,1);
    for j = 2:len_path
        if path1(j,1)-path1(j-1,1)==0
            len = len+V;
        elseif path1(j,1)-path1(j-1,1)==1 || path1(j,1)-path1(j-1,1)==1-max_x
            len = len+W(path1(j-1,1)+1,path1(j-1,2)+1);
        elseif path1(j,1)-path1(j-1,1)==-1 || path1(j,1)-path1(j-1,1)==max_x-1
            len = len+W(path1(j,1)+1,path1(j,2)+1);
        end
    end
    if len<min_len
        path_expand = path_expand1;
        path = path1;
        min_len = len;
        flag = i;
    end
end
